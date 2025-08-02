import 'package:flutter/foundation.dart';
import '../models/research_insight.dart';

class ResearchProvider with ChangeNotifier {
  List<ResearchInsight> _insights = [];
  bool _isLoading = false;
  String _selectedRecommendation = 'ALL';

  List<ResearchInsight> get insights => _insights;
  bool get isLoading => _isLoading;
  String get selectedRecommendation => _selectedRecommendation;

  List<ResearchInsight> get filteredInsights {
    if (_selectedRecommendation == 'ALL') return _insights;
    return _insights.where((insight) => 
      insight.recommendation == _selectedRecommendation).toList();
  }

  Future<void> loadResearchInsights() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _insights = _generateMockResearchData();
    } catch (e) {
      debugPrint('Error loading research insights: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedRecommendation(String recommendation) {
    _selectedRecommendation = recommendation;
    notifyListeners();
  }

  List<ResearchInsight> _generateMockResearchData() {
    final now = DateTime.now();
    
    return [
      ResearchInsight(
        id: '1',
        symbol: 'RELIANCE',
        companyName: 'Reliance Industries Ltd',
        recommendation: 'BUY',
        targetPrice: 2800.0,
        currentPrice: 2485.30,
        analyst: 'Kotak Securities',
        publishedAt: now.subtract(const Duration(hours: 2)),
        summary: 'Strong Q3 results with robust refining margins. Retail and digital businesses showing strong growth.',
        fullReport: 'Detailed analysis of Reliance Industries performance and future prospects...',
      ),
      ResearchInsight(
        id: '2',
        symbol: 'TCS',
        companyName: 'Tata Consultancy Services',
        recommendation: 'HOLD',
        targetPrice: 3650.0,
        currentPrice: 3580.25,
        analyst: 'HDFC Securities',
        publishedAt: now.subtract(const Duration(hours: 5)),
        summary: 'Steady performance in IT services. Margin pressure due to wage hikes.',
        fullReport: 'Comprehensive review of TCS quarterly performance and outlook...',
      ),
      ResearchInsight(
        id: '3',
        symbol: 'HDFC',
        companyName: 'HDFC Bank Ltd',
        recommendation: 'BUY',
        targetPrice: 1750.0,
        currentPrice: 1625.80,
        analyst: 'ICICI Securities',
        publishedAt: now.subtract(const Duration(hours: 8)),
        summary: 'Strong deposit growth and improving asset quality. NIM expansion expected.',
        fullReport: 'In-depth analysis of HDFC Bank financial metrics and growth drivers...',
      ),
      ResearchInsight(
        id: '4',
        symbol: 'INFY',
        companyName: 'Infosys Ltd',
        recommendation: 'SELL',
        targetPrice: 1420.0,
        currentPrice: 1485.60,
        analyst: 'Motilal Oswal',
        publishedAt: now.subtract(const Duration(hours: 12)),
        summary: 'Weak guidance for FY24. Client spending slowdown in key verticals.',
        fullReport: 'Detailed assessment of Infosys challenges and market headwinds...',
      ),
      ResearchInsight(
        id: '5',
        symbol: 'ICICIBANK',
        companyName: 'ICICI Bank Ltd',
        recommendation: 'BUY',
        targetPrice: 1050.0,
        currentPrice: 985.45,
        analyst: 'Axis Securities',
        publishedAt: now.subtract(const Duration(days: 1)),
        summary: 'Consistent performance across all segments. Strong retail franchise.',
        fullReport: 'Complete evaluation of ICICI Bank business model and growth strategy...',
      ),
    ];
  }
}
