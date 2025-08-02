import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../providers/news_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/market_provider.dart';
import '../providers/research_provider.dart';
import 'home_screen.dart';
import 'markets_screen.dart';
import 'fo_screen.dart';
import 'news_screen.dart';
import 'portfolio_screen.dart';
import 'research_screen.dart';
import 'watchlist_screen.dart';
import 'sector_analysis_screen.dart';
import 'mutual_funds_screen.dart';
import 'loans_screen.dart';
import 'fixed_deposits_screen.dart';
import 'forum_screen.dart';

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

    await Future.wait([
      stockProvider.loadStocks(),
      newsProvider.loadNews(),
      portfolioProvider.loadPortfolio(),
      marketProvider.loadMarketData(),
      researchProvider.loadResearchInsights(),
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
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Sector Analysis'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SectorAnalysisScreen()));
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
            title: const Text('Loans'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoansScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.savings),
            title: const Text('Fixed Deposits'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FixedDepositsScreen()));
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
        ],
      ),
    );
  }
}
