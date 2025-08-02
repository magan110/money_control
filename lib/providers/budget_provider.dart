import 'package:flutter/foundation.dart';
import '../models/budget.dart';
import '../data/budget_repository.dart';
import '../data/transaction_repository.dart';

class BudgetProvider with ChangeNotifier {
  final BudgetRepository _budgetRepository = BudgetRepository();
  final TransactionRepository _transactionRepository = TransactionRepository();
  List<Budget> _budgets = [];
  bool _isLoading = false;

  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;

  Future<void> loadBudgets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _budgets = await _budgetRepository.getAllBudgets();
      await _updateBudgetSpending();
    } catch (e) {
      debugPrint('Error loading budgets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateBudgetSpending() async {
    for (var budget in _budgets) {
      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate;

      switch (budget.period) {
        case BudgetPeriod.weekly:
          startDate = now.subtract(Duration(days: now.weekday - 1));
          endDate = startDate.add(const Duration(days: 6));
          break;
        case BudgetPeriod.monthly:
          startDate = DateTime(now.year, now.month, 1);
          endDate = DateTime(now.year, now.month + 1, 0);
          break;
        case BudgetPeriod.yearly:
          startDate = DateTime(now.year, 1, 1);
          endDate = DateTime(now.year, 12, 31);
          break;
      }

      final spent = await _transactionRepository.getTotalByCategoryAndDateRange(
        budget.categoryId,
        startDate,
        endDate,
      );

      await _budgetRepository.updateBudgetSpent(budget.id!, spent);
    }

    _budgets = await _budgetRepository.getAllBudgets();
  }

  Future<void> addBudget(Budget budget) async {
    try {
      await _budgetRepository.insertBudget(budget);
      await loadBudgets();
    } catch (e) {
      debugPrint('Error adding budget: $e');
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await _budgetRepository.updateBudget(budget);
      await loadBudgets();
    } catch (e) {
      debugPrint('Error updating budget: $e');
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      await _budgetRepository.deleteBudget(id);
      await loadBudgets();
    } catch (e) {
      debugPrint('Error deleting budget: $e');
    }
  }

  Budget? getBudgetByCategoryId(int categoryId) {
    try {
      return _budgets.firstWhere((b) => b.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  List<Budget> get overBudgets => _budgets.where((b) => b.isOverBudget).toList();
  double get totalBudgetAmount => _budgets.fold(0.0, (sum, b) => sum + b.amount);
  double get totalSpent => _budgets.fold(0.0, (sum, b) => sum + b.spent);
}
