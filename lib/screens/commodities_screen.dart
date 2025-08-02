import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommoditiesScreen extends StatefulWidget {
  const CommoditiesScreen({super.key});

  @override
  State<CommoditiesScreen> createState() => _CommoditiesScreenState();
}

class _CommoditiesScreenState extends State<CommoditiesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commodities'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Metals'),
            Tab(text: 'Energy'),
            Tab(text: 'Agriculture'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMetalsCommodities(),
          _buildEnergyCommodities(),
          _buildAgricultureCommodities(),
          _buildAllCommodities(),
        ],
      ),
    );
  }

  Widget _buildMetalsCommodities() {
    final metals = [
      {'name': 'Gold', 'price': 62450.0, 'change': 125.50, 'unit': '10 gm'},
      {'name': 'Silver', 'price': 74800.0, 'change': -245.0, 'unit': '1 kg'},
      {'name': 'Copper', 'price': 745.50, 'change': 12.25, 'unit': '1 kg'},
      {'name': 'Aluminum', 'price': 215.80, 'change': -2.15, 'unit': '1 kg'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: metals.length,
      itemBuilder: (context, index) {
        return _buildCommodityTile(metals[index]);
      },
    );
  }

  Widget _buildEnergyCommodities() {
    final energy = [
      {'name': 'Crude Oil', 'price': 6245.0, 'change': -45.50, 'unit': '1 barrel'},
      {'name': 'Natural Gas', 'price': 285.40, 'change': 8.25, 'unit': '1 mmBtu'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: energy.length,
      itemBuilder: (context, index) {
        return _buildCommodityTile(energy[index]);
      },
    );
  }

  Widget _buildAgricultureCommodities() {
    final agriculture = [
      {'name': 'Wheat', 'price': 2450.0, 'change': 25.50, 'unit': '1 quintal'},
      {'name': 'Rice', 'price': 3200.0, 'change': -15.0, 'unit': '1 quintal'},
      {'name': 'Sugar', 'price': 3850.0, 'change': 45.25, 'unit': '1 quintal'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: agriculture.length,
      itemBuilder: (context, index) {
        return _buildCommodityTile(agriculture[index]);
      },
    );
  }

  Widget _buildAllCommodities() {
    final allCommodities = [
      {'name': 'Gold', 'price': 62450.0, 'change': 125.50, 'unit': '10 gm'},
      {'name': 'Silver', 'price': 74800.0, 'change': -245.0, 'unit': '1 kg'},
      {'name': 'Crude Oil', 'price': 6245.0, 'change': -45.50, 'unit': '1 barrel'},
      {'name': 'Wheat', 'price': 2450.0, 'change': 25.50, 'unit': '1 quintal'},
      {'name': 'Copper', 'price': 745.50, 'change': 12.25, 'unit': '1 kg'},
      {'name': 'Natural Gas', 'price': 285.40, 'change': 8.25, 'unit': '1 mmBtu'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allCommodities.length,
      itemBuilder: (context, index) {
        return _buildCommodityTile(allCommodities[index]);
      },
    );
  }

  Widget _buildCommodityTile(Map<String, dynamic> commodity) {
    final isPositive = commodity['change'] >= 0;
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          commodity['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(commodity['unit']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(commodity['price']),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isPositive ? '+' : ''}${commodity['change'].toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
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
