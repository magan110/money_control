import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/research_provider.dart';
import '../widgets/research_insight_card.dart';

class ResearchScreen extends StatelessWidget {
  const ResearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research Insights'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              context.read<ResearchProvider>().setSelectedRecommendation(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'ALL', child: Text('All')),
              const PopupMenuItem(value: 'BUY', child: Text('Buy')),
              const PopupMenuItem(value: 'SELL', child: Text('Sell')),
              const PopupMenuItem(value: 'HOLD', child: Text('Hold')),
            ],
          ),
        ],
      ),
      body: Consumer<ResearchProvider>(
        builder: (context, researchProvider, child) {
          if (researchProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final insights = researchProvider.filteredInsights;

          if (insights.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No research insights available'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => researchProvider.loadResearchInsights(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: insights.length,
              itemBuilder: (context, index) {
                return ResearchInsightCard(insight: insights[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
