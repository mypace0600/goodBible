import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goodbible/models/bible_content_model.dart';
import 'package:goodbible/screens/about_screen.dart';
import 'package:goodbible/screens/saved_text_file_list_screen.dart';
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
  final TextEditingController textEditingController = TextEditingController();
  late Future<List<BibleContentModel>> contentList;
  late String book;
  late int chapter;
  late SharedPreferences prefs;
  User? _user;
  final bool _isLoggedIn = false;

  late int textFontButtonClicked = 0;

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
        builder: (context) => SearchTextScreen(
          textEditingController: textEditingController,
        ),
      ),
    );
  }

  aboutInfoAction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
  }

  savedTextList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SavedTextFileListScreen(),
      ),
    );
  }

  loginNotice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("로그인이 필요합니다."),
            content: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
              child: const Text("로그인 하러 가기"),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    book = widget.book;
    chapter = widget.chapter;
    initPrefs();
    contentList = ApiService.getVerseListByBookAndChapter(book, chapter);
    _user = FirebaseAuth.instance.currentUser;
  }

  textSizeChange() {
    textFontButtonClicked = textFontButtonClicked + 1;
    if (textFontButtonClicked == 3) {
      textFontButtonClicked = 0;
    }
    setState(() {});
  }

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
            onPressed: textSizeChange,
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
                  child: makeList(snapshot, textFontButtonClicked),
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
              onPressed: _isLoggedIn ? savedTextList : loginNotice,
              icon: const Icon(Icons.bookmark),
            ),
            IconButton(
              onPressed: searchTextAction,
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: aboutInfoAction,
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
      ),
    );
  }
}

ListView makeList(AsyncSnapshot<List<BibleContentModel>> snapshot,
    int textFontButtonClicked) {
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
          text: content.text,
          textFontButtonClicked: textFontButtonClicked);
    },
  );
}
