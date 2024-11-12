import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('donors.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE donors(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      phone TEXT,
      bloodType TEXT,
      rhFactor TEXT,
      lastDonationDate TEXT,
      gender TEXT
    )''');
  }

  Future<int> insertDonor(Map<String, dynamic> donor) async {
    final db = await instance.database;
    return await db.insert('donors', donor);
  }

  Future<int> updateDonor(Map<String, dynamic> donor) async {
    final db = await instance.database;
    return await db.update(
      'donors',
      donor,
      where: 'id = ?',
      whereArgs: [donor['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getAllDonors() async {
    final db = await instance.database;
    return await db.query('donors');
  }

  Future<void> deleteDonor(int id) async {
    final db = await instance.database;
    await db.delete(
      'donors',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
