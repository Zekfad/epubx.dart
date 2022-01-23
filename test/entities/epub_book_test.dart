library epubreadertest;

import 'package:repub/repub.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final EpubBook reference = EpubBook(
      author: 'orthros',
      authorList: <String>['orthros'],
      chapters: <EpubChapter>[EpubChapter()],
      content: EpubContent(),
      coverImage: Image(100, 100),
      schema: EpubSchema(),
      title: 'A Dissertation on Epubs');

  late EpubBook testBook;
  setUp(() async {
    testBook = EpubBook(
        author: 'orthros',
        authorList: <String>['orthros'],
        chapters: <EpubChapter>[EpubChapter()],
        content: EpubContent(),
        coverImage: Image(100, 100),
        schema: EpubSchema(),
        title: 'A Dissertation on Epubs');
  });

  group('EpubBook', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testBook, equals(reference));
      });

      test('is false when Content changes', () async {
        final EpubTextContentFile file = EpubTextContentFile(
          content: 'Hello',
          contentMimeType: 'application/txt',
          contentType: EpubContentType.other,
          fileName: 'orthros.txt',
        );

        final EpubContent content = EpubContent(allFiles: <String, EpubTextContentFile>{'hello': file});

        testBook.content = content;

        expect(testBook, isNot(reference));
      });

      test('is false when Author changes', () async {
        testBook.author = 'NotOrthros';
        expect(testBook, isNot(reference));
      });

      test('is false when AuthorList changes', () async {
        testBook.authorList = <String>['NotOrthros'];
        expect(testBook, isNot(reference));
      });

      test('is false when Chapters changes', () async {
        final EpubChapter chapter = EpubChapter(title: 'A Brave new Epub', contentFileName: 'orthros.txt');

        testBook.chapters = <EpubChapter>[chapter];
        expect(testBook, isNot(reference));
      });

      test('is false when CoverImage changes', () async {
        testBook.coverImage = Image(200, 200);
        expect(testBook, isNot(reference));
      });

      test('is false when Schema changes', () async {
        final EpubSchema schema = EpubSchema(contentDirectoryPath: 'some/random/path');

        testBook.schema = schema;
        expect(testBook, isNot(reference));
      });

      test('is false when Title changes', () async {
        testBook.title = 'The Philosophy of Epubs';
        expect(testBook, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testBook.hashCode, equals(reference.hashCode));
      });

      test('is false when Content changes', () async {
        final EpubTextContentFile file = EpubTextContentFile(
          content: 'Hello',
          contentMimeType: 'application/txt',
          contentType: EpubContentType.other,
          fileName: 'orthros.txt',
        );

        final EpubContent content = EpubContent(allFiles: <String, EpubTextContentFile>{'hello': file});

        testBook.content = content;

        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test('is false when Author changes', () async {
        testBook.author = 'NotOrthros';
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test('is false when AuthorList changes', () async {
        testBook.authorList = <String>['NotOrthros'];
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test('is false when Chapters changes', () async {
        final EpubChapter chapter = EpubChapter(title: 'A Brave new Epub', contentFileName: 'orthros.txt');
        testBook.chapters = <EpubChapter>[chapter];
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test('is false when CoverImage changes', () async {
        testBook.coverImage = Image(200, 200);
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test('is false when Schema changes', () async {
        final EpubSchema schema = EpubSchema(contentDirectoryPath: 'some/random/path');
        testBook.schema = schema;
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test('is false when Title changes', () async {
        testBook.title = 'The Philosophy of Epubs';
        expect(testBook.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
