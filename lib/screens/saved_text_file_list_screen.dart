import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodbible/models/save_file_model.dart';
import 'package:goodbible/repositories/save_file_crud_repository.dart';
import 'package:goodbible/screens/saved_text_list_screen.dart';

class SavedTextFileListScreen extends StatefulWidget {
  const SavedTextFileListScreen({super.key});

  @override
  State<SavedTextFileListScreen> createState() =>
      _SavedTextFileListScreenState();
}

class _SavedTextFileListScreenState extends State<SavedTextFileListScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late List<String> fileTitles = [];

  @override
  void initState() {
    super.initState();
    loadSaveFileList();
  }

  Future<List<SaveFile>> loadSaveFileList() async {
    List<SaveFile> result = await SaveFileCRUDRepository.getList();
    if (result.isEmpty) {
      SaveFile newFile = const SaveFile(fileName: 'recent');
      await SaveFileCRUDRepository.create(newFile);
    }
    for (SaveFile item in result) {
      if (!fileTitles.contains(item.fileName)) {
        fileTitles.add(item.fileName!);
      }
    }
    setState(() {});
    return result;
  }

  Future<void> addNewFileKey(BuildContext context) async {
    String? fileName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? inputText;
        return AlertDialog(
          title: const Text('Enter File Name'),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(inputText);
                if (inputText != null && inputText!.isNotEmpty) {
                  SaveFile newFile = SaveFile(fileName: inputText!);
                  await SaveFileCRUDRepository.create(newFile);
                  setState(() {
                    fileTitles.add(inputText!);
                  });
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void navigateToSavedTextListScreen(String fileKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavedTextListScreen(fileKey: fileKey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Text Files'),
        actions: [
          IconButton(
            onPressed: () {
              addNewFileKey(context);
            },
            icon: const Icon(
              Icons.add_to_photos,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(fileTitles.length, (index) {
                return GestureDetector(
                  onTap: () {
                    navigateToSavedTextListScreen(fileTitles[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.blue,
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Text(
                        fileTitles[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
