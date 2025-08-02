class Transaction {
  final int? id;
  final double amount;
  final String description;
  final int categoryId;
  final DateTime date;
  final TransactionType type;
  final int? accountId;

  Transaction({
    this.id,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.date,
    required this.type,
    this.accountId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'categoryId': categoryId,
      'date': date.millisecondsSinceEpoch,
      'type': type.index,
      'accountId': accountId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      categoryId: map['categoryId'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      type: TransactionType.values[map['type']],
      accountId: map['accountId'],
    );
  }

  Transaction copyWith({
    int? id,
    double? amount,
    String? description,
    int? categoryId,
    DateTime? date,
    TransactionType? type,
    int? accountId,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      type: type ?? this.type,
      accountId: accountId ?? this.accountId,
    );
  }
}

enum TransactionType { income, expense }
