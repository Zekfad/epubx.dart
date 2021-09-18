import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:repub/repub.dart' as epub;

Future<void> main() async {
  querySelector('#output')!.text = 'Your Dart app is running.';

  final http.Response epubRes = await http.get(Uri(path: './alicesAdventuresUnderGround.epub'));
  if (epubRes.statusCode == 200) {
    final epub.EpubBookRef book = await epub.openBook(epubRes.bodyBytes);
    querySelector('#title')!.text = book.title;
    querySelector('#author')!.text = book.author;
    final List<epub.EpubChapterRef> chapters = await book.getChapters();
    querySelector('#nchapters')!.text = chapters.length.toString();
    querySelectorAll('h2').style.visibility = 'visible';
  }
}
