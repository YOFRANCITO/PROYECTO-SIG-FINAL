import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'cortes.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Cortes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitud TEXT,
        longitud TEXT,
        cu TEXT,
        cf TEXT
      )
    ''');
  }

  Future<void> insertCorte(Map<String, String> corte) async {
    final db = await database;
    await db.insert('Cortes', corte, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCortes() async {
    final db = await database;
    return await db.query('Cortes');
  }
}
