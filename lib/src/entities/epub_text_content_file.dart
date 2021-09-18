import 'package:quiver/core.dart';

import 'epub_content_file.dart';
import 'epub_content_type.dart';

class EpubTextContentFile extends EpubContentFile {
  String? content;

  EpubTextContentFile({this.content, String? fileName, EpubContentType? contentType, String? contentMimeType})
      : super(contentMimeType: contentMimeType, contentType: contentType, fileName: fileName);

  @override
  int get hashCode => hash4(content, contentMimeType, contentType, fileName);

  @override
  bool operator ==(Object other) {
    if (other is! EpubTextContentFile) {
      return false;
    }

    return content == other.content && contentMimeType == other.contentMimeType && contentType == other.contentType && fileName == other.fileName;
  }
}
