import 'package:flutter/material.dart';
import 'package:goodbible/models/save_file_model.dart';
import 'package:goodbible/models/save_text_model.dart';
import 'package:goodbible/repositories/save_file_crud_repository.dart';
import 'package:goodbible/repositories/save_text_crud_repository.dart';
import 'package:goodbible/screens/saved_text_file_list_screen.dart';
import 'package:goodbible/widgets/bottom_sheet_widget.dart';

class SavedTextListScreen extends StatefulWidget {
  final int fileId;
  String fileName;
  SavedTextListScreen({
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
  bool isEditMode = false;

  final TextEditingController _nameEditingController = TextEditingController();

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

  Future<void> _editFileName(String newName, int fileId) async {
    await SaveFileCRUDRepository.updateFileName(newName, fileId);
    setState(() {
      widget.fileName = newName;
    });
  }

  void _showNameInputDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Name'),
            content: TextField(
              controller: _nameEditingController,
              decoration: const InputDecoration(hintText: 'New Name is'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _editFileName(_nameEditingController.text, widget.fileId);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedTextFileListScreen(),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  void _showAreYouSureDialog() {
    final curreuntContext = context;
    showDialog(
        context: curreuntContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are You Sure?'),
            content: const Text(
                'This will be delete the file and all associated saved texts.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(curreuntContext);
                  deletSaveFileById(widget.fileId);
                  Navigator.pop(curreuntContext);
                  Navigator.pop(curreuntContext);
                  Navigator.pushReplacement(
                    curreuntContext,
                    MaterialPageRoute(
                      builder: (context) => const SavedTextFileListScreen(),
                    ),
                  );
                },
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(curreuntContext);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
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
                  _showAreYouSureDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Name'),
                onTap: () {
                  // Edit 기능 수행
                  _showNameInputDialog(); // BottomSheet 닫기
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
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.fileName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
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
            child: Text('저장된 데이터가 없습니다.'),
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
