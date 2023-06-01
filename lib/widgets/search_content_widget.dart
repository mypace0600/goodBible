import 'package:flutter/material.dart';
import 'package:goodbible/services/api_service.dart';

class SearchContentWidget extends StatelessWidget {
  final String searchText, book, text;
  final int chapter, verse;
  final String short;

  SearchContentWidget({
    Key? key,
    required this.searchText,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  })  : short = ApiService.getShortByBook(book),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String totalText = '$short $chapter:$verse  $text';
    final spans = getSpans(totalText, searchText);

    return Row(
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
              ),
              children: spans,
            ),
          ),
        ),
      ],
    );
  }
}

List<TextSpan> getSpans(String text, String searchText) {
  final List<TextSpan> spans = [];
  int index = 0;

  while (index < text.length) {
    final startIndex = text.indexOf(searchText, index);

    if (startIndex == -1) {
      spans.add(TextSpan(text: text.substring(index)));
      break;
    }

    final endIndex = startIndex + searchText.length;
    spans.add(TextSpan(text: text.substring(index, startIndex)));

    spans.add(
      TextSpan(
        text: text.substring(startIndex, endIndex),
        style: const TextStyle(
          backgroundColor: Colors.yellow,
        ),
      ),
    );

    index = endIndex;
  }

  return spans;
}
