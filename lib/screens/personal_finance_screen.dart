import 'package:flutter/material.dart';
import 'loans_screen.dart';
import 'fixed_deposits_screen.dart';
import 'mutual_funds_screen.dart';

class PersonalFinanceScreen extends StatelessWidget {
  const PersonalFinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Finance'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFinanceSection(context, 'Loans & Credit', [
            {'title': 'Personal Loans', 'subtitle': 'Up to ₹50 Lakhs', 'icon': Icons.account_balance_wallet, 'screen': const LoansScreen()},
            {'title': 'Home Loans', 'subtitle': 'Best rates available', 'icon': Icons.home, 'screen': const LoansScreen()},
            {'title': 'Car Loans', 'subtitle': 'Quick approval', 'icon': Icons.directions_car, 'screen': const LoansScreen()},
            {'title': 'Credit Cards', 'subtitle': 'Lifetime free cards', 'icon': Icons.credit_card, 'screen': const LoansScreen()},
          ]),
          const SizedBox(height: 20),
          _buildFinanceSection(context, 'Investments', [
            {'title': 'Fixed Deposits', 'subtitle': 'Compare FD rates', 'icon': Icons.savings, 'screen': const FixedDepositsScreen()},
            {'title': 'Mutual Funds', 'subtitle': 'SIP & lump sum', 'icon': Icons.trending_up, 'screen': const MutualFundsScreen()},
            {'title': 'Stocks', 'subtitle': 'Direct equity', 'icon': Icons.show_chart, 'screen': null},
            {'title': 'Bonds', 'subtitle': 'Fixed income', 'icon': Icons.receipt_long, 'screen': null},
          ]),
          const SizedBox(height: 20),
          _buildFinanceSection(context, 'Insurance', [
            {'title': 'Life Insurance', 'subtitle': 'Term & endowment', 'icon': Icons.security, 'screen': null},
            {'title': 'Health Insurance', 'subtitle': 'Medical coverage', 'icon': Icons.local_hospital, 'screen': null},
            {'title': 'Motor Insurance', 'subtitle': 'Car & bike', 'icon': Icons.directions_car, 'screen': null},
            {'title': 'Travel Insurance', 'subtitle': 'Domestic & international', 'icon': Icons.flight, 'screen': null},
          ]),
          const SizedBox(height: 20),
          _buildFinanceSection(context, 'Calculators', [
            {'title': 'EMI Calculator', 'subtitle': 'Loan EMI calculation', 'icon': Icons.calculate, 'screen': null},
            {'title': 'SIP Calculator', 'subtitle': 'Mutual fund returns', 'icon': Icons.timeline, 'screen': null},
            {'title': 'Tax Calculator', 'subtitle': 'Income tax calculation', 'icon': Icons.receipt, 'screen': null},
            {'title': 'Retirement Calculator', 'subtitle': 'Plan your retirement', 'icon': Icons.elderly, 'screen': null},
          ]),
        ],
      ),
    );
  }

  Widget _buildFinanceSection(BuildContext context, String title, List<Map<String, dynamic>> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => ListTile(
              leading: Icon(item['icon']),
              title: Text(item['title']),
              subtitle: Text(item['subtitle']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                if (item['screen'] != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => item['screen']),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item['title']} coming soon')),
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
