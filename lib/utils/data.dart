import 'package:uuid/uuid.dart';

class DataUtils{
  static String makeUUID(){
    return const Uuid().v1();
  }

  static String nowTime(){
    DateTime now = DateTime.now();
    String formattedTime = now.toString();
    return formattedTime;
  }
}