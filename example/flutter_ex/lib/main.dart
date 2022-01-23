import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;
import 'package:epubx/epubx.dart' as epub;

void main() => runApp(const EpubWidget());

class EpubWidget extends StatefulWidget {
  const EpubWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EpubState();
}

class EpubState extends State<EpubWidget> {
  Future<epub.EpubBookRef>? book;

  final TextEditingController _urlController = TextEditingController();

  void fetchBookButton() {
    setState(() {
      book = fetchBook(_urlController.text);
    });
  }

  void fetchBookPresets(String link) {
    setState(() {
      book = fetchBook(link);
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fetch Epub Example",
      home: Material(
          child: Container(
              padding: const EdgeInsets.all(30),
              color: Colors.white,
              child: Center(
                  child: ListView(children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 70)),
                const Text(
                  'Epub Inspector',
                  style: TextStyle(fontSize: 25),
                ),
                const Padding(padding: EdgeInsets.only(top: 50)),
                const Text(
                  'Enter the Url of an Epub to view some of it\'s metadata.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Enter Url",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  validator: (String val) {
                    if (val.isEmpty) {
                      return "Url cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    textStyle: const TextStyle(color: Colors.white),
                    primary: Colors.blue,
                  ),
                  onPressed: fetchBookButton,
                  child: const Text("Inspect Book"),
                ),
                const Padding(padding: EdgeInsets.only(top: 25)),
                Center(
                  child: FutureBuilder<epub.EpubBookRef>(
                    future: book,
                    builder: (BuildContext context, AsyncSnapshot<epub.EpubBookRef> snapshot) {
                      if (snapshot.hasData) {
                        return Material(color: Colors.white, child: buildEpubWidget(snapshot.data));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default, show a loading spinner
                      // return CircularProgressIndicator();

                      // By default, show just empty.
                      return Container();
                    },
                  ),
                ),
              ])))));

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Future<epub.EpubBookRef>>('book', book));
  }
}

Widget buildEpubWidget(epub.EpubBookRef book) {
  final Future<List<epub.EpubChapterRef>> chapters = book.getChapters();
  final Future<image.Image> cover = book.readCover();
  return Column(
    children: <Widget>[
      const Text(
        "Title",
        style: TextStyle(fontSize: 20),
      ),
      Text(
        book.title,
        style: const TextStyle(fontSize: 15),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      const Text(
        "Author",
        style: TextStyle(fontSize: 20),
      ),
      Text(
        book.author,
        style: const TextStyle(fontSize: 15),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      FutureBuilder<List<epub.EpubChapterRef>>(
          future: chapters,
          builder: (BuildContext context, AsyncSnapshot<List<epub.EpubChapterRef>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  const Text("Chapters", style: TextStyle(fontSize: 20)),
                  Text(
                    snapshot.data.length.toString(),
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Container();
          }),
      const Padding(
        padding: EdgeInsets.only(top: 15),
      ),
      FutureBuilder<epub.Image?>(
        future: cover,
        builder: (BuildContext context, AsyncSnapshot<image.Image> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                const Text("Cover", style: TextStyle(fontSize: 20)),
                Image.memory(image.encodePng(snapshot.data)),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Container();
        },
      ),
    ],
  );
}

// Needs a url to a valid url to an epub such as
// https://www.gutenberg.org/ebooks/11.epub.images
// or
// https://www.gutenberg.org/ebooks/19002.epub.images
Future<epub.EpubBookRef> fetchBook(String url) async {
  // Hard coded to Alice Adventures In Wonderland in Project Gutenberg
  final http.Response response = await http.get(Uri.http('www.gutenberg.org', 'ebooks/11.epub.images'));

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the EPUB
    return epub.openBook(response.bodyBytes);
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load epub');
  }
}
