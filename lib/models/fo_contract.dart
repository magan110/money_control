class FOContract {
  final String symbol;
  final String instrumentType;
  final String expiryDate;
  final double? strikePrice;
  final String? optionType;
  final double lastPrice;
  final double changeAmount;
  final double changePercent;
  final int volume;
  final int openInterest;
  final double impliedVolatility;

  FOContract({
    required this.symbol,
    required this.instrumentType,
    required this.expiryDate,
    this.strikePrice,
    this.optionType,
    required this.lastPrice,
    required this.changeAmount,
    required this.changePercent,
    required this.volume,
    required this.openInterest,
    required this.impliedVolatility,
  });

  bool get isPositive => changeAmount >= 0;

  factory FOContract.fromJson(Map<String, dynamic> json) {
    return FOContract(
      symbol: json['symbol'],
      instrumentType: json['instrumentType'],
      expiryDate: json['expiryDate'],
      strikePrice: json['strikePrice']?.toDouble(),
      optionType: json['optionType'],
      lastPrice: json['lastPrice'].toDouble(),
      changeAmount: json['changeAmount'].toDouble(),
      changePercent: json['changePercent'].toDouble(),
      volume: json['volume'],
      openInterest: json['openInterest'],
      impliedVolatility: json['impliedVolatility'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'instrumentType': instrumentType,
      'expiryDate': expiryDate,
      'strikePrice': strikePrice,
      'optionType': optionType,
      'lastPrice': lastPrice,
      'changeAmount': changeAmount,
      'changePercent': changePercent,
      'volume': volume,
      'openInterest': openInterest,
      'impliedVolatility': impliedVolatility,
    };
  }
}
