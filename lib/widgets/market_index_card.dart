import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/market_index.dart';

class MarketIndexCard extends StatelessWidget {
  final MarketIndex index;

  const MarketIndexCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0.00');
    final changeColor = index.isPositive ? Colors.green : Colors.red;
    final changeIcon = index.isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            index.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currencyFormat.format(index.value),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                changeIcon,
                size: 16,
                color: changeColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${index.isPositive ? '+' : ''}${currencyFormat.format(index.change)}',
                style: TextStyle(
                  fontSize: 12,
                  color: changeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            '${index.isPositive ? '+' : ''}${index.changePercent.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 12,
              color: changeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
