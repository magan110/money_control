class Budget {
  final int? id;
  final int categoryId;
  final double amount;
  final BudgetPeriod period;
  final double spent;
  final DateTime startDate;

  Budget({
    this.id,
    required this.categoryId,
    required this.amount,
    required this.period,
    this.spent = 0.0,
    required this.startDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'amount': amount,
      'period': period.index,
      'spent': spent,
      'startDate': startDate.millisecondsSinceEpoch,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      categoryId: map['categoryId'],
      amount: map['amount'],
      period: BudgetPeriod.values[map['period']],
      spent: map['spent'] ?? 0.0,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
    );
  }

  Budget copyWith({
    int? id,
    int? categoryId,
    double? amount,
    BudgetPeriod? period,
    double? spent,
    DateTime? startDate,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
    );
  }

  double get remainingAmount => amount - spent;
  double get progressPercentage => spent / amount;
  bool get isOverBudget => spent > amount;
}

enum BudgetPeriod { weekly, monthly, yearly }
