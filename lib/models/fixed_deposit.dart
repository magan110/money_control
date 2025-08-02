class FixedDeposit {
  final String id;
  final String bankName;
  final double amount;
  final double interestRate;
  final int tenure;
  final DateTime startDate;
  final DateTime maturityDate;
  final double maturityAmount;
  final String status;

  FixedDeposit({
    required this.id,
    required this.bankName,
    required this.amount,
    required this.interestRate,
    required this.tenure,
    required this.startDate,
    required this.maturityDate,
    required this.maturityAmount,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bankName': bankName,
      'amount': amount,
      'interestRate': interestRate,
      'tenure': tenure,
      'startDate': startDate.millisecondsSinceEpoch,
      'maturityDate': maturityDate.millisecondsSinceEpoch,
      'maturityAmount': maturityAmount,
      'status': status,
    };
  }

  factory FixedDeposit.fromMap(Map<String, dynamic> map) {
    return FixedDeposit(
      id: map['id'],
      bankName: map['bankName'],
      amount: map['amount'],
      interestRate: map['interestRate'],
      tenure: map['tenure'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      maturityDate: DateTime.fromMillisecondsSinceEpoch(map['maturityDate']),
      maturityAmount: map['maturityAmount'],
      status: map['status'],
    );
  }
}
