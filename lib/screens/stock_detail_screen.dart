import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/stock.dart';
import '../models/candlestick_data.dart';
import '../providers/stock_provider.dart';
import '../services/api_service.dart';

class StockDetailScreen extends StatefulWidget {
  final Stock stock;

  const StockDetailScreen({super.key, required this.stock});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeframe = '1M';
  List<CandlestickData> _chartData = [];
  bool _isLoadingChart = false;
  bool _showCandlestick = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    setState(() {
      _isLoadingChart = true;
    });

    try {
      final data = await ApiService.getHistoricalData(widget.stock.symbol, _selectedTimeframe);
      setState(() {
        _chartData = data;
      });
    } catch (e) {
      debugPrint('Error loading chart data: $e');
    } finally {
      setState(() {
        _isLoadingChart = false;
      });
    }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Chart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(_showCandlestick ? Icons.candlestick_chart : Icons.show_chart),
                    onPressed: () {
                      setState(() {
                        _showCandlestick = !_showCandlestick;
                      });
                    },
                    tooltip: _showCandlestick ? 'Switch to Line Chart' : 'Switch to Candlestick Chart',
                  ),
                  if (_isLoadingChart)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: _isLoadingChart
                ? const Center(child: CircularProgressIndicator())
                : _showCandlestick
                    ? _buildCandlestickChart()
                    : _buildLineChart(),
          ),
          const SizedBox(height: 16),
          _buildTimeframeSelector(),
        ],
      ),
    );
  }

  Widget _buildCandlestickChart() {
    if (_chartData.isEmpty) {
      return const Center(child: Text('No chart data available'));
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        painter: CandlestickPainter(_chartData),
        child: Container(),
      ),
    );
  }

  Widget _buildLineChart() {
    if (_chartData.isEmpty) {
      return const Center(child: Text('No chart data available'));
    }

    final spots = _chartData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.close);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: spots.length / 5,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < _chartData.length) {
                  final date = _chartData[value.toInt()].time;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('MM/dd').format(date),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: null,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: widget.stock.isPositive ? Colors.green : Colors.red,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: (widget.stock.isPositive ? Colors.green : Colors.red).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['1D', '1W', '1M', '3M', '1Y'].map((timeframe) {
        final isSelected = timeframe == _selectedTimeframe;
        return ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedTimeframe = timeframe;
            });
            _loadChartData();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
            foregroundColor: isSelected ? Colors.white : Colors.grey,
          ),
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

class CandlestickPainter extends CustomPainter {
  final List<CandlestickData> data;

  CandlestickPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()..strokeWidth = 1;
    final candleWidth = size.width / data.length * 0.8;
    
    // Find min and max values for scaling
    double minPrice = data.first.low;
    double maxPrice = data.first.high;
    
    for (final candle in data) {
      if (candle.low < minPrice) minPrice = candle.low;
      if (candle.high > maxPrice) maxPrice = candle.high;
    }
    
    final priceRange = maxPrice - minPrice;
    if (priceRange == 0) return;

    for (int i = 0; i < data.length; i++) {
      final candle = data[i];
      final x = (i + 0.5) * (size.width / data.length);
      
      // Scale prices to canvas height
      final openY = size.height - ((candle.open - minPrice) / priceRange) * size.height;
      final closeY = size.height - ((candle.close - minPrice) / priceRange) * size.height;
      final highY = size.height - ((candle.high - minPrice) / priceRange) * size.height;
      final lowY = size.height - ((candle.low - minPrice) / priceRange) * size.height;
      
      // Set color based on whether candle is bullish or bearish
      paint.color = candle.isPositive ? Colors.green : Colors.red;
      
      // Draw high-low line
      canvas.drawLine(
        Offset(x, highY),
        Offset(x, lowY),
        paint,
      );
      
      // Draw candle body
      final bodyTop = candle.isPositive ? closeY : openY;
      final bodyBottom = candle.isPositive ? openY : closeY;
      final bodyHeight = (bodyBottom - bodyTop).abs();
      
      if (bodyHeight < 1) {
        // If body is too small, draw a line
        canvas.drawLine(
          Offset(x - candleWidth / 2, bodyTop),
          Offset(x + candleWidth / 2, bodyTop),
          paint,
        );
      } else {
        // Draw rectangle for body
        final rect = Rect.fromLTWH(
          x - candleWidth / 2,
          bodyTop,
          candleWidth,
          bodyHeight,
        );
        
        if (candle.isPositive) {
          // Bullish candle - hollow
          paint.style = PaintingStyle.stroke;
          canvas.drawRect(rect, paint);
        } else {
          // Bearish candle - filled
          paint.style = PaintingStyle.fill;
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
