import 'package:flutter/material.dart';

class ResearchInsight {
  final String id;
  final String symbol;
  final String companyName;
  final String recommendation;
  final double targetPrice;
  final double currentPrice;
  final String analyst;
  final DateTime publishedAt;
  final String summary;
  final String fullReport;

  ResearchInsight({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.recommendation,
    required this.targetPrice,
    required this.currentPrice,
    required this.analyst,
    required this.publishedAt,
    required this.summary,
    required this.fullReport,
  });

  double get upside => ((targetPrice - currentPrice) / currentPrice) * 100;

  Color get recommendationColor {
    switch (recommendation.toUpperCase()) {
      case 'BUY':
        return const Color(0xFF4CAF50);
      case 'SELL':
        return const Color(0xFFF44336);
      case 'HOLD':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  factory ResearchInsight.fromJson(Map<String, dynamic> json) {
    return ResearchInsight(
      id: json['id'],
      symbol: json['symbol'],
      companyName: json['companyName'],
      recommendation: json['recommendation'],
      targetPrice: json['targetPrice'].toDouble(),
      currentPrice: json['currentPrice'].toDouble(),
      analyst: json['analyst'],
      publishedAt: DateTime.parse(json['publishedAt']),
      summary: json['summary'],
      fullReport: json['fullReport'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'companyName': companyName,
      'recommendation': recommendation,
      'targetPrice': targetPrice,
      'currentPrice': currentPrice,
      'analyst': analyst,
      'publishedAt': publishedAt.toIso8601String(),
      'summary': summary,
      'fullReport': fullReport,
    };
  }
}
