import 'dart:convert' as convert;

import 'package:archive/archive.dart';

import 'entities/epub_book.dart';
import 'entities/epub_byte_content_file.dart';
import 'entities/epub_content_file.dart';
import 'entities/epub_text_content_file.dart';
import 'utils/zip_path_utils.dart';
import 'writers/epub_package_writer.dart';

// ignore_for_file: missing_whitespace_between_adjacent_strings
const String _containerFile = '<?xml version="1.0"?>'
  '<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">'
    '<rootfiles>'
      '<rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>'
    '</rootfiles>'
  '</container>';

// Creates a Zip Archive of an EpubBook
Archive _createArchive(EpubBook book) {
  final List<int> mimeType = convert.utf8.encode('application/epub+zip');
  final List<int> containerFile = convert.utf8.encode(_containerFile);


  final Archive archive = Archive()
    // Add simple metadata
    ..addFile(ArchiveFile.noCompress('metadata', mimeType.length, mimeType))
    // Add Container file
    ..addFile(ArchiveFile('META-INF/container.xml', containerFile.length, containerFile));

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
  final List<int> contentOpf = convert.utf8.encode(writeContent(book.schema!.package!));

  archive.addFile(ArchiveFile(combine(book.schema!.contentDirectoryPath, 'content.opf')!, contentOpf.length, contentOpf));

  return archive;
}

// Serializes the EpubBook into a byte array
List<int>? writeBook(EpubBook book) {
  final Archive archive = _createArchive(book);

  return ZipEncoder().encode(archive);
}
