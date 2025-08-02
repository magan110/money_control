enum AssetType { stocks, mutualFunds, ulips, bullion, fixedIncome, loans }

class MultiAssetHolding {
  final int? id;
  final String symbol;
  final String name;
  final AssetType assetType;
  final double quantity;
  final double averagePrice;
  final double currentPrice;
  final DateTime purchaseDate;
  final Map<String, dynamic>? additionalData;

  MultiAssetHolding({
    this.id,
    required this.symbol,
    required this.name,
    required this.assetType,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.purchaseDate,
    this.additionalData,
  });

  double get totalValue => quantity * currentPrice;
  double get totalInvestment => quantity * averagePrice;
  double get gainLoss => totalValue - totalInvestment;
  double get gainLossPercent => (gainLoss / totalInvestment) * 100;
  bool get isProfit => gainLoss >= 0;

  String get assetTypeDisplayName {
    switch (assetType) {
      case AssetType.stocks:
        return 'Stocks';
      case AssetType.mutualFunds:
        return 'Mutual Funds';
      case AssetType.ulips:
        return 'ULIPs';
      case AssetType.bullion:
        return 'Bullion';
      case AssetType.fixedIncome:
        return 'Fixed Income';
      case AssetType.loans:
        return 'Loans';
    }
  }

  factory MultiAssetHolding.fromMap(Map<String, dynamic> map) {
    return MultiAssetHolding(
      id: map['id'],
      symbol: map['symbol'],
      name: map['name'],
      assetType: AssetType.values[map['assetType']],
      quantity: map['quantity'].toDouble(),
      averagePrice: map['averagePrice'].toDouble(),
      currentPrice: map['currentPrice'].toDouble(),
      purchaseDate: DateTime.fromMillisecondsSinceEpoch(map['purchaseDate']),
      additionalData: map['additionalData'] != null 
          ? Map<String, dynamic>.from(map['additionalData']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'assetType': assetType.index,
      'quantity': quantity,
      'averagePrice': averagePrice,
      'currentPrice': currentPrice,
      'purchaseDate': purchaseDate.millisecondsSinceEpoch,
      'additionalData': additionalData,
    };
  }

  MultiAssetHolding copyWith({
    int? id,
    String? symbol,
    String? name,
    AssetType? assetType,
    double? quantity,
    double? averagePrice,
    double? currentPrice,
    DateTime? purchaseDate,
    Map<String, dynamic>? additionalData,
  }) {
    return MultiAssetHolding(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      assetType: assetType ?? this.assetType,
      quantity: quantity ?? this.quantity,
      averagePrice: averagePrice ?? this.averagePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
