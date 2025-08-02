import 'package:flutter/material.dart';

class LearningCurveScreen extends StatelessWidget {
  const LearningCurveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Curve'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCourseCategory('Stock Market Basics', [
            'Introduction to Stock Markets',
            'How to Read Stock Charts',
            'Understanding Market Indices',
            'Risk Management Strategies',
          ]),
          const SizedBox(height: 20),
          _buildCourseCategory('Mutual Funds', [
            'Types of Mutual Funds',
            'SIP vs Lump Sum',
            'Fund Selection Criteria',
            'Tax Implications',
          ]),
          const SizedBox(height: 20),
          _buildCourseCategory('Personal Finance', [
            'Budgeting and Saving',
            'Insurance Planning',
            'Retirement Planning',
            'Tax Planning',
          ]),
          const SizedBox(height: 20),
          _buildCourseCategory('Advanced Trading', [
            'Technical Analysis',
            'Options Trading',
            'Futures and Derivatives',
            'Portfolio Management',
          ]),
        ],
      ),
    );
  }

  Widget _buildCourseCategory(String title, List<String> courses) {
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
            ...courses.map((course) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(course)),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
