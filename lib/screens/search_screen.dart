import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 페이지의 내용을 구현하세요.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
      ),
      body: const Center(
        child: Text('This is the Search Screen'),
      ),
    );
  }
}
