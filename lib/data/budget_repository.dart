// No need to import sqflite directly as it's used through database_helper
import '../models/budget.dart';
import 'database_helper.dart';

class BudgetRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertBudget(Budget budget) async {
    final db = await _databaseHelper.database;
    return await db.insert('budgets', budget.toMap());
  }

  Future<List<Budget>> getAllBudgets() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('budgets');
    return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
  }

  Future<Budget?> getBudgetByCategoryId(int categoryId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'budgets',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    if (maps.isNotEmpty) {
      return Budget.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBudget(Budget budget) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<int> updateBudgetSpent(int budgetId, double spent) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'budgets',
      {'spent': spent},
      where: 'id = ?',
      whereArgs: [budgetId],
    );
  }

  Future<int> deleteBudget(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
