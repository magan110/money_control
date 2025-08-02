// No need to import sqflite directly as it's used through database_helper
import '../models/account.dart';
import 'database_helper.dart';

class AccountRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertAccount(Account account) async {
    final db = await _databaseHelper.database;
    return await db.insert('accounts', account.toMap());
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return List.generate(maps.length, (i) => Account.fromMap(maps[i]));
  }

  Future<Account?> getAccountById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Account.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateAccount(Account account) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<int> updateAccountBalance(int accountId, double balance) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'accounts',
      {'balance': balance},
      where: 'id = ?',
      whereArgs: [accountId],
    );
  }

  Future<int> deleteAccount(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalBalance() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('SELECT SUM(balance) as total FROM accounts');
    return result.first['total'] as double? ?? 0.0;
  }
}
