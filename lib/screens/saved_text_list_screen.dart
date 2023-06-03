import 'package:flutter/material.dart';
import 'package:goodbible/models/save_file_model.dart';
import 'package:goodbible/models/save_text_model.dart';
import 'package:goodbible/repositories/save_file_crud_repository.dart';
import 'package:goodbible/repositories/save_text_crud_repository.dart';
import 'package:goodbible/screens/saved_text_file_list_screen.dart';
import 'package:goodbible/widgets/bottom_sheet_widget.dart';

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
  late Future<List<SaveText>> savedTextList;
  late Future<List<SaveFile>> savedFileList;
  List<SaveText> selectedItems = [];

  bool isSelectMode = false;

  @override
  void initState() {
    super.initState();
    savedTextList = getAllSaveTextByFileId(widget.fileId);
    savedFileList = getAllSaveFile();
  }

  Future<List<SaveText>> getAllSaveTextByFileId(int fileId) async {
    List<SaveText> result = await SaveTextCRUDRepository.getList(fileId);
    return result;
  }

  Future<List<SaveFile>> getAllSaveFile() async {
    List<SaveFile> result = await SaveFileCRUDRepository.getList();
    return result;
  }

  Future<void> deleteSavedData(int id) async {
    await SaveTextCRUDRepository.deleteSaveTextById(id);
    setState(() {
      savedTextList = getAllSaveTextByFileId(widget.fileId);
    });
  }

  Future<void> deletSaveFileById(int id) async {
    await SaveFileCRUDRepository.deleteSaveFileById(id);
    setState(() {
      savedFileList = getAllSaveFile();
    });
  }

  void showModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  // Delete 기능 수행
                  deletSaveFileById(widget.fileId);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedTextFileListScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  // Edit 기능 수행
                  Navigator.pop(context); // BottomSheet 닫기
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_box),
                title: const Text('Select'),
                onTap: () {
                  // Select 기능 수행
                  setState(() {
                    isSelectMode = !isSelectMode;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        actions: [
          IconButton(
              onPressed: () {
                showModal();
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: FutureBuilder<List<SaveText>>(
        future: savedTextList,
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
                      leading: isSelectMode
                          ? Checkbox(
                              value: selectedItems.contains(savedData[index]),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    selectedItems.add(savedData[index]);
                                  } else {
                                    selectedItems.remove(savedData[index]);
                                  }
                                });
                              })
                          : null,
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
      bottomSheet: isSelectMode
          ? BottomSheetWidget(
              selectedItems: selectedItems,
              deleteSavedData: deleteSavedData,
              isSelectMode: isSelectMode,
            )
          : null,
    );
  }
}
