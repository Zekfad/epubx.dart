import 'dart:async';

import '../entities/epub_content_type.dart';
import 'epub_book_ref.dart';
import 'epub_content_file_ref.dart';

class EpubByteContentFileRef extends EpubContentFileRef {
  EpubByteContentFileRef({required EpubBookRef epubBookRef, String? fileName, EpubContentType? contentType, String? contentMimeType})
      : super(epubBookRef: epubBookRef, fileName: fileName, contentType: contentType, contentMimeType: contentMimeType);

  Future<List<int>> readContent() => readContentAsBytes();
}
