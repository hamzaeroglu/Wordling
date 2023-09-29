import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBase {
  static Database? _database;
  static final DataBase instance = DataBase._privateConstructor();

  DataBase._privateConstructor();

  factory DataBase() {
    return instance;
  }
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final Database db = await database;
    return await db.query('favourites');
  }


  Future<Database> get database async {
    if (_database != null) return _database!;

    // Eğer database daha önce oluşturulmamışsa, oluştur ve döndür
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'wordling_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future<int> deleteFavorite(int id) async {
    final db = await database;
    return await db.delete('favourites', where: 'id = ?', whereArgs: [id]);
  }



  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favourites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT,
        meaning TEXT,
        sentence TEXT,
        turkish_translation TEXT
      )
    ''');
  }

  Future<int> insertToFavourites(Map<String, dynamic> wordData) async {
    Database db = await database;
    int id = await db.insert('favourites', wordData);
    return id;
  }
}
