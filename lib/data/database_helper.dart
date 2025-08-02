import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'money_control.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE portfolio_holdings(
        id TEXT PRIMARY KEY,
        symbol TEXT NOT NULL,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        averagePrice REAL NOT NULL,
        currentPrice REAL NOT NULL,
        purchaseDate INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE watchlist(
        symbol TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        addedDate INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_preferences(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
