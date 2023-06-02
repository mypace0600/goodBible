import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodbible/models/save_model.dart';
import 'package:goodbible/services/api_service.dart';
import 'package:goodbible/utils/data.dart';

class ContentWidget extends StatefulWidget {
  final String book, text;
  final int chapter, verse, textFontButtonClicked;
  final String short;

  ContentWidget({
    Key? key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
    required this.textFontButtonClicked
  })  : short = ApiService.getShortByBook(book),
        super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  bool isSelected = false;

  void saveTextToLocalStorage(){
    SaveText(
      id: DataUtils.makeUUID(),
      fileName: 'recent',
      book: widget.book,
      chapter: widget.chapter,
      vere: widget.verse,
      text: widget.text,
      savedTime: DataUtils.nowTime(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                isSelected = true;
              });
              saveTextToLocalStorage();
            },
            onLongPressEnd: (_) {
              setState(() {
                isSelected = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
              ),
              child: Text(
                ':${widget.verse} ${widget.text}',
                softWrap: true,
                style: TextStyle(
    fontSize: widget.textFontButtonClicked == 0
        ? 15.0
        : widget.textFontButtonClicked == 1
            ? 20.0
            : 25.0,
  ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
