import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/stock.dart';
import '../providers/stock_provider.dart';

class StockDetailScreen extends StatefulWidget {
  final Stock stock;

  const StockDetailScreen({super.key, required this.stock});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stock.symbol),
        actions: [
          Consumer<StockProvider>(
            builder: (context, stockProvider, child) {
              final isInWatchlist = stockProvider.isInWatchlist(widget.stock.symbol);
              return IconButton(
                icon: Icon(isInWatchlist ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  if (isInWatchlist) {
                    stockProvider.removeFromWatchlist(widget.stock.symbol);
                  } else {
                    stockProvider.addToWatchlist(widget.stock);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStockHeader(),
          TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Chart'),
              Tab(text: 'Overview'),
              Tab(text: 'Financials'),
              Tab(text: 'News'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChartTab(),
                _buildOverviewTab(),
                _buildFinancialsTab(),
                _buildNewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockHeader() {
    final currencyFormat = NumberFormat('#,##0.00');
    final changeColor = widget.stock.isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.stock.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '₹${currencyFormat.format(widget.stock.currentPrice)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${widget.stock.isPositive ? '+' : ''}${currencyFormat.format(widget.stock.changeAmount)} (${widget.stock.changePercent.toStringAsFixed(2)}%)',
                  style: TextStyle(color: changeColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateMockChartData(),
                    isCurved: true,
                    color: widget.stock.isPositive ? Colors.green : Colors.red,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTimeframeSelector(),
        ],
      ),
    );
  }

  List<FlSpot> _generateMockChartData() {
    return List.generate(30, (index) {
      return FlSpot(index.toDouble(), widget.stock.currentPrice + (index * 2) - 30);
    });
  }

  Widget _buildTimeframeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['1D', '1W', '1M', '3M', '1Y'].map((timeframe) {
        return ElevatedButton(
          onPressed: () {},
          child: Text(timeframe),
        );
      }).toList(),
    );
  }

  Widget _buildOverviewTab() {
    final currencyFormat = NumberFormat('#,##0.00');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard('Market Data', [
            _buildInfoRow('Open', '₹${currencyFormat.format(widget.stock.openPrice)}'),
            _buildInfoRow('High', '₹${currencyFormat.format(widget.stock.dayHigh)}'),
            _buildInfoRow('Low', '₹${currencyFormat.format(widget.stock.dayLow)}'),
            _buildInfoRow('Prev Close', '₹${currencyFormat.format(widget.stock.previousClose)}'),
            _buildInfoRow('Volume', NumberFormat.compact().format(widget.stock.volume)),
            _buildInfoRow('Market Cap', '₹${NumberFormat.compact().format(widget.stock.marketCap)}'),
            _buildInfoRow('Sector', widget.stock.sector),
          ]),
        ],
      ),
    );
  }

  Widget _buildFinancialsTab() {
    return const Center(child: Text('Financial data coming soon'));
  }

  Widget _buildNewsTab() {
    return const Center(child: Text('Related news coming soon'));
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
