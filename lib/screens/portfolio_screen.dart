import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/portfolio_provider.dart';
import '../models/portfolio_holding.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new holding
            },
          ),
        ],
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, portfolioProvider, child) {
          if (portfolioProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => portfolioProvider.loadPortfolio(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPortfolioSummary(context, portfolioProvider),
                  const SizedBox(height: 20),
                  _buildPortfolioAnalytics(context, portfolioProvider),
                  const SizedBox(height: 20),
                  _buildHoldingsList(context, portfolioProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortfolioSummary(BuildContext context, PortfolioProvider provider) {
    final currencyFormat = NumberFormat.currency(symbol: '₹');
    final isProfit = provider.isOverallProfit;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Investment',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      currencyFormat.format(provider.totalInvestment),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Current Value',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      currencyFormat.format(provider.totalCurrentValue),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isProfit ? Icons.trending_up : Icons.trending_down,
                  color: isProfit ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  '${isProfit ? '+' : ''}${currencyFormat.format(provider.totalGainLoss)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isProfit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${isProfit ? '+' : ''}${provider.totalGainLossPercent.toStringAsFixed(2)}%)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isProfit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingsList(BuildContext context, PortfolioProvider provider) {
    if (provider.holdings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No holdings in portfolio'),
            Text('Add stocks to track your investments'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Holdings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.holdings.length,
          itemBuilder: (context, index) {
            final holding = provider.holdings[index];
            return _buildHoldingTile(context, holding);
          },
        ),
      ],
    );
  }

  Widget _buildPortfolioAnalytics(BuildContext context, PortfolioProvider provider) {
    return Column(
      children: [
        _buildPerformanceChart(provider),
        const SizedBox(height: 16),
        _buildAssetAllocation(provider),
        const SizedBox(height: 16),
        _buildTopPerformers(provider),
      ],
    );
  }

  Widget _buildPerformanceChart(PortfolioProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Portfolio Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generatePortfolioChartData(provider),
                      isCurved: true,
                      color: provider.isOverallProfit ? Colors.green : Colors.red,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generatePortfolioChartData(PortfolioProvider provider) {
    return List.generate(30, (index) {
      return FlSpot(index.toDouble(), provider.totalCurrentValue + (index * 1000) - 15000);
    });
  }

  Widget _buildAssetAllocation(PortfolioProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Asset Allocation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _createAssetAllocationSections(provider),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createAssetAllocationSections(PortfolioProvider provider) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    final total = provider.totalCurrentValue;
    
    return provider.holdings.asMap().entries.map((entry) {
      final index = entry.key;
      final holding = entry.value;
      final percentage = (holding.totalValue / total * 100);
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: holding.totalValue,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  Widget _buildTopPerformers(PortfolioProvider provider) {
    final topPerformers = provider.getTopPerformers();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top Performers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...topPerformers.map((holding) => ListTile(
              title: Text(holding.symbol),
              trailing: Text(
                '${holding.isProfit ? '+' : ''}${holding.gainLossPercent.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: holding.isProfit ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingTile(BuildContext context, PortfolioHolding holding) {
    final currencyFormat = NumberFormat.currency(symbol: '₹');
    final isProfit = holding.isProfit;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          holding.symbol,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(holding.name),
            Text('Qty: ${holding.quantity} | Avg: ${currencyFormat.format(holding.averagePrice)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(holding.totalValue),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isProfit ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: isProfit ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isProfit ? '+' : ''}${holding.gainLossPercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isProfit ? Colors.green : Colors.red,
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
