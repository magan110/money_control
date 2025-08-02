import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/stock.dart';
import '../models/news_article.dart';
import '../models/market_index.dart';

class ApiService {
  static const String _alphaVantageKey = 'demo';
  static const String _alphaVantageBase = 'https://www.alphavantage.co/query';
  static const String _finnhubKey = 'demo';
  static const String _finnhubBase = 'https://finnhub.io/api/v1';
  static const String _marketauxKey = 'demo';
  static const String _marketauxBase = 'https://api.marketaux.com/v1';

  static Future<List<Stock>> getStocks() async {
    final symbols = ['AAPL', 'GOOGL', 'MSFT', 'TSLA', 'AMZN'];
    final stocks = <Stock>[];
    
    for (final symbol in symbols) {
      try {
        final response = await http.get(
          Uri.parse('$_finnhubBase/quote?symbol=$symbol&token=$_finnhubKey'),
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final stock = Stock(
            symbol: symbol,
            name: _getCompanyName(symbol),
            currentPrice: (data['c'] ?? 0.0).toDouble(),
            changeAmount: (data['d'] ?? 0.0).toDouble(),
            changePercent: (data['dp'] ?? 0.0).toDouble(),
            dayHigh: (data['h'] ?? 0.0).toDouble(),
            dayLow: (data['l'] ?? 0.0).toDouble(),
            openPrice: (data['o'] ?? 0.0).toDouble(),
            previousClose: (data['pc'] ?? 0.0).toDouble(),
            volume: 1000000,
            marketCap: 1000000000000,
            sector: _getSector(symbol),
          );
          stocks.add(stock);
        }
      } catch (e) {
        debugPrint('Error fetching stock $symbol: $e');
      }
    }
    
    return stocks.isNotEmpty ? stocks : _getFallbackStocks();
  }

  static Future<List<MarketIndex>> getMarketIndices() async {
    final indices = <MarketIndex>[];
    final symbols = ['SPY', 'QQQ', 'DIA'];
    
    for (final symbol in symbols) {
      try {
        final response = await http.get(
          Uri.parse('$_alphaVantageBase?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_alphaVantageKey'),
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final quote = data['Global Quote'];
          if (quote != null) {
            final index = MarketIndex(
              name: _getIndexName(symbol),
              symbol: symbol,
              value: double.parse(quote['05. price'] ?? '0'),
              change: double.parse(quote['09. change'] ?? '0'),
              changePercent: double.parse(quote['10. change percent']?.replaceAll('%', '') ?? '0'),
              lastUpdated: DateTime.now(),
            );
            indices.add(index);
          }
        }
      } catch (e) {
        debugPrint('Error fetching index $symbol: $e');
      }
    }
    
    return indices.isNotEmpty ? indices : _getFallbackIndices();
  }

  static Future<List<NewsArticle>> getFinancialNews() async {
    try {
      final response = await http.get(
        Uri.parse('$_marketauxBase/news/all?filter_entities=true&language=en&api_token=$_marketauxKey'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = <NewsArticle>[];
        
        for (final item in data['data'] ?? []) {
          final article = NewsArticle(
            id: item['uuid'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            title: item['title'] ?? '',
            summary: item['description'] ?? '',
            content: item['snippet'] ?? item['description'] ?? '',
            imageUrl: item['image_url'] ?? 'https://via.placeholder.com/300x200?text=News',
            sourceUrl: item['url'] ?? '',
            source: item['source'] ?? 'Unknown',
            publishedAt: DateTime.parse(item['published_at'] ?? DateTime.now().toIso8601String()),
            tags: _extractTags(item),
            category: _categorizeNews(item),
          );
          articles.add(article);
        }
        
        return articles.take(20).toList();
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');
    }
    
    return _getFallbackNews();
  }

  static String _getCompanyName(String symbol) {
    const names = {
      'AAPL': 'Apple Inc.',
      'GOOGL': 'Alphabet Inc.',
      'MSFT': 'Microsoft Corporation',
      'TSLA': 'Tesla Inc.',
      'AMZN': 'Amazon.com Inc.',
    };
    return names[symbol] ?? symbol;
  }

  static String _getSector(String symbol) {
    const sectors = {
      'AAPL': 'Technology',
      'GOOGL': 'Technology',
      'MSFT': 'Technology',
      'TSLA': 'Automotive',
      'AMZN': 'Consumer Discretionary',
    };
    return sectors[symbol] ?? 'Technology';
  }

  static String _getIndexName(String symbol) {
    const names = {
      'SPY': 'S&P 500',
      'QQQ': 'NASDAQ 100',
      'DIA': 'Dow Jones',
    };
    return names[symbol] ?? symbol;
  }

  static List<String> _extractTags(Map<String, dynamic> item) {
    final tags = <String>[];
    final entities = item['entities'] ?? [];
    for (final entity in entities) {
      if (entity['symbol'] != null) tags.add(entity['symbol']);
    }
    if (tags.isEmpty) tags.add('general');
    return tags;
  }

  static String _categorizeNews(Map<String, dynamic> item) {
    final title = (item['title'] ?? '').toLowerCase();
    if (title.contains('market') || title.contains('stock')) return 'Markets';
    if (title.contains('bank')) return 'Banking';
    if (title.contains('tech')) return 'Sectors';
    return 'Corporate';
  }

  static List<Stock> _getFallbackStocks() {
    return [
      Stock(
        symbol: 'AAPL',
        name: 'Apple Inc.',
        currentPrice: 150.0,
        changeAmount: 2.5,
        changePercent: 1.69,
        dayHigh: 152.0,
        dayLow: 148.0,
        openPrice: 149.0,
        previousClose: 147.5,
        volume: 50000000,
        marketCap: 2500000000000,
        sector: 'Technology',
      ),
      Stock(
        symbol: 'GOOGL',
        name: 'Alphabet Inc.',
        currentPrice: 2800.0,
        changeAmount: -15.0,
        changePercent: -0.53,
        dayHigh: 2820.0,
        dayLow: 2780.0,
        openPrice: 2810.0,
        previousClose: 2815.0,
        volume: 25000000,
        marketCap: 1800000000000,
        sector: 'Technology',
      ),
      Stock(
        symbol: 'MSFT',
        name: 'Microsoft Corporation',
        currentPrice: 420.0,
        changeAmount: 8.5,
        changePercent: 2.07,
        dayHigh: 425.0,
        dayLow: 415.0,
        openPrice: 418.0,
        previousClose: 411.5,
        volume: 30000000,
        marketCap: 3100000000000,
        sector: 'Technology',
      ),
      Stock(
        symbol: 'TSLA',
        name: 'Tesla Inc.',
        currentPrice: 250.0,
        changeAmount: -5.2,
        changePercent: -2.04,
        dayHigh: 258.0,
        dayLow: 248.0,
        openPrice: 255.0,
        previousClose: 255.2,
        volume: 45000000,
        marketCap: 800000000000,
        sector: 'Automotive',
      ),
      Stock(
        symbol: 'AMZN',
        name: 'Amazon.com Inc.',
        currentPrice: 180.0,
        changeAmount: 3.2,
        changePercent: 1.81,
        dayHigh: 182.0,
        dayLow: 177.0,
        openPrice: 178.0,
        previousClose: 176.8,
        volume: 35000000,
        marketCap: 1900000000000,
        sector: 'Consumer Discretionary',
      ),
    ];
  }

  static List<MarketIndex> _getFallbackIndices() {
    return [
      MarketIndex(
        name: 'S&P 500',
        symbol: 'SPY',
        value: 4200.0,
        change: 15.5,
        changePercent: 0.37,
        lastUpdated: DateTime.now(),
      ),
      MarketIndex(
        name: 'NASDAQ 100',
        symbol: 'QQQ',
        value: 380.0,
        change: -2.1,
        changePercent: -0.55,
        lastUpdated: DateTime.now(),
      ),
      MarketIndex(
        name: 'Dow Jones',
        symbol: 'DIA',
        value: 350.0,
        change: 8.2,
        changePercent: 2.40,
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  static List<NewsArticle> _getFallbackNews() {
    return [
      NewsArticle(
        id: '1',
        title: 'Markets show strong performance amid economic recovery',
        summary: 'Stock markets continue upward trend as investors remain optimistic about economic outlook',
        content: 'Financial markets are showing strong performance as economic indicators suggest continued recovery. Major indices have gained significantly over the past week, with technology stocks leading the charge.',
        imageUrl: 'https://via.placeholder.com/300x200?text=Market+News',
        sourceUrl: 'https://example.com/news/1',
        source: 'Financial News',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['markets', 'stocks', 'economy'],
        category: 'Markets',
      ),
      NewsArticle(
        id: '2',
        title: 'Tech giants report strong quarterly earnings',
        summary: 'Major technology companies exceed analyst expectations in latest earnings reports',
        content: 'Leading technology companies have reported better-than-expected quarterly results, driving investor confidence in the sector. Revenue growth and strong guidance have boosted stock prices.',
        imageUrl: 'https://via.placeholder.com/300x200?text=Tech+News',
        sourceUrl: 'https://example.com/news/2',
        source: 'Tech Today',
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        tags: ['technology', 'earnings', 'stocks'],
        category: 'Sectors',
      ),
      NewsArticle(
        id: '3',
        title: 'Banking sector sees increased lending activity',
        summary: 'Banks report higher loan volumes as economic conditions improve',
        content: 'The banking sector is experiencing increased lending activity as businesses and consumers show renewed confidence. Interest rate environment remains favorable for bank profitability.',
        imageUrl: 'https://via.placeholder.com/300x200?text=Banking+News',
        sourceUrl: 'https://example.com/news/3',
        source: 'Banking Weekly',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        tags: ['banking', 'loans', 'finance'],
        category: 'Banking',
      ),
      NewsArticle(
        id: '4',
        title: 'Corporate earnings season shows mixed results',
        summary: 'Companies report varied performance across different sectors',
        content: 'The current earnings season has shown mixed results with some sectors outperforming while others face challenges. Analysts remain cautiously optimistic about future prospects.',
        imageUrl: 'https://via.placeholder.com/300x200?text=Corporate+News',
        sourceUrl: 'https://example.com/news/4',
        source: 'Corporate Report',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        tags: ['earnings', 'corporate', 'analysis'],
        category: 'Corporate',
      ),
      NewsArticle(
        id: '5',
        title: 'Mutual fund inflows reach new highs',
        summary: 'Investors continue to show strong interest in mutual fund investments',
        content: 'Mutual fund industry reports record inflows as investors seek diversified investment options. Equity funds and hybrid funds are seeing particularly strong demand.',
        imageUrl: 'https://via.placeholder.com/300x200?text=Mutual+Fund+News',
        sourceUrl: 'https://example.com/news/5',
        source: 'Investment Today',
        publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
        tags: ['mutual-funds', 'investment', 'inflows'],
        category: 'Mutual Funds',
      ),
    ];
  }
}
