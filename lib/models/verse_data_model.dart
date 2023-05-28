class VerseDataModel {
  final int verse;
  final String text;

  VerseDataModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        verse = json['verse'];
}
