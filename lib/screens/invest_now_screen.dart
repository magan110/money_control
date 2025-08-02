import 'package:flutter/material.dart';
import 'mutual_funds_screen.dart';
import 'portfolio_screen.dart';

class InvestNowScreen extends StatelessWidget {
  const InvestNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invest Now'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInvestmentBanner(context),
          const SizedBox(height: 20),
          _buildInvestmentOptions(context),
          const SizedBox(height: 20),
          _buildTopFunds(),
          const SizedBox(height: 20),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildInvestmentBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start Your Investment Journey',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Zero commission • Direct mutual funds • Expert advice',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MutualFundsScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
            ),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentOptions(BuildContext context) {
    final options = [
      {'title': 'SIP', 'subtitle': 'Start with ₹500/month', 'icon': Icons.timeline},
      {'title': 'Lump Sum', 'subtitle': 'One-time investment', 'icon': Icons.account_balance_wallet},
      {'title': 'ELSS', 'subtitle': 'Tax saving funds', 'icon': Icons.receipt},
      {'title': 'Goal Planning', 'subtitle': 'Plan for your goals', 'icon': Icons.flag},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Investment Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MutualFundsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(option['icon'] as IconData, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Text(
                                 option['title'] as String,
                                 style: const TextStyle(fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 option['subtitle'] as String,
                                 style: const TextStyle(fontSize: 12),
                               ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopFunds() {
    final topFunds = [
      {'name': 'Axis Bluechip Fund', 'returns': '12.5%', 'rating': 5},
      {'name': 'HDFC Top 100 Fund', 'returns': '11.8%', 'rating': 4},
      {'name': 'SBI Large Cap Fund', 'returns': '10.9%', 'rating': 4},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Performing Funds',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...topFunds.map((fund) => ListTile(
              title: Text(fund['name'] as String),
              subtitle: Text('1Y Returns: ${fund['returns']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) => Icon(
                  Icons.star,
                  size: 16,
                  color: index < (fund['rating'] as int) ? Colors.amber : Colors.grey,
                )),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionButton(context, 'Portfolio', Icons.pie_chart, const PortfolioScreen()),
                _buildQuickActionButton(context, 'SIP Book', Icons.book, null),
                _buildQuickActionButton(context, 'Reports', Icons.assessment, null),
                _buildQuickActionButton(context, 'Goals', Icons.flag, null),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, String label, IconData icon, Widget? screen) {
    return InkWell(
      onTap: () {
        if (screen != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => screen),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label coming soon')),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 8),
           Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
