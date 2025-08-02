import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/stock.dart';
import '../models/news_article.dart';
import '../models/market_index.dart';
import '../models/candlestick_data.dart';
import '../models/research_insight.dart';
import '../models/fo_contract.dart';
import '../models/cryptocurrency.dart';

class ApiService {
  static const String _alphaVantageKey = 'demo';
  static const String _alphaVantageBase = 'https://www.alphavantage.co/query';
  static const String _finnhubKey = 'demo';
  static const String _finnhubBase = 'https://finnhub.io/api/v1';
  static const String _marketauxKey = 'demo';
  static const String _marketauxBase = 'https://api.marketaux.com/v1';
  static const String _coinMarketCapKey = 'demo';
  static const String _coinMarketCapBase = 'https://pro-api.coinmarketcap.com/v1';

  static Future<List<CandlestickData>> getHistoricalData(String symbol, String timeframe) async {
    try {
      // For Finnhub, we can use the stock candles endpoint
      final endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final startTime = _getStartTimeForTimeframe(timeframe, endTime);
      
      final response = await http.get(
        Uri.parse('$_finnhubBase/stock/candle?symbol=$symbol&resolution=${_getResolutionForTimeframe(timeframe)}&from=$startTime&to=$endTime&token=$_finnhubKey'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['s'] == 'ok') {
          final List<CandlestickData> candlesticks = [];
          final closes = List<double>.from(data['c'] ?? []);
          final opens = List<double>.from(data['o'] ?? []);
          final highs = List<double>.from(data['h'] ?? []);
          final lows = List<double>.from(data['l'] ?? []);
          final times = List<int>.from(data['t'] ?? []);
          
          for (int i = 0; i < closes.length; i++) {
            candlesticks.add(CandlestickData(
              time: DateTime.fromMillisecondsSinceEpoch(times[i] * 1000),
              open: opens[i],
              high: highs[i],
              low: lows[i],
              close: closes[i],
            ));
          }
          
          return candlesticks;
        }
      }
    } catch (e) {
      debugPrint('Error fetching historical data for $symbol: $e');
    }
    
    return _getFallbackHistoricalData(symbol, timeframe);
  }

  static int _getStartTimeForTimeframe(String timeframe, int endTime) {
    switch (timeframe) {
      case '1D':
        return endTime - (24 * 60 * 60); // 1 day ago
      case '1W':
        return endTime - (7 * 24 * 60 * 60); // 1 week ago
      case '1M':
        return endTime - (30 * 24 * 60 * 60); // 1 month ago
      case '3M':
        return endTime - (90 * 24 * 60 * 60); // 3 months ago
      case '1Y':
        return endTime - (365 * 24 * 60 * 60); // 1 year ago
      default:
        return endTime - (30 * 24 * 60 * 60); // Default to 1 month
    }
  }

  static String _getResolutionForTimeframe(String timeframe) {
    switch (timeframe) {
      case '1D':
        return '5'; // 5-minute intervals
      case '1W':
        return '15'; // 15-minute intervals
      case '1M':
        return 'D'; // Daily intervals
      case '3M':
        return 'D'; // Daily intervals
      case '1Y':
        return 'W'; // Weekly intervals
      default:
        return 'D'; // Default to daily
    }
  }

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
            name: _getCompanyNameForSymbol(symbol),
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

  static List<CandlestickData> _getFallbackHistoricalData(String symbol, String timeframe) {
    final now = DateTime.now();
    final candlesticks = <CandlestickData>[];
    const basePrice = 150.0; // Base price for mock data
    
    int days = 30;
    switch (timeframe) {
      case '1D':
        days = 1;
        break;
      case '1W':
        days = 7;
        break;
      case '1M':
        days = 30;
        break;
      case '3M':
        days = 90;
        break;
      case '1Y':
        days = 365;
        break;
    }
    
    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final randomFactor = (i * 0.5) - (days * 0.25);
      final open = basePrice + randomFactor + (i % 3 - 1) * 2;
      final close = open + (i % 5 - 2) * 1.5;
      final high = [open, close].reduce((a, b) => a > b ? a : b) + (i % 2) * 1.2;
      final low = [open, close].reduce((a, b) => a < b ? a : b) - (i % 2) * 0.8;
      
      candlesticks.add(CandlestickData(
        time: date,
        open: open,
        high: high,
        low: low,
        close: close,
      ));
    }
    
    return candlesticks;
  }

  static String _getCompanyNameForSymbol(String symbol) {
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

  static Future<List<ResearchInsight>> getAnalystRecommendations() async {
    final symbols = ['AAPL', 'GOOGL', 'MSFT', 'TSLA', 'AMZN'];
    final insights = <ResearchInsight>[];
    
    for (final symbol in symbols) {
      try {
        final response = await http.get(
          Uri.parse('$_finnhubBase/stock/recommendation?symbol=$symbol&token=$_finnhubKey'),
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as List;
          if (data.isNotEmpty) {
            final latest = data.first;
            insights.add(ResearchInsight(
              id: symbol,
              symbol: symbol,
              companyName: _getCompanyNameForSymbol(symbol),
              recommendation: _mapRecommendation(latest),
              targetPrice: (latest['strongBuy'] ?? 0) * 150.0 + 100.0,
              currentPrice: 150.0,
              analyst: 'Finnhub Consensus',
              publishedAt: DateTime.now(),
              summary: 'Live analyst recommendation data from Finnhub',
              fullReport: 'Comprehensive analysis based on analyst consensus',
            ));
          }
        }
      } catch (e) {
        debugPrint('Error fetching recommendation for $symbol: $e');
      }
    }
    
    return insights.isNotEmpty ? insights : _getFallbackResearchData();
  }
  
  static String _mapRecommendation(Map<String, dynamic> data) {
    final strongBuy = data['strongBuy'] ?? 0;
    final buy = data['buy'] ?? 0;
    final hold = data['hold'] ?? 0;
    final sell = data['sell'] ?? 0;
    final strongSell = data['strongSell'] ?? 0;
    
    final total = strongBuy + buy + hold + sell + strongSell;
    if (total == 0) return 'HOLD';
    
    final buyRatio = (strongBuy + buy) / total;
    final sellRatio = (sell + strongSell) / total;
    
    if (buyRatio > 0.6) return 'BUY';
    if (sellRatio > 0.6) return 'SELL';
    return 'HOLD';
  }

  static Future<List<FOContract>> getFOContracts() async {
    final contracts = <FOContract>[];
    final symbols = ['SPY', 'QQQ', 'IWM'];
    
    for (final symbol in symbols) {
      try {
        final response = await http.get(
          Uri.parse('$_finnhubBase/quote?symbol=$symbol&token=$_finnhubKey'),
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final now = DateTime.now();
          final expiry = DateTime(now.year, now.month, 28);
          
          contracts.add(FOContract(
            symbol: symbol,
            instrumentType: 'FUTIDX',
            expiryDate: '${expiry.day}-${expiry.month.toString().padLeft(2, '0')}-${expiry.year}',
            lastPrice: (data['c'] ?? 150.0).toDouble(),
            changeAmount: (data['d'] ?? 0.0).toDouble(),
            changePercent: (data['dp'] ?? 0.0).toDouble(),
            volume: 1000000,
            openInterest: 800000,
            impliedVolatility: 0.0,
          ));
        }
      } catch (e) {
        debugPrint('Error fetching F&O data for $symbol: $e');
      }
    }
    
    return contracts.isNotEmpty ? contracts : _getFallbackFOData();
  }

  static List<ResearchInsight> _getFallbackResearchData() {
    final now = DateTime.now();
    return [
      ResearchInsight(
        id: '1',
        symbol: 'AAPL',
        companyName: 'Apple Inc',
        recommendation: 'BUY',
        targetPrice: 180.0,
        currentPrice: 150.0,
        analyst: 'Consensus Estimate',
        publishedAt: now.subtract(const Duration(hours: 2)),
        summary: 'Strong fundamentals with growth potential',
        fullReport: 'Detailed analysis shows positive outlook for Apple with strong iPhone sales and services growth driving revenue expansion.',
      ),
      ResearchInsight(
        id: '2',
        symbol: 'GOOGL',
        companyName: 'Alphabet Inc',
        recommendation: 'BUY',
        targetPrice: 140.0,
        currentPrice: 120.0,
        analyst: 'Tech Research',
        publishedAt: now.subtract(const Duration(hours: 4)),
        summary: 'AI leadership and cloud growth momentum',
        fullReport: 'Google continues to lead in AI innovation while cloud business shows strong growth trajectory.',
      ),
      ResearchInsight(
        id: '3',
        symbol: 'MSFT',
        companyName: 'Microsoft Corporation',
        recommendation: 'HOLD',
        targetPrice: 350.0,
        currentPrice: 340.0,
        analyst: 'Enterprise Focus',
        publishedAt: now.subtract(const Duration(hours: 6)),
        summary: 'Steady enterprise growth with cloud dominance',
        fullReport: 'Microsoft maintains strong position in enterprise software and cloud services with Azure leading market share.',
      ),
    ];
  }
  
  static List<FOContract> _getFallbackFOData() {
    final now = DateTime.now();
    final expiry = DateTime(now.year, now.month, 28);
    return [
      FOContract(
        symbol: 'SPY',
        instrumentType: 'FUTIDX',
        expiryDate: '${expiry.day}-${expiry.month.toString().padLeft(2, '0')}-${expiry.year}',
        lastPrice: 450.50,
        changeAmount: 2.30,
        changePercent: 0.51,
        volume: 2000000,
        openInterest: 1500000,
        impliedVolatility: 0.0,
      ),
      FOContract(
        symbol: 'QQQ',
        instrumentType: 'FUTIDX',
        expiryDate: '${expiry.day}-${expiry.month.toString().padLeft(2, '0')}-${expiry.year}',
        lastPrice: 380.25,
        changeAmount: -1.75,
        changePercent: -0.46,
        volume: 1800000,
        openInterest: 1200000,
        impliedVolatility: 0.0,
      ),
      FOContract(
        symbol: 'IWM',
        instrumentType: 'FUTIDX',
        expiryDate: '${expiry.day}-${expiry.month.toString().padLeft(2, '0')}-${expiry.year}',
        lastPrice: 220.80,
        changeAmount: 0.95,
        changePercent: 0.43,
        volume: 1500000,
        openInterest: 900000,
        impliedVolatility: 0.0,
      ),
    ];
  }

  static Future<List<Cryptocurrency>> getCryptocurrencies() async {
    try {
      final response = await http.get(
        Uri.parse('$_coinMarketCapBase/cryptocurrency/listings/latest?limit=100'),
        headers: {
          'X-CMC_PRO_API_KEY': _coinMarketCapKey,
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cryptoList = data['data'] ?? [];
        return cryptoList.map((crypto) => Cryptocurrency.fromJson(crypto)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching cryptocurrencies: $e');
    }
    
    return _getFallbackCryptoData();
  }

  static List<Cryptocurrency> _getFallbackCryptoData() {
    return [
      Cryptocurrency(
        id: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
        currentPrice: 43250.00,
        changeAmount: 1250.00,
        changePercent: 2.98,
        dayHigh: 44000.00,
        dayLow: 42000.00,
        marketCap: 847000000000,
        marketCapRank: 1,
        volume24h: 15000000000,
        circulatingSupply: 19600000,
        totalSupply: 21000000,
        image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
      ),
      Cryptocurrency(
        id: 'ethereum',
        symbol: 'ETH',
        name: 'Ethereum',
        currentPrice: 2650.00,
        changeAmount: -85.50,
        changePercent: -3.12,
        dayHigh: 2750.00,
        dayLow: 2600.00,
        marketCap: 318000000000,
        marketCapRank: 2,
        volume24h: 8500000000,
        circulatingSupply: 120000000,
        totalSupply: 120000000,
        image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png',
      ),
      Cryptocurrency(
        id: 'binancecoin',
        symbol: 'BNB',
        name: 'BNB',
        currentPrice: 315.75,
        changeAmount: 8.25,
        changePercent: 2.68,
        dayHigh: 320.00,
        dayLow: 305.00,
        marketCap: 47000000000,
        marketCapRank: 4,
        volume24h: 1200000000,
        circulatingSupply: 149000000,
        totalSupply: 200000000,
        image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png',
      ),
      Cryptocurrency(
        id: 'solana',
        symbol: 'SOL',
        name: 'Solana',
        currentPrice: 98.45,
        changeAmount: 4.15,
        changePercent: 4.40,
        dayHigh: 102.00,
        dayLow: 94.00,
        marketCap: 44000000000,
        marketCapRank: 5,
        volume24h: 2100000000,
        circulatingSupply: 447000000,
        totalSupply: 580000000,
        image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/5426.png',
      ),
      Cryptocurrency(
        id: 'cardano',
        symbol: 'ADA',
        name: 'Cardano',
        currentPrice: 0.385,
        changeAmount: 0.012,
        changePercent: 3.22,
        dayHigh: 0.395,
        dayLow: 0.370,
        marketCap: 13500000000,
        marketCapRank: 8,
        volume24h: 450000000,
        circulatingSupply: 35000000000,
        totalSupply: 45000000000,
        image: 'https://s2.coinmarketcap.com/static/img/coins/64x64/2010.png',
      ),
    ];
  }
}
