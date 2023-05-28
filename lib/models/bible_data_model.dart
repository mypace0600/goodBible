import 'package:goodbible/models/book_data_model.dart';

class BibleDataModel {
  final List<BookDataModel> books;

  BibleDataModel.fromJson(Map<dynamic, dynamic> json) : books = json['books'];
}
