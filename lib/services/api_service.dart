import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:goodbible/enums/bible_title.dart';
import 'package:goodbible/models/bible_content_model.dart';
import 'package:goodbible/models/bible_search_model.dart';
import 'package:goodbible/models/book_data_model.dart';
import 'package:goodbible/models/chapter_data_model.dart';
import 'package:goodbible/models/verse_data_model.dart';

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

  static Future<List<BibleContentModel>> searchTextList(String searchText) async {

    List<BookDataModel> bookDataModelList = [];
    List<Future<BookDataModel>> futures = [];

    for (String title in BibleTitles.bibleTitles) {
      Future<BookDataModel> future = loadBookDataModel(title);
      futures.add(future);
    }

    bookDataModelList = await Future.wait(futures);

    for(BookDataModel bookData in bookDataModelList){
      for(ChapterDataModel chapterData in bookData.chapters){
        for(VerseDataModel verseData in chapterData.verses){
          if(verseData.text.contains(searchText)){
            print('${bookData.book} ${chapterData.chapter} ${verseData.verse} ${verseData.text}');
          }
        }
      }
    }


    return [];
  }

  static Future<BookDataModel> loadBookDataModel(String title) async {
    String jsonString = await rootBundle.loadString('assets/bible/$title.json');
    var jsonResponse = jsonDecode(jsonString);
    BookDataModel bookDataModel = BookDataModel.fromJson(jsonResponse);
    return bookDataModel;
  }
}
