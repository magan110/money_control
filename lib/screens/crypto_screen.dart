import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/crypto_provider.dart';
import '../models/cryptocurrency.dart';
import '../models/crypto_holding.dart';
import 'crypto_detail_screen.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final cryptoProvider = context.read<CryptoProvider>();
    await Future.wait([
      cryptoProvider.loadCryptocurrencies(),
      cryptoProvider.loadCryptoPortfolio(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Markets'),
            Tab(text: 'Portfolio'),
            Tab(text: 'Trading'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMarketsTab(),
          _buildPortfolioTab(),
          _buildTradingTab(),
        ],
      ),
    );
  }

  Widget _buildMarketsTab() {
    return Consumer<CryptoProvider>(
      builder: (context, cryptoProvider, child) {
        if (cryptoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => cryptoProvider.loadCryptocurrencies(),
          child: Column(
            children: [
              _buildTimeframeSelector(cryptoProvider),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cryptoProvider.cryptocurrencies.length,
                  itemBuilder: (context, index) {
                    final crypto = cryptoProvider.cryptocurrencies[index];
                    return _buildCryptoTile(crypto);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPortfolioTab() {
    return Consumer<CryptoProvider>(
      builder: (context, cryptoProvider, child) {
        if (cryptoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => cryptoProvider.loadCryptoPortfolio(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCryptoPortfolioSummary(cryptoProvider),
                const SizedBox(height: 20),
                _buildCryptoHoldingsList(cryptoProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTradingTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.currency_bitcoin, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text('Crypto Trading', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Simulated trading interface'),
          Text('Buy and sell cryptocurrencies'),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector(CryptoProvider provider) {
    final timeframes = ['1h', '24h', '7d', '30d'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: timeframes.map((timeframe) {
          final isSelected = provider.selectedTimeframe == timeframe;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                onPressed: () => provider.setSelectedTimeframe(timeframe),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
                  foregroundColor: isSelected ? Colors.white : Colors.grey[400],
                ),
                child: Text(timeframe),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCryptoTile(Cryptocurrency crypto) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final isPositive = crypto.isPositive;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text(
            crypto.symbol.substring(0, 2),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          crypto.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${crypto.symbol} • Rank #${crypto.marketCapRank}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(crypto.currentPrice),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  '${isPositive ? '+' : ''}${crypto.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CryptoDetailScreen(crypto: crypto),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCryptoPortfolioSummary(CryptoProvider provider) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
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
                      currencyFormat.format(provider.totalCryptoInvestment),
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
                      currencyFormat.format(provider.totalCryptoValue),
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
                  '${isProfit ? '+' : ''}${currencyFormat.format(provider.totalCryptoGainLoss)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isProfit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${isProfit ? '+' : ''}${provider.totalCryptoGainLossPercent.toStringAsFixed(2)}%)',
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

  Widget _buildCryptoHoldingsList(CryptoProvider provider) {
    if (provider.cryptoHoldings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_bitcoin, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No crypto holdings'),
            Text('Add cryptocurrencies to track your investments'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crypto Holdings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.cryptoHoldings.length,
          itemBuilder: (context, index) {
            final holding = provider.cryptoHoldings[index];
            return _buildCryptoHoldingTile(holding);
          },
        ),
      ],
    );
  }

  Widget _buildCryptoHoldingTile(CryptoHolding holding) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final isProfit = holding.isProfit;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text(
            holding.symbol.substring(0, 2),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          holding.symbol,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
