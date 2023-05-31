import 'dart:convert';
import 'dart:isolate';

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

  static Future<List<String>> searchTextList(String searchText) async {
    List<String> jsonFileList = [];
    for(String title in BibleTitles.bibleTitles){
      String text = 'assets/bible/$title.json';
      jsonFileList.add(text);
    }
    List<ReceivePort> receivePorts = [];
    List<Isolate> isolates = [];

    for (String jsonFilePath in jsonFileList) {
      ReceivePort receivePort = ReceivePort();
      receivePorts.add(receivePort);

      Isolate isolate = await Isolate.spawn(
        jsonSearchIsolate,
        {'filePath': jsonFilePath, 'searchText': searchText, 'sendPort': receivePort.sendPort},
      );
      isolates.add(isolate);
    }
    List<dynamic> searchResults = [];
    for (ReceivePort receivePort in receivePorts) {
      dynamic result = await receivePort.first;
      searchResults.addAll(result);
    }
    for (var result in searchResults) {
      // 검색 결과 처리 (예: 출력, 저장 등)
      print('검색 결과: $result');
    }

    for (Isolate isolate in isolates) {
      isolate.kill();
    }
    return [];
  }

  static void jsonSearchIsolate(Map<String, dynamic> message) async {
  String filePath = message['filePath'];
  String searchText = message['searchText'];
  SendPort sendPort = message['sendPort'];

  String jsonString = await rootBundle.loadString(filePath);
  List<dynamic> jsonData = jsonDecode(jsonString);

  List<dynamic> searchResults = [];
  for (var item in jsonData) {
    if (item.toString().contains(searchText)) {
      searchResults.add(item);
    }
  }

  sendPort.send(searchResults);
}
}
