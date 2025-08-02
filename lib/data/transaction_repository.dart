// No need to import sqflite directly as it's used through database_helper
import '../models/transaction.dart' as app_model;
import 'database_helper.dart';

class TransactionRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertTransaction(app_model.Transaction transaction) async {
    final db = await _databaseHelper.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<app_model.Transaction>> getAllTransactions() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => app_model.Transaction.fromMap(maps[i]));
  }

  Future<List<app_model.Transaction>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => app_model.Transaction.fromMap(maps[i]));
  }

  Future<List<app_model.Transaction>> getTransactionsByCategory(int categoryId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => app_model.Transaction.fromMap(maps[i]));
  }

  Future<List<app_model.Transaction>> getTransactionsByType(app_model.TransactionType type) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'type = ?',
      whereArgs: [type.index],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => app_model.Transaction.fromMap(maps[i]));
  }

  Future<double> getTotalByType(app_model.TransactionType type) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      [type.index],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getTotalByCategoryAndDateRange(
      int categoryId, DateTime startDate, DateTime endDate) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE categoryId = ? AND date >= ? AND date <= ?',
      [categoryId, startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> updateTransaction(app_model.Transaction transaction) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
