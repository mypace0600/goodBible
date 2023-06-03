import 'package:goodbible/models/save_file_model.dart';
import 'package:goodbible/models/save_text_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String saveText = 'saveText';
const String saveFile = 'saveFile';

class SqlDataBase {
  static final SqlDataBase instance = SqlDataBase._instance();

  Database? _database;

  SqlDataBase._instance() {
    _initDataBase();
  }

  factory SqlDataBase() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _initDataBase();
    return _database!;
  }

  Future<void> _initDataBase() async {
    var dataBasesPath = await getDatabasesPath();
    String path = join(dataBasesPath, 'bible.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
      CREATE TABLE $saveText (
        ${SaveTextFields.id} integer primary key autoincrement,
        ${SaveFileFields.fileId} integer foreign key,
        ${SaveTextFields.book} text,
        ${SaveTextFields.chapter} integer,
        ${SaveTextFields.verse} integer,
        ${SaveTextFields.text} text,
        ${SaveTextFields.savedTime} text
      )
      
    ''');
        await db.execute('''
      CREATE TABLE $saveFile(
        ${SaveFileFields.fileId} integer primary key autoincrement,
        ${SaveFileFields.fileName} text
      )
      ''');
      },
    );
  }

  void closeDataBase() async {
    if (_database != null) await _database!.close();
  }
}
