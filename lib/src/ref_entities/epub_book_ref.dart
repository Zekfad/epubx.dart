import 'dart:async';

import 'package:archive/archive.dart';
import 'package:image/image.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import '../entities/epub_schema.dart';
import '../readers/book_cover_reader.dart';
import '../readers/chapter_reader.dart' as chapter_reader;
import 'epub_chapter_ref.dart';
import 'epub_content_ref.dart';

class EpubBookRef {
  Archive? epubArchive;

  String? title;
  String? author;
  List<String?>? authorList;
  EpubSchema? schema;
  EpubContentRef? content;

  EpubBookRef({this.epubArchive, this.title, this.author, this.authorList, this.schema, this.content});

  @override
  int get hashCode {
    final List<int> objects = <int>[
      title.hashCode,
      author.hashCode,
      schema.hashCode,
      content.hashCode,
      ...authorList?.map((String? author) => author.hashCode) ?? <int>[0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubBookRef) {
      return false;
    }

    return title == other.title &&
        author == other.author &&
        schema == other.schema &&
        content == other.content &&
        collections.listsEqual(authorList, other.authorList);
  }

  Future<List<EpubChapterRef>> getChapters() async => chapter_reader.getChapters(this);

  Future<Image?> readCover() async => readBookCover(this);
}
