import 'package:flutter/material.dart';
import 'package:goodbible/models/save_text_model.dart';

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
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Move',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
