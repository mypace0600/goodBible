import 'package:goodbible/models/verse_data_model.dart';

class ChapterDataModel {
  final int chapter;
  final List<VerseDataModel> verses;

  ChapterDataModel.fromJson(Map<dynamic, dynamic> json)
      : chapter = json['chapter'],
        verses = (json['verses'] as List<dynamic>)
            .map((verseJson) => VerseDataModel.fromJson(verseJson))
            .toList();
}
