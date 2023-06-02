import 'package:goodbible/models/save_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDataBase{
  static final SqlDataBase instance = SqlDataBase._instance();

  Database? _database;

  SqlDataBase._instance(){
    _initDataBase();

  }

  factory SqlDataBase(){
    return instance;
  }

  Future<void> _initDataBase()async{
    var dataBasesPath = await getDatabasesPath();
    String path = join(dataBasesPath,'bible.db');
    _database = await openDatabase(path,version: 1,onCreate: _databaseCreate);
  }

  void _databaseCreate(Database db, int version)async{
    await db.execute('''
      create table ${SaveText.tableName} (
        ${SaveTextFields.id} integer primary key autoincrement,
        ${SaveTextFields.fileIndex} integer,
        ${SaveTextFields.fileName} text,
        ${SaveTextFields.book} text,
        ${SaveTextFields.chapter} integer,
        ${SaveTextFields.verse} integer,
        ${SaveTextFields.text} text,
        ${SaveTextFields.savedTime} text
      )
    ''');
  }
}