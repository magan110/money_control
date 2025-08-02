import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../providers/news_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/market_provider.dart';
import '../providers/research_provider.dart';
import '../providers/crypto_provider.dart';
import 'home_screen.dart';
import 'markets_screen.dart';
import 'fo_screen.dart';
import 'news_screen.dart';
import 'portfolio_screen.dart';
import 'research_screen.dart';
import 'watchlist_screen.dart';
import 'sector_analysis_screen.dart';
import 'mutual_funds_screen.dart';
import 'forum_screen.dart';
import 'editor_picks_screen.dart';
import 'tech_screen.dart';
import 'india_news_screen.dart';
import 'learning_curve_screen.dart';
import 'commodities_screen.dart';
import 'personal_finance_screen.dart';
import 'videos_screen.dart';
import 'invest_now_screen.dart';
import 'crypto_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MarketsScreen(),
    const FOScreen(),
    const NewsScreen(),
    const PortfolioScreen(),
    const ResearchScreen(),
    const WatchlistScreen(),
    const CryptoScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stockProvider = context.read<StockProvider>();
    final newsProvider = context.read<NewsProvider>();
    final portfolioProvider = context.read<PortfolioProvider>();
    final marketProvider = context.read<MarketProvider>();
    final researchProvider = context.read<ResearchProvider>();
    final cryptoProvider = context.read<CryptoProvider>();

    await Future.wait([
      stockProvider.loadStocks(),
      newsProvider.loadNews(),
      portfolioProvider.loadPortfolio(),
      marketProvider.loadMarketData(),
      researchProvider.loadResearchInsights(),
      cryptoProvider.loadCryptocurrencies(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildNavigationDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'F&O',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Research',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_bitcoin),
            label: 'Crypto',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1E1E1E)),
            child: Text('MoneyControl', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Markets'),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('News'),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 3;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editor\'s Picks'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditorPicksScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.computer),
            title: const Text('Tech/Startups'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TechScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('India'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const IndiaNewsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Learning Curve'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LearningCurveScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart),
            title: const Text('Portfolio'),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 4;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Watchlist'),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 6;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.grain),
            title: const Text('Commodities'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CommoditiesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Mutual Funds'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MutualFundsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Personal Finance'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PersonalFinanceScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text('Forum'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForumScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Videos'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VideosScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Invest Now'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InvestNowScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Sector Analysis'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SectorAnalysisScreen()));
            },
          ),
        ],
      ),
    );
  }
}
