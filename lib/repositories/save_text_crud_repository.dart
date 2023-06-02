import 'package:goodbible/models/save_text_model.dart';
import 'package:goodbible/repositories/sql_database.dart';

class SaveTextCRUDRepository {
  static Future<SaveText> create(SaveText saveText) async {
    var db = await SqlDataBase().database;
    var id = await db.insert(SaveText.tableName, saveText.toJson());
    return saveText.clone(id: id);
  }

  static Future<List<SaveText>> getList() async {
    var db = await SqlDataBase().database;
    var result = await db.query(
      SaveText.tableName,
      columns: [
        SaveTextFields.id,
        SaveTextFields.fileIndex,
        SaveTextFields.fileName,
        SaveTextFields.book,
        SaveTextFields.chapter,
        SaveTextFields.verse,
        SaveTextFields.text,
        SaveTextFields.savedTime,
      ],
    );

    return result.map(
      (data) {
        return SaveText.fromJson(data);
      },
    ).toList();
  }
}
