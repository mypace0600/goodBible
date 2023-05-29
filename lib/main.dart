import 'package:flutter/material.dart';
import 'package:goodbible/models/bible_search_model.dart';
import 'package:goodbible/services/api_service.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
  Future<List<BibleSearchModel>> test = ApiService.getBibleData();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
