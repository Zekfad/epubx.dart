import 'package:image/image.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_chapter.dart';
import 'epub_content.dart';
import 'epub_schema.dart';

class EpubBook {
  String? title;
  String? author;
  List<String?>? authorList;
  EpubSchema? schema;
  EpubContent? content;
  Image? coverImage;
  List<EpubChapter>? chapters;

  EpubBook({this.title, this.author, this.authorList, this.schema, this.content, this.coverImage, this.chapters});

  @override
  int get hashCode {
    final List<int> objects = <int>[
      title.hashCode,
      author.hashCode,
      schema.hashCode,
      content.hashCode,
      ...coverImage?.getBytes().map((int byte) => byte.hashCode) ?? <int>[0],
      ...authorList?.map((String? author) => author.hashCode) ?? <int>[0],
      ...chapters?.map((EpubChapter chapter) => chapter.hashCode) ?? <int>[0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubBook) {
      return false;
    }

    return title == other.title &&
        author == other.author &&
        collections.listsEqual(authorList, other.authorList) &&
        schema == other.schema &&
        content == other.content &&
        collections.listsEqual(coverImage!.getBytes(), other.coverImage!.getBytes()) &&
        collections.listsEqual(chapters, other.chapters);
  }
}
