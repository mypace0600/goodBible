class SaveTextFields {
  static final String? id = '_id';
  static final String fileIndex = '_fileIndex';
  static final String fileName = '_fileName';
  static final String book = '_book';
  static final String chapter = '_chapter';
  static final String verse = '_verse';
  static final String text = '_text';
  static final String savedTime = '_savedTime';
}

class SaveText {
  static String tableName = 'saveText';
  final String? id;
  final int fileIndex;
  final String fileName;
  final String book;
  final int chapter;
  final int vere;
  final String text;
  final String savedTime;

  const SaveText({
    this.id,
    required this.fileIndex,
    required this.fileName,
    required this.book,
    required this.chapter,
    required this.vere,
    required this.text,
    required this.savedTime,
  });
  
}