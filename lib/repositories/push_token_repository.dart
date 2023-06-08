import 'package:goodbible/models/push_notification_info.dart';
import 'package:goodbible/repositories/sql_database.dart';

class PushTokenCRUDRepository {
  static Future<void> save(PushInfo pushInfo) async {
    var db = await SqlDataBase().database;
    db.insert(PushInfo.tableName, pushInfo.toJson());
  }

  static Future<void> remove(String userEmail) async {
    var db = await SqlDataBase().database;
    db.delete(
      PushInfo.tableName,
      where: '${PushInfoFields.userId} = ?',
      whereArgs: [userEmail],
    );
  }
}
