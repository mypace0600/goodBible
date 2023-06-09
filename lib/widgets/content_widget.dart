import 'package:flutter/material.dart';
import 'package:goodbible/models/save_text_model.dart';
import 'package:goodbible/repositories/save_text_crud_repository.dart';
import 'package:goodbible/services/api_service.dart';
import 'package:goodbible/utils/data.dart';

class ContentWidget extends StatefulWidget {
  final String book, text;
  final int chapter, verse, textFontButtonClicked;
  final String short;

  ContentWidget(
      {Key? key,
      required this.book,
      required this.chapter,
      required this.verse,
      required this.text,
      required this.textFontButtonClicked})
      : short = ApiService.getShortByBook(book),
        super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  bool isSelected = false;

  void saveTextToLocalStorage() async {
    var selectedText = SaveText(
      fileId: 1,
      book: widget.book,
      chapter: widget.chapter,
      verse: widget.verse,
      text: widget.text,
      savedTime: DataUtils.nowTime().toString(),
    );
    await SaveTextCRUDRepository.create(selectedText);
    update();
  }

  void update() => setState(() {});

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
                color: isSelected
                    ? const Color.fromRGBO(224, 224, 224, 0.9)
                    : Colors.transparent,
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
