import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showLoanApplicationDialog(context),
          ),
        ],
      ),
      body: Consumer<LoanProvider>(
        builder: (context, loanProvider, child) {
          if (loanProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildLoanOffers(),
              const SizedBox(height: 16),
              Expanded(child: _buildLoansList(loanProvider.loans)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoanOffers() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            'Instant Loans up to ₹15 Lakhs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Quick approval • Minimal documentation',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLoanTypeCard('Personal Loan', 'Up to ₹15L'),
              const SizedBox(width: 12),
              _buildLoanTypeCard('Business Loan', 'Up to ₹50L'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoanTypeCard(String title, String amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            Text(amount, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoansList(List<dynamic> loans) {
    if (loans.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No active loans'),
            Text('Apply for a loan to get started'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.account_balance, color: Colors.blue.shade700),
            ),
            title: Text(loan.type, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: ₹${loan.amount.toStringAsFixed(0)}'),
                Text('EMI: ₹${loan.emi.toStringAsFixed(0)} • ${loan.tenure} months'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: loan.status == 'Approved' ? Colors.green.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                loan.status,
                style: TextStyle(
                  color: loan.status == 'Approved' ? Colors.green.shade700 : Colors.orange.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLoanApplicationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Loan'),
        content: const Text('Loan application form coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
