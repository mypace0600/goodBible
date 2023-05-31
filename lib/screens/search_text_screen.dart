import 'package:flutter/material.dart';
import 'package:goodbible/models/bible_content_model.dart';
import 'package:goodbible/services/api_service.dart';

class SearchTextScreen extends StatefulWidget {
  final TextEditingController textEditingController;
  const SearchTextScreen({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  State<SearchTextScreen> createState() => _SearchTextScreenState();
}

class _SearchTextScreenState extends State<SearchTextScreen> {
  late TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController = widget.textEditingController;
  }

  onSearchText(String text) {
    print(text);
    Future<List<BibleContentModel>> resultTextList =
        ApiService.searchTextList(text);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              const SizedBox(width: 50),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
      body: Container(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark),
            ),
            IconButton(
              onPressed: () {},
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
