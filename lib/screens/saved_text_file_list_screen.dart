import 'package:flutter/material.dart';
import 'package:goodbible/models/save_file_model.dart';
import 'package:goodbible/repositories/save_file_crud_repository.dart';
import 'package:goodbible/screens/saved_text_list_screen.dart';

class SavedTextFileListScreen extends StatefulWidget {
  const SavedTextFileListScreen({Key? key}) : super(key: key);

  @override
  State<SavedTextFileListScreen> createState() =>
      _SavedTextFileListScreenState();
}

class _SavedTextFileListScreenState extends State<SavedTextFileListScreen> {
  late Future<List<SaveFile>> savedFileList;

  @override
  void initState() {
    super.initState();
    savedFileList = loadSaveFileList();
  }

  Future<List<SaveFile>> loadSaveFileList() async {
    List<SaveFile> result = await SaveFileCRUDRepository.getList();
    if (result.isEmpty) {
      SaveFile newFile = const SaveFile(fileName: 'recent');
      await SaveFileCRUDRepository.create(newFile);
    }
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
                    savedFileList = loadSaveFileList();
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

  void navigateToSavedTextListScreen(String fileName, int fileId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SavedTextListScreen(fileId: fileId, fileName: fileName),
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
            FutureBuilder<List<SaveFile>>(
              future: savedFileList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: List.generate(snapshot.data!.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          navigateToSavedTextListScreen(
                            snapshot.data![index].fileName!,
                            snapshot.data![index].fileId!,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          color: Colors.blue,
                          height: 100,
                          width: 100,
                          child: Center(
                            child: Text(
                              snapshot.data![index].fileName!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
