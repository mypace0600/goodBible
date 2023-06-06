import 'package:firebase_core/firebase_core.dart';
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
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Firebase load fail"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return const MaterialApp(
              home: HomeScreen(
                book: '요한계시록',
                chapter: 0,
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
