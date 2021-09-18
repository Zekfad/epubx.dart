import 'dart:async';

import '../entities/epub_content_type.dart';
import 'epub_book_ref.dart';
import 'epub_content_file_ref.dart';

class EpubTextContentFileRef extends EpubContentFileRef {
  EpubTextContentFileRef({required EpubBookRef epubBookRef, String? fileName, EpubContentType? contentType, String? contentMimeType})
      : super(epubBookRef: epubBookRef, fileName: fileName, contentType: contentType, contentMimeType: contentMimeType);

  Future<String> readContentAsync() async => readContentAsText();
}
