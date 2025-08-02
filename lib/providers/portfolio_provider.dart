import 'package:flutter/foundation.dart';
import '../models/portfolio_holding.dart';
import '../data/database_helper.dart';
import '../services/api_service.dart';

class PortfolioProvider with ChangeNotifier {
  List<PortfolioHolding> _holdings = [];
  bool _isLoading = false;

  List<PortfolioHolding> get holdings => _holdings;
  bool get isLoading => _isLoading;

  double get totalInvestment => _holdings.fold(0.0, (sum, holding) => sum + holding.totalInvestment);
  double get totalCurrentValue => _holdings.fold(0.0, (sum, holding) => sum + holding.totalValue);
  double get totalGainLoss => totalCurrentValue - totalInvestment;
  double get totalGainLossPercent => totalInvestment > 0 ? (totalGainLoss / totalInvestment) * 100 : 0.0;
  bool get isOverallProfit => totalGainLoss >= 0;

  Future<void> loadPortfolio() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> maps = await db.query('portfolio_holdings');
      _holdings = List.generate(maps.length, (i) => PortfolioHolding.fromMap(maps[i]));
      
      if (_holdings.isEmpty) {
        await _addSampleHoldings();
      }
      
      await updateCurrentPrices();
    } catch (e) {
      debugPrint('Error loading portfolio: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _addSampleHoldings() async {
    final sampleHoldings = [
      PortfolioHolding(
        symbol: 'RELIANCE',
        name: 'Reliance Industries Ltd',
        quantity: 50,
        averagePrice: 2400.00,
        currentPrice: 2456.75,
        purchaseDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
      PortfolioHolding(
        symbol: 'TCS',
        name: 'Tata Consultancy Services',
        quantity: 25,
        averagePrice: 3600.00,
        currentPrice: 3567.80,
        purchaseDate: DateTime.now().subtract(const Duration(days: 45)),
      ),
      PortfolioHolding(
        symbol: 'HDFCBANK',
        name: 'HDFC Bank Ltd',
        quantity: 100,
        averagePrice: 1650.00,
        currentPrice: 1678.45,
        purchaseDate: DateTime.now().subtract(const Duration(days: 60)),
      ),
    ];

    for (var holding in sampleHoldings) {
      await addHolding(holding);
    }
  }

  Future<void> addHolding(PortfolioHolding holding) async {
    try {
      final db = await DatabaseHelper().database;
      await db.insert('portfolio_holdings', holding.toMap());
      await loadPortfolio();
    } catch (e) {
      debugPrint('Error adding holding: $e');
    }
  }

  Future<void> updateHolding(PortfolioHolding holding) async {
    try {
      final db = await DatabaseHelper().database;
      await db.update(
        'portfolio_holdings',
        holding.toMap(),
        where: 'id = ?',
        whereArgs: [holding.id],
      );
      await loadPortfolio();
    } catch (e) {
      debugPrint('Error updating holding: $e');
    }
  }

  Future<void> deleteHolding(int id) async {
    try {
      final db = await DatabaseHelper().database;
      await db.delete(
        'portfolio_holdings',
        where: 'id = ?',
        whereArgs: [id],
      );
      await loadPortfolio();
    } catch (e) {
      debugPrint('Error deleting holding: $e');
    }
  }

  List<PortfolioHolding> getTopPerformers() {
    var sortedHoldings = List<PortfolioHolding>.from(_holdings);
    sortedHoldings.sort((a, b) => b.gainLossPercent.compareTo(a.gainLossPercent));
    return sortedHoldings.take(3).toList();
  }

  List<PortfolioHolding> getWorstPerformers() {
    var sortedHoldings = List<PortfolioHolding>.from(_holdings);
    sortedHoldings.sort((a, b) => a.gainLossPercent.compareTo(b.gainLossPercent));
    return sortedHoldings.take(3).toList();
  }

  Future<void> updateCurrentPrices() async {
    for (var holding in _holdings) {
      try {
        final stocks = await ApiService.getStocks();
        final matchingStock = stocks.firstWhere(
          (stock) => stock.symbol == holding.symbol,
          orElse: () => stocks.first,
        );
        // Create a new holding with updated price since currentPrice is final
        final updatedHolding = PortfolioHolding(
          id: holding.id,
          symbol: holding.symbol,
          name: holding.name,
          quantity: holding.quantity,
          averagePrice: holding.averagePrice,
          currentPrice: matchingStock.currentPrice,
          purchaseDate: holding.purchaseDate,
        );
        final index = _holdings.indexOf(holding);
        _holdings[index] = updatedHolding;
      } catch (e) {
        debugPrint('Error updating price for ${holding.symbol}: $e');
      }
    }
    notifyListeners();
  }
}
