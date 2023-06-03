import 'package:goodbible/models/save_file_model.dart';

class SaveTextFields {
  static const String id = '_id';
  static const String fileId = '_fileId';
  static const String book = '_book';
  static const String chapter = '_chapter';
  static const String verse = '_verse';
  static const String text = '_text';
  static const String savedTime = '_savedTime';
}

class SaveText {
  static String tableName = 'saveText';
  final int? id;
  final int? fileId;
  final String? book;
  final int? chapter;
  final int? verse;
  final String? text;
  final String? savedTime;

  const SaveText({
    this.id,
    this.fileId,
    this.book,
    this.chapter,
    this.verse,
    this.text,
    this.savedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      SaveTextFields.id: id,
      SaveFileFields.fileId: fileId,
      SaveTextFields.book: book,
      SaveTextFields.chapter: chapter,
      SaveTextFields.verse: verse,
      SaveTextFields.text: text,
      SaveTextFields.savedTime: savedTime,
    };
  }

  SaveText clone({
    int? id,
    int? fileIndex,
    String? book,
    int? chapter,
    int? verse,
    String? text,
    String? savedTime,
  }) {
    return SaveText(
      id: id ?? this.id,
      fileId: fileId ?? fileId,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      text: text ?? this.text,
      savedTime: savedTime ?? this.savedTime,
    );
  }

  factory SaveText.fromJson(Map<dynamic, dynamic> json) {
    return SaveText(
      id: json[SaveTextFields.id] as int,
      fileId: json[SaveFileFields.fileId],
      book: json[SaveTextFields.book],
      chapter: json[SaveTextFields.chapter] as int,
      verse: json[SaveTextFields.verse] as int,
      text: json[SaveTextFields.text],
      savedTime: json[SaveTextFields.savedTime],
    );
  }
}
