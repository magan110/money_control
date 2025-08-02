import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/stock_tile.dart';
import 'stock_detail_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: WatchlistSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Consumer<StockProvider>(
        builder: (context, stockProvider, child) {
          if (stockProvider.watchlist.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your watchlist is empty'),
                  Text('Add stocks to track them here'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => stockProvider.loadStocks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stockProvider.watchlist.length,
              itemBuilder: (context, index) {
                final stock = stockProvider.watchlist[index];
                return Dismissible(
                  key: Key(stock.symbol),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    stockProvider.removeFromWatchlist(stock.symbol);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${stock.symbol} removed from watchlist'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            stockProvider.addToWatchlist(stock);
                          },
                        ),
                      ),
                    );
                  },
                  child: StockTile(
                    stock: stock,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StockDetailScreen(stock: stock),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class WatchlistSearchDelegate extends SearchDelegate<String> {
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
            final isInWatchlist = stockProvider.isInWatchlist(stock.symbol);
            
            return ListTile(
              title: Text(stock.name),
              subtitle: Text(stock.symbol),
              trailing: IconButton(
                icon: Icon(
                  isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                  color: isInWatchlist ? Colors.blue : null,
                ),
                onPressed: () {
                  if (isInWatchlist) {
                    stockProvider.removeFromWatchlist(stock.symbol);
                  } else {
                    stockProvider.addToWatchlist(stock);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
