import 'dart:async';

import 'package:archive/archive.dart';

import 'entities/epub_book.dart';
import 'entities/epub_byte_content_file.dart';
import 'entities/epub_chapter.dart';
import 'entities/epub_content.dart';
import 'entities/epub_content_file.dart';
import 'entities/epub_schema.dart';
import 'entities/epub_text_content_file.dart';
import 'readers/content_reader.dart';
import 'readers/schema_reader.dart';
import 'ref_entities/epub_book_ref.dart';
import 'ref_entities/epub_byte_content_file_ref.dart';
import 'ref_entities/epub_chapter_ref.dart';
import 'ref_entities/epub_content_file_ref.dart';
import 'ref_entities/epub_content_ref.dart';
import 'ref_entities/epub_text_content_file_ref.dart';
import 'schema/opf/epub_metadata_creator.dart';

/// Opens the book asynchronously without reading its content. Holds the handle to the EPUB file.
Future<EpubBookRef> openBook(FutureOr<List<int>> bytes) async {
  List<int> loadedBytes;
  if (bytes is Future) {
    loadedBytes = await bytes;
  } else {
    loadedBytes = bytes;
  }

  final Archive epubArchive = ZipDecoder().decodeBytes(loadedBytes);

  final EpubSchema schema = await readSchema(epubArchive);
  final String title = schema.package!.metadata!.titles.firstWhere((String name) => true, orElse: () => '');
  final List<String?> authorList = schema.package!.metadata!.creators.map((EpubMetadataCreator creator) => creator.creator).toList();
  final String author = authorList.join(', ');
  final EpubBookRef bookRef = EpubBookRef(
    epubArchive: epubArchive,
    schema: schema,
    title: title,
    authorList: authorList,
    author: author,
  );
  bookRef.content = parseContentMap(bookRef);
  return bookRef;
}

/// Opens the book asynchronously and reads all of its content into the memory. Does not hold the handle to the EPUB file.
Future<EpubBook> readBook(FutureOr<List<int>> bytes) async {
  List<int> loadedBytes;
  if (bytes is Future) {
    loadedBytes = await bytes;
  } else {
    loadedBytes = bytes;
  }

  final EpubBookRef epubBookRef = await openBook(loadedBytes);
  return EpubBook(
    schema: epubBookRef.schema,
    title: epubBookRef.title,
    authorList: epubBookRef.authorList,
    author: epubBookRef.author,
    content: await readContent(epubBookRef.content!),
    coverImage: await epubBookRef.readCover(),
    chapters: await readChapters(await epubBookRef.getChapters()),
  );
}

Future<EpubContent> readContent(EpubContentRef contentRef) async {
  final EpubContent result = EpubContent(
    html: await readTextContentFiles(contentRef.html),
    css: await readTextContentFiles(contentRef.css),
    images: await readByteContentFiles(contentRef.images),
    fonts: await readByteContentFiles(contentRef.fonts),
    allFiles: <String, EpubContentFile>{},
  );

  result
    ..html.forEach((String key, EpubTextContentFile value) {
      result.allFiles[key] = value;
    })
    ..css.forEach((String key, EpubTextContentFile value) {
      result.allFiles[key] = value;
    });

  result.images.forEach((String key, EpubByteContentFile value) {
    result.allFiles[key] = value;
  });
  result.fonts.forEach((String key, EpubByteContentFile value) {
    result.allFiles[key] = value;
  });

  await Future.forEach(contentRef.allFiles.keys, (String key) async {
    if (!result.allFiles.containsKey(key)) {
      result.allFiles[key] = await readByteContentFile(contentRef.allFiles[key]!);
    }
  });

  return result;
}

Future<Map<String, EpubTextContentFile>> readTextContentFiles(Map<String, EpubTextContentFileRef> textContentFileRefs) async {
  final Map<String, EpubTextContentFile> result = <String, EpubTextContentFile>{};

  await Future.forEach(textContentFileRefs.keys, (String key) async {
    final EpubContentFileRef value = textContentFileRefs[key]!;
    final EpubTextContentFile textContentFile = EpubTextContentFile(
      fileName: value.fileName,
      contentType: value.contentType,
      contentMimeType: value.contentMimeType,
      content: await value.readContentAsText(),
    );
    result[key] = textContentFile;
  });
  return result;
}

Future<Map<String, EpubByteContentFile>> readByteContentFiles(Map<String, EpubByteContentFileRef> byteContentFileRefs) async {
  final Map<String, EpubByteContentFile> result = <String, EpubByteContentFile>{};
  await Future.forEach(byteContentFileRefs.keys, (String key) async {
    result[key] = await readByteContentFile(byteContentFileRefs[key]!);
  });
  return result;
}

Future<EpubByteContentFile> readByteContentFile(EpubContentFileRef contentFileRef) async {
  final EpubByteContentFile result = EpubByteContentFile(
    fileName: contentFileRef.fileName,
    contentType: contentFileRef.contentType,
    contentMimeType: contentFileRef.contentMimeType,
    content: await contentFileRef.readContentAsBytes(),
  );

  return result;
}

Future<List<EpubChapter>> readChapters(List<EpubChapterRef> chapterRefs) async {
  final List<EpubChapter> result = <EpubChapter>[];
  await Future.forEach(chapterRefs, (EpubChapterRef chapterRef) async {
    final EpubChapter chapter = EpubChapter(
      title: chapterRef.title,
      contentFileName: chapterRef.contentFileName,
      anchor: chapterRef.anchor,
      htmlContent: await chapterRef.readHtmlContent(),
      subChapters: await readChapters(chapterRef.subChapters!),
    );
    result.add(chapter);
  });
  return result;
}
