import 'package:goodbible/models/save_file_model.dart';
import 'package:goodbible/models/save_text_model.dart';
import 'package:goodbible/repositories/sql_database.dart';

class SaveTextCRUDRepository {
  static Future<SaveText> create(SaveText saveText) async {
    var db = await SqlDataBase().database;
    var id = await db.insert(SaveText.tableName, saveText.toJson());
    return saveText.clone(id: id);
  }

  static Future<List<SaveText>> getList(int fileId) async {
    var db = await SqlDataBase().database;
    var result = await db.rawQuery('''
    SELECT ${SaveText.tableName}.*, ${SaveFile.tableName}.${SaveFileFields.fileName}
    FROM ${SaveText.tableName}
    LEFT JOIN ${SaveFile.tableName}
    ON ${SaveText.tableName}.${SaveTextFields.fileId} = ${SaveFile.tableName}.${SaveFileFields.fileId}
    WHERE ${SaveText.tableName}.${SaveTextFields.fileId} = $fileId
  ''');

    return result.map((data) {
      return SaveText.fromJson(data);
    }).toList();
  }

  static Future<void> deleteSaveTextById(int id) async {
    var db = await SqlDataBase().database;
    await db.delete(
      SaveText.tableName,
      where: '${SaveTextFields.id} = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateSaveTextById(int id, int newFileId) async {
    var db = await SqlDataBase().database;
    await db.update(
      SaveText.tableName,
      {'_fileId': newFileId},
      where: '_id = ?',
      whereArgs: [id],
    );
  }
}
