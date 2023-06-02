import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableName = 'savedText';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'superAwesomeDb.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
         CREATE TABLE $tableName (
           id INTEGER PRIMARY KEY,
           fileName TEXT,
           book TEXT,
           chapter INTEGER,
           verse INTEGER,
           text TEXT
         )
        ''');
      },
    );
  }
}
