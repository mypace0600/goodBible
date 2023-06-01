import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SavedTextListScreen extends StatefulWidget {
  const SavedTextListScreen({super.key});

  @override
  State<SavedTextListScreen> createState() => _SavedTextListScreenState();
}

class _SavedTextListScreenState extends State<SavedTextListScreen> {
  late Future<Map<String, String>> savedList;

  @override
  void initState() {
    super.initState();
    savedList = getAllSavedData();
  }

  Future<Map<String, String>> getAllSavedData() async {
    const storage = FlutterSecureStorage();
    return await storage.readAll();
  }

  Future<void> deleteSavedData(String key) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: key);
    setState(() {
      savedList = getAllSavedData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Text List'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: savedList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final savedData = snapshot.data;
            if (savedData != null) {
              return ListView.builder(
                itemCount: savedData.length,
                itemBuilder: (context, index) {
                  final key = savedData.keys.elementAt(index);
                  final value = savedData[key];
                  return Dismissible(
                    key: Key(key),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteSavedData(key);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      title: Text(key),
                      subtitle: Text(value ?? ''),
                    ),
                  );
                },
              );
            }
          }
          return const Center(
            child: Text('No saved data.'),
          );
        },
      ),
    );
  }
}
