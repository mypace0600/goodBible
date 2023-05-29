import 'package:flutter/material.dart';
import 'package:goodbible/screens/chapter_search_screen.dart';

class SearchWidget extends StatelessWidget {
  final String book;
  final int chapter;

  const SearchWidget({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChapterSearchScreen(
              book: book,
              chapter: chapter,
            ),
          ),
        );
      },
      child: Text(
        book,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
