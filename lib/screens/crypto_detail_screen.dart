import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/cryptocurrency.dart';

class CryptoDetailScreen extends StatefulWidget {
  final Cryptocurrency crypto;

  const CryptoDetailScreen({super.key, required this.crypto});

  @override
  State<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen> {
  String _selectedTimeframe = '1D';
  bool _showCandlestick = true;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final compactFormat = NumberFormat.compact();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crypto.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              // Add to watchlist
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceHeader(currencyFormat),
            const SizedBox(height: 20),
            _buildChartSection(),
            const SizedBox(height: 20),
            _buildStatsSection(currencyFormat, compactFormat),
            const SizedBox(height: 20),
            _buildTradingButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceHeader(NumberFormat currencyFormat) {
    final isPositive = widget.crypto.isPositive;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    widget.crypto.symbol.substring(0, 2),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.crypto.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.crypto.symbol} • Rank #${widget.crypto.marketCapRank}',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              currencyFormat.format(widget.crypto.currentPrice),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  '${isPositive ? '+' : ''}${currencyFormat.format(widget.crypto.changeAmount)}',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${isPositive ? '+' : ''}${widget.crypto.changePercent.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price Chart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(_showCandlestick ? Icons.candlestick_chart : Icons.show_chart),
                      onPressed: () {
                        setState(() {
                          _showCandlestick = !_showCandlestick;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimeframeSelector(),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    final timeframes = ['1D', '1W', '1M', '3M', '1Y'];
    
    return Row(
      children: timeframes.map((timeframe) {
        final isSelected = _selectedTimeframe == timeframe;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedTimeframe = timeframe;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
                foregroundColor: isSelected ? Colors.white : Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(timeframe, style: const TextStyle(fontSize: 12)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    final spots = _generateChartData();
    
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: widget.crypto.isPositive ? Colors.green : Colors.red,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: (widget.crypto.isPositive ? Colors.green : Colors.red).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateChartData() {
    final basePrice = widget.crypto.currentPrice;
    final changePercent = widget.crypto.changePercent / 100;
    
    return List.generate(30, (index) {
      final progress = index / 29.0;
      final volatility = (index % 3 - 1) * basePrice * 0.02;
      final trendPrice = basePrice * (1 - changePercent + (changePercent * progress));
      return FlSpot(index.toDouble(), trendPrice + volatility);
    });
  }

  Widget _buildStatsSection(NumberFormat currencyFormat, NumberFormat compactFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildStatRow('Market Cap', currencyFormat.format(widget.crypto.marketCap)),
            _buildStatRow('24h Volume', currencyFormat.format(widget.crypto.volume24h)),
            _buildStatRow('Circulating Supply', '${compactFormat.format(widget.crypto.circulatingSupply)} ${widget.crypto.symbol}'),
            _buildStatRow('Total Supply', '${compactFormat.format(widget.crypto.totalSupply)} ${widget.crypto.symbol}'),
            _buildStatRow('24h High', currencyFormat.format(widget.crypto.dayHigh)),
            _buildStatRow('24h Low', currencyFormat.format(widget.crypto.dayLow)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTradingButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showBuyDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Buy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showSellDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Sell', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  void _showBuyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy ${widget.crypto.symbol}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Price: \$${widget.crypto.currentPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Buy order placed for ${widget.crypto.symbol}')),
              );
            },
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }

  void _showSellDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sell ${widget.crypto.symbol}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Price: \$${widget.crypto.currentPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sell order placed for ${widget.crypto.symbol}')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sell'),
          ),
        ],
      ),
    );
  }
}
