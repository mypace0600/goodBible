import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:goodbible/enums/bible_title.dart';
import 'package:goodbible/models/bible_content_model.dart';
import 'package:goodbible/models/bible_search_model.dart';
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

  static Future<List<BibleSearchModel>> getBibleData() async {
    List<BibleSearchModel> searchModelInstances = [];
    for (String title in BibleTitles.bibleTitles) {
      String jsonString =
          await rootBundle.loadString('assets/bible/$title.json');
      var jsonResponse = jsonDecode(jsonString);
      BookDataModel bookDataModel = BookDataModel.fromJson(jsonResponse);
      BibleSearchModel searchModel = BibleSearchModel();
      searchModel.book = bookDataModel.book;
      searchModel.chapter = bookDataModel.chapters.length;
      searchModelInstances.add(searchModel);
    }
    return searchModelInstances;
  }
}
