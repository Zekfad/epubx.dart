import 'dart:async';

import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_text_content_file_ref.dart';

class EpubChapterRef {
  EpubTextContentFileRef? epubTextContentFileRef;
  String? title;
  String? contentFileName;
  String? anchor;
  List<EpubChapterRef>? subChapters;

  EpubChapterRef({this.epubTextContentFileRef, this.title, this.contentFileName, this.anchor, this.subChapters});

  @override
  int get hashCode {
    final List<int> objects = <int>[
      title.hashCode,
      contentFileName.hashCode,
      anchor.hashCode,
      epubTextContentFileRef.hashCode,
      ...subChapters?.map((EpubChapterRef subChapter) => subChapter.hashCode) ?? <int>[0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubChapterRef) {
      return false;
    }
    return title == other.title &&
        contentFileName == other.contentFileName &&
        anchor == other.anchor &&
        epubTextContentFileRef == other.epubTextContentFileRef &&
        collections.listsEqual(subChapters, other.subChapters);
  }

  Future<String> readHtmlContent() async => epubTextContentFileRef!.readContentAsText();

  @override
  String toString() => 'Title: $title, Subchapter count: ${subChapters!.length}';
}
