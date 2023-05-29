import 'package:flutter/material.dart';

class ChapterSearchScreen extends StatelessWidget {
  final String book;
  final int chapter;
  const ChapterSearchScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) {
          return null;
        },
        itemCount: chapter,
      ),
    );
  }
}
