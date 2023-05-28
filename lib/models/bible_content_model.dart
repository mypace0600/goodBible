class BibleContentModel {
  final String book, text;
  final int chapter, verse;

  BibleContentModel({
    required this.book,
    required this.text,
    required this.chapter,
    required this.verse,
  });

  BibleContentModel.fromJson(Map<String, dynamic> json)
      : book = json['book'],
        chapter = json['chapter'],
        verse = json['verse'],
        text = json['text'];
}
