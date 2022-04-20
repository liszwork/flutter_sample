import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'user_data.dart';

class DBProvider {
  final String _dbName = 'sqflite_test.db';
  final String _tableName = 'user_data';

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    // DBがない場合作成
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    print('connection db');
    return await openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insert(UserData note) async {
    final Database db = await database as Database;
    await db.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserData>> getUserDatas() async {
    final Database db = await database as Database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return UserData(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  delete(int id) async {
    // delete a record
    final Database db = await database as Database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  deleteAll() async {
    final Database db = await database as Database;
    await db.delete(_tableName);
  }
}
