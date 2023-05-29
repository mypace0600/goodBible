import 'package:flutter/material.dart';
import 'package:goodbible/models/bible_search_model.dart';
import 'package:goodbible/services/api_service.dart';
import 'package:goodbible/widgets/search_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<BibleSearchModel>> searchList = ApiService.getBibleData();

  @override
  Widget build(BuildContext context) {
    // 페이지의 내용을 구현하세요.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
      ),
      body: FutureBuilder(
        future: searchList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: makeList(snapshot),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

ListView makeList(AsyncSnapshot<List<BibleSearchModel>> snapshot) {
  return ListView.separated(
    separatorBuilder: (context, index) => const SizedBox(
      height: 5,
    ),
    padding: const EdgeInsets.symmetric(
      vertical: 30,
      horizontal: 20,
    ),
    scrollDirection: Axis.vertical,
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      var search = snapshot.data![index];
      return SearchWidget(
        book: search.book,
        chapter: search.chapter,
      );
    },
  );
}
