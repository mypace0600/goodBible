import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodbible/screens/saved_text_list_screen.dart';

class SavedTextFileListScreen extends StatefulWidget {
  const SavedTextFileListScreen({super.key});

  @override
  State<SavedTextFileListScreen> createState() => _SavedTextFileListScreenState();
}

class _SavedTextFileListScreenState extends State<SavedTextFileListScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late List<String> fileKeys = [];

  @override
  void initState(){
    super.initState();
    loadFileKeys();
  }

  Future<void> loadFileKeys()async {
    bool recentExists = await secureStorage.containsKey(key: 'recent');
    List<String> keys = await secureStorage.readAll().then((value) => value.keys.toList(),);
    print('recentExists ? $recentExists');
    if(!recentExists){
      fileKeys.add('recent');
    }
    setState(() {
      fileKeys.addAll(keys);
    });
    print(fileKeys);
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
              onPressed: () {
                Navigator.of(context).pop(inputText);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (fileName != null) {
      setState(() {
        fileKeys.add(fileName);
      });
    }
  }

  void navigateToSavedTextListScreen(String fileKey){
    Navigator.push(context,
    MaterialPageRoute(builder: (context)=> SavedTextListScreen(fileKey:fileKey),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Saved Text Files'),
        actions: [
          IconButton(
            onPressed: (){
              addNewFileKey(context);
            },
            icon: const Icon(Icons.add_to_photos,),
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
              children: List.generate(fileKeys.length, (index) {
                return GestureDetector(
                  onTap: (){
                    navigateToSavedTextListScreen(fileKeys[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.blue,
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Text(
                        fileKeys[index],
                        style: TextStyle(color: Colors.white),
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