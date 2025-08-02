import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
import 'news_webview_screen.dart';

class EditorPicksScreen extends StatelessWidget {
  const EditorPicksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor\'s Picks'),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final editorPicks = newsProvider.articles.where((article) => 
            article.tags.contains('editor-pick')).toList();

          if (editorPicks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No editor picks available'),
                  Text('Check back later for curated content'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: editorPicks.length,
            itemBuilder: (context, index) {
              return NewsCard(
                article: editorPicks[index],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewsWebViewScreen(article: editorPicks[index]),
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
