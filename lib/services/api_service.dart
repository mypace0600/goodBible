import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:goodbible/models/bible_content_model.dart';
import 'package:goodbible/models/book_data_model.dart';

class ApiService {
  static Future<List<BibleContentModel>> getVerseListByBookAndChapter(
      String book, int chapter) async {
    List<BibleContentModel> bibleContentInstances = [];
    String jsonString = await rootBundle.loadString('assets/bible/$book.json');
    var jsonResponse = jsonDecode(jsonString);
    BookDataModel bookDataModel = BookDataModel.fromJson(jsonResponse);

    for (var verseData in bookDataModel.chapters[chapter].verses) {
      BibleContentModel bibleContentModel = BibleContentModel(
        book: book,
        chapter: chapter,
        verse: verseData.verse,
        text: verseData.text,
      );
      bibleContentInstances.add(bibleContentModel);
    }
    return bibleContentInstances;
  }
}
