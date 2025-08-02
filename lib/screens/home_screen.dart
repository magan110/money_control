import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// intl is used indirectly through other widgets
import '../providers/market_provider.dart';
import '../providers/news_provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/market_index_card.dart';
import '../widgets/news_card.dart';
import '../widgets/stock_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoneyControl'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: StockSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Store providers in local variables to avoid using context across async gaps
          final marketProvider = context.read<MarketProvider>();
          final newsProvider = context.read<NewsProvider>();
          final stockProvider = context.read<StockProvider>();
          
          await marketProvider.loadMarketData();
          await newsProvider.loadNews();
          await stockProvider.loadStocks();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMarketIndices(context),
              const SizedBox(height: 20),
              _buildTopMovers(context),
              const SizedBox(height: 20),
              _buildLatestNews(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketIndices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market Indices',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Consumer<MarketProvider>(
          builder: (context, marketProvider, child) {
            if (marketProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: marketProvider.indices.length,
                itemBuilder: (context, index) {
                  final marketIndex = marketProvider.indices[index];
                  return Padding(
                    padding: EdgeInsets.only(right: index < marketProvider.indices.length - 1 ? 12 : 0),
                    child: MarketIndexCard(index: marketIndex),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopMovers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Movers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<StockProvider>(
          builder: (context, stockProvider, child) {
            if (stockProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final topGainers = stockProvider.getTopGainers().take(3).toList();
            
            return Column(
              children: topGainers.map((stock) => StockTile(stock: stock)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLatestNews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Latest News',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<NewsProvider>(
          builder: (context, newsProvider, child) {
            if (newsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final latestNews = newsProvider.getLatestNews(limit: 3);
            
            return Column(
              children: latestNews.map((article) => NewsCard(article: article)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class StockSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        stockProvider.setSearchQuery(query);
        final filteredStocks = stockProvider.filteredStocks;
        
        return ListView.builder(
          itemCount: filteredStocks.length,
          itemBuilder: (context, index) {
            final stock = filteredStocks[index];
            return StockTile(stock: stock);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        stockProvider.setSearchQuery(query);
        final filteredStocks = stockProvider.filteredStocks.take(5).toList();
        
        return ListView.builder(
          itemCount: filteredStocks.length,
          itemBuilder: (context, index) {
            final stock = filteredStocks[index];
            return ListTile(
              title: Text(stock.name),
              subtitle: Text(stock.symbol),
              onTap: () {
                query = stock.symbol;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
