import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
import 'news_webview_screen.dart';

class TechScreen extends StatefulWidget {
  const TechScreen({super.key});

  @override
  State<TechScreen> createState() => _TechScreenState();
}

class _TechScreenState extends State<TechScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech & Startups'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Technology'),
            Tab(text: 'Startups'),
            Tab(text: 'Innovation'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTechNews(),
          _buildStartupNews(),
          _buildInnovationNews(),
        ],
      ),
    );
  }

  Widget _buildTechNews() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        final techNews = newsProvider.articles.where((article) => 
          article.tags.contains('technology')).toList();

        if (techNews.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.computer, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No technology news available'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: techNews.length,
          itemBuilder: (context, index) {
            return NewsCard(
              article: techNews[index],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewsWebViewScreen(article: techNews[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStartupNews() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        final startupNews = newsProvider.articles.where((article) => 
          article.tags.contains('startup')).toList();

        if (startupNews.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rocket_launch, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No startup news available'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: startupNews.length,
          itemBuilder: (context, index) {
            return NewsCard(
              article: startupNews[index],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewsWebViewScreen(article: startupNews[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildInnovationNews() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        final innovationNews = newsProvider.articles.where((article) => 
          article.tags.contains('innovation')).toList();

        if (innovationNews.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No innovation news available'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: innovationNews.length,
          itemBuilder: (context, index) {
            return NewsCard(
              article: innovationNews[index],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NewsWebViewScreen(article: innovationNews[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
