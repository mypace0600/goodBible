import 'package:flutter/material.dart';
import 'package:goodbible/repositories/sql_database.dart';

import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqlDataBase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(
        book: '요한계시록',
        chapter: 0,
      ),
    );
  }
}
