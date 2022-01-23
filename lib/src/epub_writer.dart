import 'dart:convert' as convert;

import 'package:archive/archive.dart';

import 'entities/epub_book.dart';
import 'entities/epub_byte_content_file.dart';
import 'entities/epub_content_file.dart';
import 'entities/epub_text_content_file.dart';
import 'utils/zip_path_utils.dart';
import 'writers/epub_package_writer.dart';

const String _containerFile =
    '<?xml version="1.0"?><container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container"><rootfiles><rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/></rootfiles></container>';

// Creates a Zip Archive of an EpubBook
Archive _createArchive(EpubBook book) {
  final Archive archive = Archive()

    // Add simple metadata
    ..addFile(ArchiveFile.noCompress('metadata', 20, convert.utf8.encode('application/epub+zip')))

    // Add Container file
    ..addFile(ArchiveFile('META-INF/container.xml', _containerFile.length, convert.utf8.encode(_containerFile)));

  // Add all content to the archive
  book.content!.allFiles.forEach((String name, EpubContentFile file) {
    List<int>? content;

    if (file is EpubByteContentFile) {
      content = file.content;
    } else if (file is EpubTextContentFile) {
      content = convert.utf8.encode(file.content!);
    }

    archive.addFile(ArchiveFile(combine(book.schema!.contentDirectoryPath, name)!, content!.length, content));
  });

  // Generate the content.opf file and add it to the Archive
  final String contentOpf = writeContent(book.schema!.package!);

  archive.addFile(ArchiveFile(combine(book.schema!.contentDirectoryPath, 'content.opf')!, contentOpf.length, convert.utf8.encode(contentOpf)));

  return archive;
}

// Serializes the EpubBook into a byte array
List<int>? writeBook(EpubBook book) {
  final Archive archive = _createArchive(book);

  return ZipEncoder().encode(archive);
}
