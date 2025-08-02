import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';

class MutualFundsScreen extends StatelessWidget {
  const MutualFundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutual Funds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFundDialog(context),
          ),
        ],
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, portfolioProvider, child) {
          if (portfolioProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final mutualFunds = portfolioProvider.holdings
              .where((holding) => holding.symbol.contains('MF'))
              .toList();

          if (mutualFunds.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No mutual fund investments'),
                  Text('Tap + to add your first mutual fund'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mutualFunds.length,
            itemBuilder: (context, index) {
              final fund = mutualFunds[index];
              return _buildFundCard(fund);
            },
          );
        },
      ),
    );
  }

  Widget _buildFundCard(dynamic fund) {
    final changeColor = fund.isProfit ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(fund.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Units: ${fund.quantity.toStringAsFixed(3)}'),
            Text('NAV: ₹${fund.currentPrice.toStringAsFixed(2)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${fund.totalValue.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${fund.isProfit ? '+' : ''}${fund.gainLossPercent.toStringAsFixed(2)}%',
              style: TextStyle(color: changeColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Mutual Fund'),
        content: const Text('Mutual fund addition form coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
