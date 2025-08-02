import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import 'transaction_provider.dart';
import 'category_provider.dart';

class DashboardProvider with ChangeNotifier {
  final TransactionProvider _transactionProvider;
  // BudgetProvider removed as it's not used in this provider
  final CategoryProvider _categoryProvider;

  DashboardProvider(
    this._transactionProvider,
    this._categoryProvider,
  );

  double get totalBalance => _transactionProvider.balance;
  double get monthlyIncome => _getMonthlyTotal(TransactionType.income);
  double get monthlyExpenses => _getMonthlyTotal(TransactionType.expense);
  List<Transaction> get recentTransactions => _transactionProvider.getRecentTransactions();

  double _getMonthlyTotal(TransactionType type) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return _transactionProvider.transactions
        .where((t) =>
            t.type == type &&
            t.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
            t.date.isBefore(endOfMonth.add(const Duration(days: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<String, double> getCategorySpending() {
    final expenses = _transactionProvider.getTransactionsByType(TransactionType.expense);
    final categorySpending = <String, double>{};

    for (var transaction in expenses) {
      final category = _categoryProvider.getCategoryById(transaction.categoryId);
      if (category != null) {
        categorySpending[category.name] = 
            (categorySpending[category.name] ?? 0) + transaction.amount;
      }
    }

    return categorySpending;
  }

  List<Map<String, dynamic>> getMonthlyTrends() {
    final now = DateTime.now();
    final trends = <Map<String, dynamic>>[];

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final nextMonth = DateTime(now.year, now.month - i + 1, 1);

      final monthTransactions = _transactionProvider.transactions
          .where((t) => t.date.isAfter(month.subtract(const Duration(days: 1))) &&
                      t.date.isBefore(nextMonth))
          .toList();

      final income = monthTransactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);

      final expenses = monthTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

      trends.add({
        'month': month,
        'income': income,
        'expenses': expenses,
      });
    }

    return trends;
  }
}
