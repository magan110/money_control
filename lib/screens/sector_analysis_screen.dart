import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/stock_tile.dart';
import '../screens/stock_detail_screen.dart';

class SectorAnalysisScreen extends StatelessWidget {
  const SectorAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sector Analysis'),
      ),
      body: Consumer<StockProvider>(
        builder: (context, stockProvider, child) {
          if (stockProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final sectorData = _groupStocksBySector(stockProvider.stocks);

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sectorData.keys.length,
            itemBuilder: (context, index) {
              final sector = sectorData.keys.elementAt(index);
              final stocks = sectorData[sector]!;
              return _buildSectorCard(context, sector, stocks);
            },
          );
        },
      ),
    );
  }

  Map<String, List<dynamic>> _groupStocksBySector(List<dynamic> stocks) {
    final Map<String, List<dynamic>> sectorData = {};
    for (final stock in stocks) {
      final sector = stock.sector;
      if (!sectorData.containsKey(sector)) {
        sectorData[sector] = [];
      }
      sectorData[sector]!.add(stock);
    }
    return sectorData;
  }

  Widget _buildSectorCard(BuildContext context, String sector, List<dynamic> stocks) {
    final avgChange = stocks.fold(0.0, (sum, stock) => sum + stock.changePercent) / stocks.length;
    final changeColor = avgChange >= 0 ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(sector, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Avg Change: ${avgChange >= 0 ? '+' : ''}${avgChange.toStringAsFixed(2)}%',
          style: TextStyle(color: changeColor),
        ),
        children: stocks.map((stock) => StockTile(
          stock: stock,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StockDetailScreen(stock: stock),
              ),
            );
          },
        )).toList(),
      ),
    );
  }
}
