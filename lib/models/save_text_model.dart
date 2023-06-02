class SaveTextFields {
  static const String id = '_id';
  static const String fileIndex = '_fileIndex';
  static const String fileName = '_fileName';
  static const String book = '_book';
  static const String chapter = '_chapter';
  static const String verse = '_verse';
  static const String text = '_text';
  static const String savedTime = '_savedTime';
}

class SaveText {
  static String tableName = 'saveText';
  final int? id;
  final int? fileIndex;
  final String? fileName;
  final String? book;
  final int? chapter;
  final int? verse;
  final String? text;
  final String? savedTime;

  const SaveText({
    this.id,
    this.fileIndex,
    this.fileName,
    this.book,
    this.chapter,
    this.verse,
    this.text,
    this.savedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      SaveTextFields.id: id,
      SaveTextFields.fileIndex: fileIndex,
      SaveTextFields.fileName: fileName,
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
    String? fileName,
    String? book,
    int? chapter,
    int? verse,
    String? text,
    String? savedTime,
  }) {
    return SaveText(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
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
      fileName: json[SaveTextFields.fileName],
      book: json[SaveTextFields.book],
      chapter: json[SaveTextFields.chapter] as int,
      verse: json[SaveTextFields.verse] as int,
      text: json[SaveTextFields.text],
      savedTime: json[SaveTextFields.savedTime],
    );
  }
}
