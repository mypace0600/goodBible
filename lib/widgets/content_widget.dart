import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodbible/services/api_service.dart';

class ContentWidget extends StatelessWidget {
  final String book, text;
  final int chapter, verse;
  final String short;

  ContentWidget({
    Key? key,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  })  : short = ApiService.getShortByBook(book),
        super(key: key);

  Future<void> saveTextAddressToLocalStorage(
      String book, int chapter, int verse, String text) async {
    String address = '$short ${chapter + 1}:$verse';
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
              saveTextAddressToLocalStorage(book, chapter, verse, text);
            },
            child: Text(
              ':$verse $text',
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
