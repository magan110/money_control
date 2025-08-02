import 'package:flutter/foundation.dart';
import '../models/news_article.dart';
import '../services/api_service.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<String> get categories => [
    'All',
    'Markets',
    'Economy',
    'Corporate',
    'Sectors',
    'Mutual Funds',
    'Insurance',
    'Banking',
  ];

  List<NewsArticle> get filteredArticles {
    if (_selectedCategory == 'All') return _articles;
    return _articles.where((article) => article.category == _selectedCategory).toList();
  }

  Future<void> loadNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _articles = await ApiService.getFinancialNews();
    } catch (e) {
      debugPrint('Error loading news: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<NewsArticle> getLatestNews({int limit = 10}) {
    var sortedArticles = List<NewsArticle>.from(_articles);
    sortedArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return sortedArticles.take(limit).toList();
  }

  List<NewsArticle> getNewsByCategory(String category) {
    return _articles.where((article) => article.category == category).toList();
  }
}
