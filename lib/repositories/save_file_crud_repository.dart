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
}