import 'package:flutter/foundation.dart';
import '../models/research_insight.dart';
import '../services/api_service.dart';

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
      _insights = await ApiService.getAnalystRecommendations();
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

}
