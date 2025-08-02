import 'package:flutter/foundation.dart';
import '../models/fo_contract.dart';
import '../services/api_service.dart';

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
      _contracts = await ApiService.getFOContracts();
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

}
