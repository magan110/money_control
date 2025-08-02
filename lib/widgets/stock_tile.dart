import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/stock.dart';

class StockTile extends StatelessWidget {
  final Stock stock;
  final VoidCallback? onTap;

  const StockTile({super.key, required this.stock, this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0.00');
    final changeColor = stock.isPositive ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        title: Text(
          stock.symbol,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          stock.name,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${currencyFormat.format(stock.currentPrice)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  stock.isPositive ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: changeColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${stock.isPositive ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: changeColor,
                    fontWeight: FontWeight.w500,
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
}
