import 'package:flutter/foundation.dart';
import '../models/fo_contract.dart';

class FOProvider with ChangeNotifier {
  List<FOContract> _contracts = [];
  bool _isLoading = false;
  String _selectedExpiry = '';
  String _selectedInstrument = 'FUTIDX';

  List<FOContract> get contracts => _contracts;
  bool get isLoading => _isLoading;
  String get selectedExpiry => _selectedExpiry;
  String get selectedInstrument => _selectedInstrument;

  List<String> get availableExpiries {
    return _contracts.map((c) => c.expiryDate).toSet().toList()..sort();
  }

  List<FOContract> get filteredContracts {
    return _contracts.where((contract) {
      bool matchesInstrument = _selectedInstrument.isEmpty || 
                              contract.instrumentType == _selectedInstrument;
      bool matchesExpiry = _selectedExpiry.isEmpty || 
                          contract.expiryDate == _selectedExpiry;
      return matchesInstrument && matchesExpiry;
    }).toList();
  }

  Future<void> loadFOData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _contracts = _generateMockFOData();
      if (_selectedExpiry.isEmpty && availableExpiries.isNotEmpty) {
        _selectedExpiry = availableExpiries.first;
      }
    } catch (e) {
      debugPrint('Error loading F&O data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedExpiry(String expiry) {
    _selectedExpiry = expiry;
    notifyListeners();
  }

  void setSelectedInstrument(String instrument) {
    _selectedInstrument = instrument;
    notifyListeners();
  }

  List<FOContract> _generateMockFOData() {
    final now = DateTime.now();
    final expiry1 = DateTime(now.year, now.month, 28);
    
    return [
      FOContract(
        symbol: 'NIFTY',
        instrumentType: 'FUTIDX',
        expiryDate: '${expiry1.day}-${expiry1.month.toString().padLeft(2, '0')}-${expiry1.year}',
        lastPrice: 19850.50,
        changeAmount: 125.30,
        changePercent: 0.63,
        volume: 2450000,
        openInterest: 1850000,
        impliedVolatility: 0.0,
      ),
      FOContract(
        symbol: 'BANKNIFTY',
        instrumentType: 'FUTIDX',
        expiryDate: '${expiry1.day}-${expiry1.month.toString().padLeft(2, '0')}-${expiry1.year}',
        lastPrice: 44250.75,
        changeAmount: -85.25,
        changePercent: -0.19,
        volume: 1850000,
        openInterest: 1250000,
        impliedVolatility: 0.0,
      ),
      FOContract(
        symbol: 'NIFTY',
        instrumentType: 'OPTIDX',
        expiryDate: '${expiry1.day}-${expiry1.month.toString().padLeft(2, '0')}-${expiry1.year}',
        strikePrice: 19900,
        optionType: 'CE',
        lastPrice: 125.50,
        changeAmount: 15.25,
        changePercent: 13.83,
        volume: 850000,
        openInterest: 650000,
        impliedVolatility: 18.5,
      ),
      FOContract(
        symbol: 'NIFTY',
        instrumentType: 'OPTIDX',
        expiryDate: '${expiry1.day}-${expiry1.month.toString().padLeft(2, '0')}-${expiry1.year}',
        strikePrice: 19800,
        optionType: 'PE',
        lastPrice: 85.75,
        changeAmount: -12.50,
        changePercent: -12.72,
        volume: 750000,
        openInterest: 580000,
        impliedVolatility: 16.8,
      ),
      FOContract(
        symbol: 'RELIANCE',
        instrumentType: 'FUTSTK',
        expiryDate: '${expiry1.day}-${expiry1.month.toString().padLeft(2, '0')}-${expiry1.year}',
        lastPrice: 2485.30,
        changeAmount: 18.75,
        changePercent: 0.76,
        volume: 125000,
        openInterest: 95000,
        impliedVolatility: 0.0,
      ),
      FOContract(
        symbol: 'RELIANCE',
        instrumentType: 'OPTSTK',
        expiryDate: '${expiry1.day}-${expiry1.month.toString().padLeft(2, '0')}-${expiry1.year}',
        strikePrice: 2500,
        optionType: 'CE',
        lastPrice: 45.25,
        changeAmount: 8.50,
        changePercent: 23.13,
        volume: 85000,
        openInterest: 65000,
        impliedVolatility: 22.3,
      ),
    ];
  }
}
