class CryptoHolding {
  final int? id;
  final String symbol;
  final String name;
  final double quantity;
  final double averagePrice;
  final double currentPrice;
  final DateTime purchaseDate;

  CryptoHolding({
    this.id,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.purchaseDate,
  });

  double get totalValue => quantity * currentPrice;
  double get totalInvestment => quantity * averagePrice;
  double get gainLoss => totalValue - totalInvestment;
  double get gainLossPercent => totalInvestment > 0 ? (gainLoss / totalInvestment) * 100 : 0;
  bool get isProfit => gainLoss >= 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'quantity': quantity,
      'averagePrice': averagePrice,
      'currentPrice': currentPrice,
      'purchaseDate': purchaseDate.millisecondsSinceEpoch,
    };
  }

  factory CryptoHolding.fromMap(Map<String, dynamic> map) {
    return CryptoHolding(
      id: map['id'],
      symbol: map['symbol'],
      name: map['name'],
      quantity: map['quantity'],
      averagePrice: map['averagePrice'],
      currentPrice: map['currentPrice'],
      purchaseDate: DateTime.fromMillisecondsSinceEpoch(map['purchaseDate']),
    );
  }

  CryptoHolding copyWith({
    int? id,
    String? symbol,
    String? name,
    double? quantity,
    double? averagePrice,
    double? currentPrice,
    DateTime? purchaseDate,
  }) {
    return CryptoHolding(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      averagePrice: averagePrice ?? this.averagePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
    );
  }
}
