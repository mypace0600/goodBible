import 'package:flutter/material.dart';
import 'package:goodbible/models/save_file_model.dart';
import 'package:goodbible/models/save_text_model.dart';
import 'package:goodbible/repositories/save_file_crud_repository.dart';
import 'package:goodbible/repositories/save_text_crud_repository.dart';
import 'package:goodbible/screens/saved_text_file_list_screen.dart';

class BottomSheetWidget extends StatefulWidget {
  final List<SaveText> selectedItems;
  final Function deleteSavedData;
  bool isSelectMode;

  BottomSheetWidget({
    Key? key,
    required this.selectedItems,
    required this.deleteSavedData,
    required this.isSelectMode,
  }) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  late Future<List<SaveFile>> fileList;

  @override
  void initState() {
    super.initState();
    fileList = loadSaveFileList();
    setState(() {});
  }

  Future<List<SaveFile>> loadSaveFileList() async {
    List<SaveFile> result = await SaveFileCRUDRepository.getList();
    return result;
  }

  Future<void> moveSaveTextToAnotherFile(
      List<SaveText> selectedItems, int newFileId) async {
    for (SaveText text in selectedItems) {
      await SaveTextCRUDRepository.updateSaveTextById(
        text.id!,
        newFileId,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.selectedItems.isEmpty
                  ? null
                  : () {
                      for (SaveText item in widget.selectedItems) {
                        widget.deleteSavedData(item.id!);
                      }
                      setState(() {
                        widget.selectedItems.clear();
                        widget.isSelectMode = false;
                      });
                    },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 20,
                  color:
                      widget.selectedItems.isEmpty ? Colors.grey : Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: widget.selectedItems.isEmpty
                  ? null
                  : () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Move to'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: FutureBuilder<List<SaveFile>>(
                                  future: fileList,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<SaveFile>> snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            title: Text(snapshot
                                                .data![index].fileName!),
                                            onTap: () {
                                              moveSaveTextToAnotherFile(
                                                  widget.selectedItems,
                                                  snapshot
                                                      .data![index].fileId!);
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SavedTextFileListScreen(),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('오류 : ${snapshot.error}');
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            );
                          });
                    },
              child: Text(
                'Move',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color:
                      widget.selectedItems.isEmpty ? Colors.grey : Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
