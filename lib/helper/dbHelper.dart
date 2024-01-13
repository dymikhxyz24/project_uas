import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'user_comments.db');

    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    var tableExists = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='userComments';",
    );

    if (tableExists.isEmpty) {
      await db.execute('''
      CREATE TABLE userComments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        email TEXT,
        comment TEXT,
        created_date TEXT
      )
    ''');
    }
  }

  Future<int> saveComment(
      String email, String productId, String comment) async {
    var dbClient = await db;
    var now = DateTime.now();
    var formattedDate =
        "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
    return await dbClient.insert(
      'userComments',
      {
        'email': email,
        'productId': productId,
        'comment': comment,
        'created_date': formattedDate.toString(),
      },
    );
  }

  Future<Map<String, dynamic>> getComments(String productId) async {
    var dbClient = await db;
    var commentsResult = await dbClient.query(
      'userComments',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return {'comments': commentsResult};
  }

  Future<int> deleteComment(int commentId) async {
    var dbClient = await db;
    return await dbClient.delete(
      'userComments',
      where: 'id = ?',
      whereArgs: [commentId],
    );
  }
}
