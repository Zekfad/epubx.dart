import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_content_file.dart';
import 'epub_content_type.dart';

class EpubByteContentFile extends EpubContentFile {
  List<int>? content;

  EpubByteContentFile({this.content, String? fileName, EpubContentType? contentType, String? contentMimeType})
      : super(contentMimeType: contentMimeType, contentType: contentType, fileName: fileName);

  @override
  int get hashCode {
    final List<int> objects = <int>[
      contentMimeType.hashCode,
      contentType.hashCode,
      fileName.hashCode,
      ...content?.map((int content) => content.hashCode) ?? <int>[0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubByteContentFile) {
      return false;
    }
    return collections.listsEqual(content, other.content) &&
        contentMimeType == other.contentMimeType &&
        contentType == other.contentType &&
        fileName == other.fileName;
  }
}
