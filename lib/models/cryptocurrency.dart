class Cryptocurrency {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double changeAmount;
  final double changePercent;
  final double dayHigh;
  final double dayLow;
  final double marketCap;
  final int marketCapRank;
  final double volume24h;
  final double circulatingSupply;
  final double totalSupply;
  final String image;

  Cryptocurrency({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.changeAmount,
    required this.changePercent,
    required this.dayHigh,
    required this.dayLow,
    required this.marketCap,
    required this.marketCapRank,
    required this.volume24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.image,
  });

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
    final price = (json['quote']?['USD']?['price'] ?? 0.0).toDouble();
    final changePercent = (json['quote']?['USD']?['percent_change_24h'] ?? 0.0).toDouble();
    final changeAmount = price * (changePercent / 100);
    
    return Cryptocurrency(
      id: json['id']?.toString() ?? '',
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      name: json['name'] ?? '',
      currentPrice: price,
      changeAmount: changeAmount,
      changePercent: changePercent,
      dayHigh: price * 1.05,
      dayLow: price * 0.95,
      marketCap: (json['quote']?['USD']?['market_cap'] ?? 0.0).toDouble(),
      marketCapRank: json['cmc_rank'] ?? 0,
      volume24h: (json['quote']?['USD']?['volume_24h'] ?? 0.0).toDouble(),
      circulatingSupply: (json['circulating_supply'] ?? 0.0).toDouble(),
      totalSupply: (json['total_supply'] ?? 0.0).toDouble(),
      image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/${json['id']}.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'currentPrice': currentPrice,
      'changeAmount': changeAmount,
      'changePercent': changePercent,
      'dayHigh': dayHigh,
      'dayLow': dayLow,
      'marketCap': marketCap,
      'marketCapRank': marketCapRank,
      'volume24h': volume24h,
      'circulatingSupply': circulatingSupply,
      'totalSupply': totalSupply,
      'image': image,
    };
  }

  bool get isPositive => changeAmount >= 0;
}
