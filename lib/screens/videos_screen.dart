import 'package:flutter/material.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Market'),
            Tab(text: 'Analysis'),
            Tab(text: 'Education'),
            Tab(text: 'Podcasts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMarketVideos(),
          _buildAnalysisVideos(),
          _buildEducationVideos(),
          _buildPodcasts(),
        ],
      ),
    );
  }

  Widget _buildMarketVideos() {
    final videos = [
      {'title': 'Market Outlook for August 2025', 'duration': '15:30', 'views': '25K'},
      {'title': 'Nifty Technical Analysis', 'duration': '12:45', 'views': '18K'},
      {'title': 'Sector Rotation Strategy', 'duration': '20:15', 'views': '32K'},
      {'title': 'Weekly Market Wrap', 'duration': '18:20', 'views': '28K'},
      {'title': 'Global Market Update', 'duration': '14:50', 'views': '22K'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return _buildVideoTile(videos[index]);
      },
    );
  }

  Widget _buildAnalysisVideos() {
    final videos = [
      {'title': 'Stock Analysis: TCS Q1 Results', 'duration': '18:20', 'views': '42K'},
      {'title': 'Mutual Fund Review', 'duration': '25:10', 'views': '28K'},
      {'title': 'IPO Analysis: Latest Listings', 'duration': '16:45', 'views': '35K'},
      {'title': 'Banking Sector Deep Dive', 'duration': '22:30', 'views': '31K'},
      {'title': 'IT Stocks Performance Review', 'duration': '19:15', 'views': '26K'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return _buildVideoTile(videos[index]);
      },
    );
  }

  Widget _buildEducationVideos() {
    final videos = [
      {'title': 'Options Trading Basics', 'duration': '30:15', 'views': '65K'},
      {'title': 'How to Read Balance Sheet', 'duration': '22:30', 'views': '48K'},
      {'title': 'Tax Saving Strategies', 'duration': '19:45', 'views': '38K'},
      {'title': 'Portfolio Diversification', 'duration': '25:20', 'views': '42K'},
      {'title': 'Risk Management Techniques', 'duration': '28:10', 'views': '35K'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return _buildVideoTile(videos[index]);
      },
    );
  }

  Widget _buildPodcasts() {
    final podcasts = [
      {'title': 'Market Wrap: Weekly Review', 'duration': '45:20', 'views': '15K'},
      {'title': 'Expert Interview: Fund Manager', 'duration': '38:15', 'views': '22K'},
      {'title': 'Startup Stories', 'duration': '42:30', 'views': '18K'},
      {'title': 'Economic Policy Discussion', 'duration': '52:45', 'views': '19K'},
      {'title': 'Investment Philosophy', 'duration': '35:20', 'views': '16K'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: podcasts.length,
      itemBuilder: (context, index) {
        return _buildVideoTile(podcasts[index]);
      },
    );
  }

  Widget _buildVideoTile(Map<String, String> video) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.play_circle_outline, size: 30),
        ),
        title: Text(
          video['title']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey[400]),
            const SizedBox(width: 4),
            Text(video['duration']!),
            const SizedBox(width: 16),
            Icon(Icons.visibility, size: 16, color: Colors.grey[400]),
            const SizedBox(width: 4),
            Text('${video['views']} views'),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Playing ${video['title']}')),
          );
        },
      ),
    );
  }
}
