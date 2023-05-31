import 'package:flutter/material.dart';
import 'package:goodbible/services/api_service.dart';

class SearchContentWidget extends StatelessWidget {
  final String book, text;
  final int chapter, verse;
  final String short;

  SearchContentWidget({
    Key? key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  })  : short = ApiService.getShortByBook(book),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            '$short $chapter:$verse $text',
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
