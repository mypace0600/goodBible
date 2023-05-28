import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  final String book, text;
  final int chapter, verse;

  const ContentWidget({
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
            ':$verse $text',
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
