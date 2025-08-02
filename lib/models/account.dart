class Account {
  final int? id;
  final String name;
  final double balance;
  final AccountType type;
  final String? description;

  Account({
    this.id,
    required this.name,
    required this.balance,
    required this.type,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'type': type.index,
      'description': description,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      balance: map['balance'],
      type: AccountType.values[map['type']],
      description: map['description'],
    );
  }

  Account copyWith({
    int? id,
    String? name,
    double? balance,
    AccountType? type,
    String? description,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}

enum AccountType { cash, checking, savings, credit }
