import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fo_provider.dart';
import '../widgets/fo_contract_tile.dart';

class FOScreen extends StatefulWidget {
  const FOScreen({super.key});

  @override
  State<FOScreen> createState() => _FOScreenState();
}

class _FOScreenState extends State<FOScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FOProvider>().loadFOData();
    });
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
        title: const Text('F&O'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Index Futures'),
            Tab(text: 'Index Options'),
            Tab(text: 'Stock Futures'),
            Tab(text: 'Stock Options'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFOList('FUTIDX'),
          _buildFOList('OPTIDX'),
          _buildFOList('FUTSTK'),
          _buildFOList('OPTSTK'),
        ],
      ),
    );
  }

  Widget _buildFOList(String instrumentType) {
    return Consumer<FOProvider>(
      builder: (context, foProvider, child) {
        if (foProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final contracts = foProvider.contracts
            .where((c) => c.instrumentType == instrumentType)
            .toList();

        if (contracts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 64, color: Colors.grey[600]),
                const SizedBox(height: 16),
                Text(
                  'No ${instrumentType.toLowerCase()} data available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            if (foProvider.availableExpiries.isNotEmpty) _buildExpirySelector(foProvider),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => foProvider.loadFOData(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: contracts.length,
                  itemBuilder: (context, index) {
                    return FOContractTile(contract: contracts[index]);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpirySelector(FOProvider foProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: DropdownButton<String>(
        value: foProvider.selectedExpiry.isEmpty ? null : foProvider.selectedExpiry,
        hint: const Text('Select Expiry'),
        isExpanded: true,
        dropdownColor: Theme.of(context).cardColor,
        items: foProvider.availableExpiries.map((expiry) {
          return DropdownMenuItem(value: expiry, child: Text(expiry));
        }).toList(),
        onChanged: (value) {
          if (value != null) foProvider.setSelectedExpiry(value);
        },
      ),
    );
  }
}
