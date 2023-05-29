import 'package:flutter/material.dart';
import 'package:goodbible/screens/home_screen.dart';

class ChapterSearchScreen extends StatefulWidget {
  final String book;
  final int chapter;
  const ChapterSearchScreen({
    Key? key,
    required this.book,
    required this.chapter,
  }) : super(key: key);

  @override
  State<ChapterSearchScreen> createState() => _ChapterSearchScreenState();
}

class _ChapterSearchScreenState extends State<ChapterSearchScreen> {
  int selectedButtonIndex = -1;
  changePage(BuildContext context, int chapter, String book) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            book: book,
            chapter: chapter,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) {
          return OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedButtonIndex = index;
                });
                changePage(context, selectedButtonIndex, widget.book);
              },
              child: Text('${index + 1}'));
        },
        itemCount: widget.chapter,
      ),
    );
  }
}
