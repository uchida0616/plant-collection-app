import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlantDatabase {
  static Database? _db;

  // DBインスタンスを取得
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // DB初期化
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'plants.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE plants(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  // データ追加
  static Future<int> insertPlant(Map<String, dynamic> plant) async {
    final db = await database;
    return await db.insert('plants', plant);
  }

  // データ取得
  static Future<List<Map<String, dynamic>>> getPlants() async {
    final db = await database;
    return await db.query('plants');
  }
}
