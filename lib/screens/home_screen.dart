import 'package:flutter/material.dart';
import 'package:goodbible/models/bible_content_model.dart';
import 'package:goodbible/screens/search_screen.dart';
import 'package:goodbible/screens/search_text_screen.dart';
import 'package:goodbible/services/api_service.dart';
import 'package:goodbible/widgets/content_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String book;
  final int chapter;
  const HomeScreen({
    Key? key,
    required this.book,
    required this.chapter,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<BibleContentModel>> contentList;
  late String book;
  late int chapter;
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final savedBook = prefs.getString('savedBook');
    final savedChapter = prefs.getString('savedChapter');
    if (savedBook != null && savedChapter != null) {
      book = savedBook;
      chapter = int.parse(savedChapter);
      setState(() {});
    } else {
      book = "요한계시록";
      chapter = 0;
    }
  }

  searchAddressAction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ), // 이동할 페이지의 위젯
    );
  }

  searchTextAction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchTextScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    book = widget.book;
    chapter = widget.chapter;
    initPrefs();
    contentList = ApiService.getVerseListByBookAndChapter(book, chapter);
  }

  onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: searchAddressAction,
          child: Text(
            '$book ${chapter + 1}장',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.format_size),
          ),
        ],
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          FutureBuilder(
            future: contentList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: makeList(snapshot),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark),
            ),
            IconButton(
              onPressed: searchTextAction,
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
      ),
    );
  }
}

ListView makeList(AsyncSnapshot<List<BibleContentModel>> snapshot) {
  return ListView.separated(
    separatorBuilder: (context, index) => const SizedBox(
      height: 10,
    ),
    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
    scrollDirection: Axis.vertical,
    itemCount: snapshot.data?.length ?? 0,
    itemBuilder: (context, index) {
      var content = snapshot.data![index];
      return ContentWidget(
          book: content.book,
          chapter: content.chapter,
          verse: content.verse,
          text: content.text);
    },
  );
}
