import 'package:flutter/material.dart';

class SearchContentWidget extends StatelessWidget {
  final String book, text;
  final int chapter, verse;

  const SearchContentWidget({
    super.key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            '${book.substring(0, 1)} $chapter:$verse $text',
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
