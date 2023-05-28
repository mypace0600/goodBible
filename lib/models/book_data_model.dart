import 'chapter_data_model.dart';

class BookDataModel {
  final String book;
  final List<ChapterDataModel> chapters;

  BookDataModel.fromJson(Map<dynamic, dynamic> json)
      : chapters = (json['chapters'] as List<dynamic>)
            .map((chapterJson) => ChapterDataModel.fromJson(chapterJson))
            .toList(),
        book = json['book'];
}
