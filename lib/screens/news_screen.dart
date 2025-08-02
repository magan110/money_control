import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
import 'news_webview_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: Column(
        children: [
          _buildCategoryTabs(context),
          Expanded(
            child: _buildNewsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newsProvider.categories.length,
            itemBuilder: (context, index) {
              final category = newsProvider.categories[index];
              final isSelected = category == newsProvider.selectedCategory;
              
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == newsProvider.categories.length - 1 ? 16 : 0,
                ),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      newsProvider.setCategory(category);
                    }
                  },
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNewsList(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final articles = newsProvider.filteredArticles;

        if (articles.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No news articles available'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => newsProvider.loadNews(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return NewsCard(
                article: article,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewsWebViewScreen(article: article),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
