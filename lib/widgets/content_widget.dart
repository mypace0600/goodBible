import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodbible/services/api_service.dart';

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

  Future<void> saveTextAddressToLocalStorage(
      String book, int chapter, int verse, String text) async {
    String address = '${widget.short} ${chapter + 1}:$verse';
    print(address);
    const storage = FlutterSecureStorage();
    await storage.write(key: address, value: text);
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
              saveTextAddressToLocalStorage(
                  widget.book, widget.chapter, widget.verse, widget.text);
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
        ? 12.0
        : widget.textFontButtonClicked == 1
            ? 16.0
            : 20.0,
  ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
