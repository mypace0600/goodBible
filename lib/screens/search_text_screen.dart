import 'package:flutter/material.dart';
import 'package:goodbible/models/bible_content_model.dart';
import 'package:goodbible/services/api_service.dart';
import 'package:goodbible/widgets/search_content_widget.dart';

class SearchTextScreen extends StatefulWidget {
  final TextEditingController textEditingController;
  const SearchTextScreen({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  State<SearchTextScreen> createState() => _SearchTextScreenState();
}

class _SearchTextScreenState extends State<SearchTextScreen> {
  late TextEditingController textEditingController = TextEditingController();
  late Future<List<BibleContentModel>> resultTextList;

  @override
  void initState() {
    super.initState();
    // textEditingController = widget.textEditingController;
    resultTextList = Future.value([]);
  }

  onSearchText(String text) {
    setState(() {
      resultTextList = ApiService.searchTextList(text);
    });
  }

  @override
  void dispose() {
    // textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: null,
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              const SizedBox(width: 50),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(224, 224, 224, 0.8),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            hintText: '검색',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          onSearchText(textEditingController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: resultTextList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '전체 검색 수 : ${snapshot.data!.length}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: resultTextList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return makeList(snapshot, textEditingController.text);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

ListView makeList(
    AsyncSnapshot<List<BibleContentModel>> snapshot, String searchText) {
  if (snapshot.hasData == true) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data?.length ?? 0,
      itemBuilder: (context, index) {
        var content = snapshot.data![index];
        return SearchContentWidget(
            searchText: searchText,
            book: content.book,
            chapter: content.chapter,
            verse: content.verse,
            text: content.text);
      },
    );
  }
  return ListView();
}
