import 'package:flutter/foundation.dart';
import '../models/cryptocurrency.dart';
import '../models/crypto_holding.dart';
import '../services/api_service.dart';
import '../data/database_helper.dart';

class CryptoProvider with ChangeNotifier {
  List<Cryptocurrency> _cryptocurrencies = [];
  List<CryptoHolding> _cryptoHoldings = [];
  bool _isLoading = false;
  String _selectedTimeframe = '24h';

  List<Cryptocurrency> get cryptocurrencies => _cryptocurrencies;
  List<CryptoHolding> get cryptoHoldings => _cryptoHoldings;
  bool get isLoading => _isLoading;
  String get selectedTimeframe => _selectedTimeframe;

  double get totalCryptoValue => _cryptoHoldings.fold(0.0, (sum, holding) => sum + holding.totalValue);
  double get totalCryptoInvestment => _cryptoHoldings.fold(0.0, (sum, holding) => sum + holding.totalInvestment);
  double get totalCryptoGainLoss => totalCryptoValue - totalCryptoInvestment;
  double get totalCryptoGainLossPercent => totalCryptoInvestment > 0 ? (totalCryptoGainLoss / totalCryptoInvestment) * 100 : 0.0;
  bool get isOverallProfit => totalCryptoGainLoss >= 0;

  Future<void> loadCryptocurrencies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cryptocurrencies = await ApiService.getCryptocurrencies();
    } catch (e) {
      debugPrint('Error loading cryptocurrencies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCryptoPortfolio() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseHelper().database;
      final List<Map<String, dynamic>> maps = await db.query('crypto_holdings');
      _cryptoHoldings = List.generate(maps.length, (i) => CryptoHolding.fromMap(maps[i]));
      
      if (_cryptoHoldings.isEmpty) {
        await _addSampleCryptoHoldings();
      }
      
      await updateCryptoPrices();
    } catch (e) {
      debugPrint('Error loading crypto portfolio: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _addSampleCryptoHoldings() async {
    final sampleHoldings = [
      CryptoHolding(
        symbol: 'BTC',
        name: 'Bitcoin',
        quantity: 0.5,
        averagePrice: 42000.00,
        currentPrice: 43250.00,
        purchaseDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
      CryptoHolding(
        symbol: 'ETH',
        name: 'Ethereum',
        quantity: 2.0,
        averagePrice: 2700.00,
        currentPrice: 2650.00,
        purchaseDate: DateTime.now().subtract(const Duration(days: 45)),
      ),
      CryptoHolding(
        symbol: 'BNB',
        name: 'BNB',
        quantity: 10.0,
        averagePrice: 300.00,
        currentPrice: 315.75,
        purchaseDate: DateTime.now().subtract(const Duration(days: 60)),
      ),
    ];

    for (var holding in sampleHoldings) {
      await addCryptoHolding(holding);
    }
  }

  Future<void> addCryptoHolding(CryptoHolding holding) async {
    try {
      final db = await DatabaseHelper().database;
      await db.insert('crypto_holdings', holding.toMap());
      await loadCryptoPortfolio();
    } catch (e) {
      debugPrint('Error adding crypto holding: $e');
    }
  }

  Future<void> updateCryptoPrices() async {
    for (var holding in _cryptoHoldings) {
      try {
        final cryptos = await ApiService.getCryptocurrencies();
        final matchingCrypto = cryptos.firstWhere(
          (crypto) => crypto.symbol == holding.symbol,
          orElse: () => cryptos.first,
        );
        final updatedHolding = CryptoHolding(
          id: holding.id,
          symbol: holding.symbol,
          name: holding.name,
          quantity: holding.quantity,
          averagePrice: holding.averagePrice,
          currentPrice: matchingCrypto.currentPrice,
          purchaseDate: holding.purchaseDate,
        );
        final index = _cryptoHoldings.indexOf(holding);
        _cryptoHoldings[index] = updatedHolding;
      } catch (e) {
        debugPrint('Error updating price for ${holding.symbol}: $e');
      }
    }
    notifyListeners();
  }

  List<CryptoHolding> getTopCryptoPerformers() {
    var sortedHoldings = List<CryptoHolding>.from(_cryptoHoldings);
    sortedHoldings.sort((a, b) => b.gainLossPercent.compareTo(a.gainLossPercent));
    return sortedHoldings.take(3).toList();
  }

  void setSelectedTimeframe(String timeframe) {
    _selectedTimeframe = timeframe;
    notifyListeners();
  }
}
