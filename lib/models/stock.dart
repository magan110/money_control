class Stock {
  final String symbol;
  final String name;
  final double currentPrice;
  final double changeAmount;
  final double changePercent;
  final double dayHigh;
  final double dayLow;
  final double openPrice;
  final double previousClose;
  final int volume;
  final double marketCap;
  final String sector;

  Stock({
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.changeAmount,
    required this.changePercent,
    required this.dayHigh,
    required this.dayLow,
    required this.openPrice,
    required this.previousClose,
    required this.volume,
    required this.marketCap,
    required this.sector,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0.0).toDouble(),
      changeAmount: (json['changeAmount'] ?? 0.0).toDouble(),
      changePercent: (json['changePercent'] ?? 0.0).toDouble(),
      dayHigh: (json['dayHigh'] ?? 0.0).toDouble(),
      dayLow: (json['dayLow'] ?? 0.0).toDouble(),
      openPrice: (json['openPrice'] ?? 0.0).toDouble(),
      previousClose: (json['previousClose'] ?? 0.0).toDouble(),
      volume: json['volume'] ?? 0,
      marketCap: (json['marketCap'] ?? 0.0).toDouble(),
      sector: json['sector'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'currentPrice': currentPrice,
      'changeAmount': changeAmount,
      'changePercent': changePercent,
      'dayHigh': dayHigh,
      'dayLow': dayLow,
      'openPrice': openPrice,
      'previousClose': previousClose,
      'volume': volume,
      'marketCap': marketCap,
      'sector': sector,
    };
  }

  bool get isPositive => changeAmount >= 0;
}
