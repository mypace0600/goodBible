import 'package:flutter/material.dart';
import 'package:goodbible/models/save_text_model.dart';
import 'package:goodbible/repositories/save_text_crud_repository.dart';

class SavedTextListScreen extends StatefulWidget {
  final int fileId;
  final String fileName;
  const SavedTextListScreen({
    Key? key,
    required this.fileId,
    required this.fileName,
  }) : super(key: key);

  @override
  State<SavedTextListScreen> createState() => _SavedTextListScreenState();
}

class _SavedTextListScreenState extends State<SavedTextListScreen> {
  late Future<List<SaveText>> savedList;

  @override
  void initState() {
    super.initState();
    savedList = getAllSaveTextByFileId(widget.fileId);
  }

  Future<List<SaveText>> getAllSaveTextByFileId(int fileId) async {
    List<SaveText> result = await SaveTextCRUDRepository.getList(fileId);
    return result;
  }

  Future<void> deleteSavedData(int id) async {
    await SaveTextCRUDRepository.deleteSaveTextById(id);
    setState(() {
      savedList = getAllSaveTextByFileId(widget.fileId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: FutureBuilder<List<SaveText>>(
        future: savedList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final savedData = snapshot.data;
            if (savedData != null && savedData.isNotEmpty) {
              return ListView.builder(
                itemCount: savedData.length,
                itemBuilder: (context, index) {
                  String address =
                      '${savedData[index].book} ${savedData[index].chapter! + 1}:${savedData[index].verse}';
                  String contentText = '${savedData[index].text}';
                  return Dismissible(
                    key: Key(savedData[index].id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteSavedData(savedData[index].id!);
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
                      title: Text(address),
                      subtitle: Text(contentText),
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
