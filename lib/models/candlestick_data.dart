class CandlestickData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  CandlestickData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  bool get isPositive => close >= open;
  
  double get change => close - open;
  
  double get changePercent => ((close - open) / open) * 100;

  factory CandlestickData.fromJson(Map<String, dynamic> json) {
    return CandlestickData(
      time: DateTime.parse(json['time'] ?? DateTime.now().toIso8601String()),
      open: (json['open'] ?? 0.0).toDouble(),
      high: (json['high'] ?? 0.0).toDouble(),
      low: (json['low'] ?? 0.0).toDouble(),
      close: (json['close'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'open': open,
      'high': high,
      'low': low,
      'close': close,
    };
  }
}
