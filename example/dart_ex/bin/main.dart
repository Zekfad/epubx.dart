// ignore_for_file: unused_local_variable

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:epubx/epubx.dart';

Future<void> main(List<String> args) async {
  //Get the epub into memory somehow
  const String fileName = "alicesAdventuresUnderGround.epub";
  final String fullPath = path.join(io.Directory.current.path, fileName);
  final io.File targetFile = io.File(fullPath);
  final List<int> bytes = await targetFile.readAsBytes();

  // Opens a book and reads all of its content into the memory
  final EpubBook epubBook = await readBook(bytes);

  // COMMON PROPERTIES

  // Book's title
  final String? title = epubBook.title;

  // Book's authors (comma separated list)
  final String? author = epubBook.author;

  // Book's authors (list of authors names)
  final List<String?>? authors = epubBook.authorList;

  // Book's cover image (null if there is no cover)
  final Image? coverImage = epubBook.coverImage;

  // CHAPTERS

  // Enumerating chapters
  epubBook.chapters?.forEach((EpubChapter chapter) {
    // Title of chapter
    final String? chapterTitle = chapter.title;

    // HTML content of current chapter
    final String? chapterHtmlContent = chapter.htmlContent;

    // Nested chapters
    final List<EpubChapter?>? subChapters = chapter.subChapters;
  });

  // CONTENT

  // Book's content (HTML files, stlylesheets, images, fonts, etc.)
  final EpubContent? bookContent = epubBook.content;

  // IMAGES

  // All images in the book (file name is the key)
  final Map<String, EpubByteContentFile>? images = bookContent?.images;

  final EpubByteContentFile? firstImage = images != null && images.isNotEmpty ? images.values.first : null;

  // Content type (e.g. EpubContentType.IMAGE_JPEG, EpubContentType.IMAGE_PNG)
  final EpubContentType? contentType = firstImage?.contentType;

  // MIME type (e.g. "image/jpeg", "image/png")
  final String? mimeContentType = firstImage?.contentMimeType;

  // HTML & CSS

  // All XHTML files in the book (file name is the key)
  final Map<String, EpubTextContentFile>? htmlFiles = bookContent?.html;

  // All CSS files in the book (file name is the key)
  final Map<String, EpubTextContentFile>? cssFiles = bookContent?.css;

  // Entire HTML content of the book
  if (htmlFiles != null) {
    for (final EpubTextContentFile htmlFile in htmlFiles.values) {
      final String? htmlContent = htmlFile.content;
    }
  }

  // All CSS content in the book
  if (cssFiles != null) {
    for (final EpubTextContentFile cssFile in cssFiles.values) {
      final String? cssContent = cssFile.content;
    }
  }

  // OTHER CONTENT

  // All fonts in the book (file name is the key)
  final Map<String, EpubByteContentFile>? fonts = bookContent?.fonts;

  // All files in the book (including HTML, CSS, images, fonts, and other types of files)
  final Map<String, EpubContentFile>? allFiles = bookContent?.allFiles;

  // ACCESSING RAW SCHEMA INFORMATION

  // EPUB OPF data
  final EpubPackage? package = epubBook.schema?.package;

  // Enumerating book's contributors
  if (package != null && package.metadata != null) {
    for (final EpubMetadataContributor contributor in package.metadata!.contributors) {
      final String? contributorName = contributor.contributor;
      final String? contributorRole = contributor.role;
    }
  }

  // EPUB NCX data
  final EpubNavigation? navigation = epubBook.schema?.navigation;

  // Enumerating NCX metadata
  if (navigation != null && navigation.head != null) {
    for (final EpubNavigationHeadMeta meta in navigation.head!.metadata) {
      final String? metadataItemName = meta.name;
      final String? metadataItemContent = meta.content;
    }
  }

  // Write the Book
  final List<int> written = writeBook(epubBook) ?? <int>[];
  // Read the book into a new object!
  final EpubBook newBook = await readBook(written);
}
