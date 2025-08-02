import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/fo_contract.dart';

class FOContractTile extends StatelessWidget {
  final FOContract contract;

  const FOContractTile({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0.00');
    final changeColor = contract.isPositive ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                        _buildContractName(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Exp: ${contract.expiryDate}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${currencyFormat.format(contract.lastPrice)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          contract.isPositive ? Icons.trending_up : Icons.trending_down,
                          size: 16,
                          color: changeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${contract.isPositive ? '+' : ''}${contract.changePercent.toStringAsFixed(2)}%',
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
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('Volume', NumberFormat.compact().format(contract.volume)),
                ),
                Expanded(
                  child: _buildInfoItem('OI', NumberFormat.compact().format(contract.openInterest)),
                ),
                if (contract.impliedVolatility > 0)
                  Expanded(
                    child: _buildInfoItem('IV', '${contract.impliedVolatility.toStringAsFixed(1)}%'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildContractName() {
    String name = contract.symbol;
    if (contract.strikePrice != null) {
      name += ' ${contract.strikePrice!.toInt()}';
    }
    if (contract.optionType != null) {
      name += ' ${contract.optionType}';
    }
    return name;
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
