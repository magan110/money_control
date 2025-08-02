import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/research_insight.dart';

class ResearchInsightCard extends StatelessWidget {
  final ResearchInsight insight;

  const ResearchInsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0.00');
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.symbol,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        insight.companyName,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: insight.recommendationColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    insight.recommendation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPriceInfo(
                    'Current Price',
                    '₹${currencyFormat.format(insight.currentPrice)}',
                  ),
                ),
                Expanded(
                  child: _buildPriceInfo(
                    'Target Price',
                    '₹${currencyFormat.format(insight.targetPrice)}',
                  ),
                ),
                Expanded(
                  child: _buildPriceInfo(
                    'Upside',
                    '${insight.upside.toStringAsFixed(1)}%',
                    color: insight.upside >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              insight.summary,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'By ${insight.analyst}',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  dateFormat.format(insight.publishedAt),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
