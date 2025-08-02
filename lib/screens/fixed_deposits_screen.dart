import 'package:flutter/material.dart';

class FixedDepositsScreen extends StatelessWidget {
  const FixedDepositsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Deposits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateFDDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFDRatesCard(),
          const SizedBox(height: 16),
          Expanded(child: _buildFDsList()),
        ],
      ),
    );
  }

  Widget _buildFDRatesCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best FD Rates',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Compare rates across banks',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildBankRateCard('SBI', '6.8%'),
              const SizedBox(width: 12),
              _buildBankRateCard('HDFC', '7.1%'),
              const SizedBox(width: 12),
              _buildBankRateCard('ICICI', '7.0%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankRateCard(String bank, String rate) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(bank, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            Text(rate, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFDsList() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.savings, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No fixed deposits'),
          Text('Create your first FD to start earning'),
        ],
      ),
    );
  }

  void _showCreateFDDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Fixed Deposit'),
        content: const Text('FD creation form coming soon'),
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
