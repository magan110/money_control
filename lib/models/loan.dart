class Loan {
  final String id;
  final String type;
  final double amount;
  final double interestRate;
  final int tenure;
  final double emi;
  final DateTime applicationDate;
  final String status;
  final String provider;

  Loan({
    required this.id,
    required this.type,
    required this.amount,
    required this.interestRate,
    required this.tenure,
    required this.emi,
    required this.applicationDate,
    required this.status,
    required this.provider,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'interestRate': interestRate,
      'tenure': tenure,
      'emi': emi,
      'applicationDate': applicationDate.millisecondsSinceEpoch,
      'status': status,
      'provider': provider,
    };
  }

  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      interestRate: map['interestRate'],
      tenure: map['tenure'],
      emi: map['emi'],
      applicationDate: DateTime.fromMillisecondsSinceEpoch(map['applicationDate']),
      status: map['status'],
      provider: map['provider'],
    );
  }
}
