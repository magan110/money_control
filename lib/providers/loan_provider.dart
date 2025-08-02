import 'package:flutter/foundation.dart';
import '../models/loan.dart';

class LoanProvider with ChangeNotifier {
  List<Loan> _loans = [];
  bool _isLoading = false;

  List<Loan> get loans => _loans;
  bool get isLoading => _isLoading;

  Future<void> loadLoans() async {
    _isLoading = true;
    notifyListeners();

    try {
      _loans = [
        Loan(
          id: '1',
          type: 'Personal Loan',
          amount: 500000,
          interestRate: 12.5,
          tenure: 36,
          emi: 16680,
          applicationDate: DateTime.now().subtract(const Duration(days: 30)),
          status: 'Approved',
          provider: 'HDFC Bank',
        ),
        Loan(
          id: '2',
          type: 'Business Loan',
          amount: 1000000,
          interestRate: 11.8,
          tenure: 60,
          emi: 22150,
          applicationDate: DateTime.now().subtract(const Duration(days: 15)),
          status: 'Under Review',
          provider: 'ICICI Bank',
        ),
      ];
    } catch (e) {
      debugPrint('Error loading loans: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyForLoan(Loan loan) async {
    _loans.add(loan);
    notifyListeners();
  }

  Future<void> updateLoanStatus(String loanId, String newStatus) async {
    final index = _loans.indexWhere((loan) => loan.id == loanId);
    if (index != -1) {
      final updatedLoan = Loan(
        id: _loans[index].id,
        type: _loans[index].type,
        amount: _loans[index].amount,
        interestRate: _loans[index].interestRate,
        tenure: _loans[index].tenure,
        emi: _loans[index].emi,
        applicationDate: _loans[index].applicationDate,
        status: newStatus,
        provider: _loans[index].provider,
      );
      _loans[index] = updatedLoan;
      notifyListeners();
    }
  }
}
