import 'dart:convert';

import 'package:flutter/services.dart';
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
    for (var map in BibleTitles.bibleTitles) {
      String? title = map['title'];
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

  static Future<List<BibleContentModel>> searchTextList(
      String searchText) async {
    List<BookDataModel> bookDataModelList = await loadAllBookDataModels();
    List<BibleContentModel> searchResults = [];

    await Future.forEach(bookDataModelList, (BookDataModel bookData) async {
      await Future.forEach(bookData.chapters,
          (ChapterDataModel chapterData) async {
        await Future.forEach(chapterData.verses, (VerseDataModel verseData) {
          if (verseData.text.contains(searchText)) {
            BibleContentModel bibleContentModel = BibleContentModel(
              book: bookData.book,
              chapter: chapterData.chapter,
              verse: verseData.verse,
              text: verseData.text,
            );
            searchResults.add(bibleContentModel);
          }
        });
      });
    });

    return searchResults;
  }

  static Future<List<BookDataModel>> loadAllBookDataModels() async {
    List<Future<BookDataModel>> futures = [];
    for (var map in BibleTitles.bibleTitles) {
      String? title = map['title'] ?? "";
      Future<BookDataModel> future = loadBookDataModel(title);
      futures.add(future);
    }
    return await Future.wait(futures);
  }

  static Future<BookDataModel> loadBookDataModel(String title) async {
    String jsonString = await rootBundle.loadString('assets/bible/$title.json');
    var jsonResponse = jsonDecode(jsonString);
    BookDataModel bookDataModel = BookDataModel.fromJson(jsonResponse);
    return bookDataModel;
  }

  static String getShortByBook(String book) {
    for (var map in BibleTitles.bibleTitles) {
      if (map['title'] == book) {
        return map['abbreviation'] ?? "";
      }
    }
    return "";
  }
}
