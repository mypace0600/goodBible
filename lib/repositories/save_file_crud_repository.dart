import 'package:goodbible/models/save_file_model.dart';
import 'package:goodbible/repositories/sql_database.dart';

class SaveFileCRUDRepository {
  static Future<SaveFile> create(SaveFile saveFile) async {
    var db = await SqlDataBase().database;
    var id = await db.insert(SaveFile.tableName, saveFile.toJson());
    return saveFile.clone(fileId: id);
  }

  static Future<List<SaveFile>> getList() async {
    var db = await SqlDataBase().database;
    var result = await db.query(
      SaveFile.tableName,
      columns: [
        SaveFileFields.fileId,
        SaveFileFields.fileName,
      ],
    );
    return result.map(
      (data) {
        return SaveFile.fromJson(data);
      },
    ).toList();
  }

  static Future<void> deleteSaveFileById(int id) async {
    var db = await SqlDataBase().database;
    await db.delete(
      SaveFile.tableName,
      where: '${SaveFileFields.fileId}=?',
      whereArgs: [id],
    );
  }

  static Future<void> updateFileName(String newFileName, int id) async {
    var db = await SqlDataBase().database;
    await db.update(
      SaveFile.tableName,
      {'_fileName': newFileName},
      where: '_fileid = ?',
      whereArgs: [id],
    );
  }
}
