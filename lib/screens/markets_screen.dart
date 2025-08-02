import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/stock_tile.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Markets'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All Stocks'),
            Tab(text: 'Top Gainers'),
            Tab(text: 'Top Losers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllStocks(),
          _buildTopGainers(),
          _buildTopLosers(),
        ],
      ),
    );
  }

  Widget _buildAllStocks() {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        if (stockProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => stockProvider.loadStocks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stockProvider.stocks.length,
            itemBuilder: (context, index) {
              final stock = stockProvider.stocks[index];
              return StockTile(
                stock: stock,
                onTap: () {
                  // Navigate to stock details
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTopGainers() {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        if (stockProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final topGainers = stockProvider.getTopGainers();

        return RefreshIndicator(
          onRefresh: () => stockProvider.loadStocks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topGainers.length,
            itemBuilder: (context, index) {
              final stock = topGainers[index];
              return StockTile(
                stock: stock,
                onTap: () {
                  // Navigate to stock details
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTopLosers() {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        if (stockProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final topLosers = stockProvider.getTopLosers();

        return RefreshIndicator(
          onRefresh: () => stockProvider.loadStocks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topLosers.length,
            itemBuilder: (context, index) {
              final stock = topLosers[index];
              return StockTile(
                stock: stock,
                onTap: () {
                  // Navigate to stock details
                },
              );
            },
          ),
        );
      },
    );
  }
}
