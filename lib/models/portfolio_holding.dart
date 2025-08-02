class PortfolioHolding {
  final int? id;
  final String symbol;
  final String name;
  final int quantity;
  final double averagePrice;
  final double currentPrice;
  final DateTime purchaseDate;

  PortfolioHolding({
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
  double get gainLossPercent => (gainLoss / totalInvestment) * 100;
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

  factory PortfolioHolding.fromMap(Map<String, dynamic> map) {
    return PortfolioHolding(
      id: map['id'],
      symbol: map['symbol'],
      name: map['name'],
      quantity: map['quantity'],
      averagePrice: map['averagePrice'],
      currentPrice: map['currentPrice'],
      purchaseDate: DateTime.fromMillisecondsSinceEpoch(map['purchaseDate']),
    );
  }

  PortfolioHolding copyWith({
    int? id,
    String? symbol,
    String? name,
    int? quantity,
    double? averagePrice,
    double? currentPrice,
    DateTime? purchaseDate,
  }) {
    return PortfolioHolding(
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
