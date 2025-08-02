import 'package:flutter/foundation.dart';
import '../models/market_index.dart';
import '../services/mock_data_service.dart';

class MarketProvider with ChangeNotifier {
  List<MarketIndex> _indices = [];
  bool _isLoading = false;

  List<MarketIndex> get indices => _indices;
  bool get isLoading => _isLoading;

  Future<void> loadMarketData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _indices = MockDataService.getMockIndices();
    } catch (e) {
      debugPrint('Error loading market data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  MarketIndex? getIndexBySymbol(String symbol) {
    try {
      return _indices.firstWhere((index) => index.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  bool get isMarketUp {
    if (_indices.isEmpty) return true;
    final sensex = getIndexBySymbol('BSE:SENSEX');
    return sensex?.isPositive ?? true;
  }
}
