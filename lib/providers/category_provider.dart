import 'package:flutter/foundation.dart';
import '../models/category.dart' as app_model;
import '../data/category_repository.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();
  List<app_model.Category> _categories = [];
  bool _isLoading = false;

  List<app_model.Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _repository.getAllCategories();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(app_model.Category category) async {
    try {
      await _repository.insertCategory(category);
      await loadCategories();
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }

  Future<void> updateCategory(app_model.Category category) async {
    try {
      await _repository.updateCategory(category);
      await loadCategories();
    } catch (e) {
      debugPrint('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _repository.deleteCategory(id);
      await loadCategories();
    } catch (e) {
      debugPrint('Error deleting category: $e');
    }
  }

  List<app_model.Category> getCategoriesByType(dynamic type) {
    // Convert transaction_model.TransactionType to app_model.TransactionType if needed
    app_model.TransactionType categoryType;
    
    if (type is app_model.TransactionType) {
      categoryType = type;
    } else {
      // Assuming both enums have the same order: income = 0, expense = 1
      categoryType = type.index == 0 
          ? app_model.TransactionType.income 
          : app_model.TransactionType.expense;
    }
    
    return _categories.where((c) => c.type == categoryType).toList();
  }

  app_model.Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  List<app_model.Category> get expenseCategories => getCategoriesByType(app_model.TransactionType.expense);
  List<app_model.Category> get incomeCategories => getCategoriesByType(app_model.TransactionType.income);
}
