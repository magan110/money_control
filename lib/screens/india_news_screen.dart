import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
import 'news_webview_screen.dart';

class IndiaNewsScreen extends StatelessWidget {
  const IndiaNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('India News'),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final indiaNews = newsProvider.articles.where((article) => 
            article.tags.contains('india')).toList();

          if (indiaNews.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No India news available'),
                  Text('Check back later for updates'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: indiaNews.length,
            itemBuilder: (context, index) {
              return NewsCard(
                article: indiaNews[index],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewsWebViewScreen(article: indiaNews[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
