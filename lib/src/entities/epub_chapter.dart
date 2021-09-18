import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubChapter {
  String? title;
  String? contentFileName;
  String? anchor;
  String? htmlContent;
  List<EpubChapter>? subChapters;

  EpubChapter({this.title, this.contentFileName, this.anchor, this.htmlContent, this.subChapters});

  @override
  int get hashCode {
    final List<int> objects = <int>[
      title.hashCode,
      contentFileName.hashCode,
      anchor.hashCode,
      htmlContent.hashCode,
      ...subChapters?.map((EpubChapter subChapter) => subChapter.hashCode) ?? <int>[0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubChapter) {
      return false;
    }
    return title == other.title &&
        contentFileName == other.contentFileName &&
        anchor == other.anchor &&
        htmlContent == other.htmlContent &&
        collections.listsEqual(subChapters, other.subChapters);
  }

  @override
  String toString() => 'Title: $title, Subchapter count: ${subChapters!.length}';
}
