import 'package:flutter/foundation.dart';
import '../models/stock.dart';
import '../services/api_service.dart';

class StockProvider with ChangeNotifier {
  List<Stock> _stocks = [];
  final List<Stock> _watchlist = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Stock> get stocks => _stocks;
  List<Stock> get watchlist => _watchlist;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<Stock> get filteredStocks {
    if (_searchQuery.isEmpty) return _stocks;
    return _stocks.where((stock) =>
        stock.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        stock.symbol.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  Future<void> loadStocks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stocks = await ApiService.getStocks();
    } catch (e) {
      debugPrint('Error loading stocks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addToWatchlist(Stock stock) {
    if (!_watchlist.any((s) => s.symbol == stock.symbol)) {
      _watchlist.add(stock);
      notifyListeners();
    }
  }

  void removeFromWatchlist(String symbol) {
    _watchlist.removeWhere((stock) => stock.symbol == symbol);
    notifyListeners();
  }

  bool isInWatchlist(String symbol) {
    return _watchlist.any((stock) => stock.symbol == symbol);
  }

  Stock? getStockBySymbol(String symbol) {
    try {
      return _stocks.firstWhere((stock) => stock.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  List<Stock> getTopGainers() {
    var sortedStocks = List<Stock>.from(_stocks);
    sortedStocks.sort((a, b) => b.changePercent.compareTo(a.changePercent));
    return sortedStocks.take(5).toList();
  }

  List<Stock> getTopLosers() {
    var sortedStocks = List<Stock>.from(_stocks);
    sortedStocks.sort((a, b) => a.changePercent.compareTo(b.changePercent));
    return sortedStocks.take(5).toList();
  }
}
