library epubreadertest;

import 'package:archive/archive.dart';
import 'package:repub/repub.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final Archive archive = Archive();
  final EpubBookRef reference =
      EpubBookRef(epubArchive: archive, author: 'orthros', authorList: <String>['orthros'], schema: EpubSchema(), title: 'A Dissertation on Epubs');

  late EpubBookRef testBookRef;
  setUp(() async {
    testBookRef = EpubBookRef(epubArchive: archive, author: 'orthros', authorList: <String>['orthros'], schema: EpubSchema(), title: 'A Dissertation on Epubs');
  });

  group('EpubBookRef', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testBookRef, equals(reference));
      });

      test('is false when Content changes', () async {
        final EpubTextContentFileRef file = EpubTextContentFileRef(
          epubBookRef: testBookRef,
          contentMimeType: 'application/txt',
          contentType: EpubContentType.other,
          fileName: 'orthros.txt',
        );

        final EpubContentRef content = EpubContentRef(allFiles: <String, EpubTextContentFileRef>{'hello': file});

        testBookRef.content = content;

        expect(testBookRef, isNot(reference));
      });

      test('is false when Author changes', () async {
        testBookRef.author = 'NotOrthros';
        expect(testBookRef, isNot(reference));
      });

      test('is false when AuthorList changes', () async {
        testBookRef.authorList = <String>['NotOrthros'];
        expect(testBookRef, isNot(reference));
      });

      test('is false when Schema changes', () async {
        final EpubSchema schema = EpubSchema(contentDirectoryPath: 'some/random/path');

        testBookRef.schema = schema;
        expect(testBookRef, isNot(reference));
      });

      test('is false when Title changes', () async {
        testBookRef.title = 'The Philosophy of Epubs';
        expect(testBookRef, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testBookRef.hashCode, equals(reference.hashCode));
      });

      test('is false when Content changes', () async {
        final EpubTextContentFileRef file = EpubTextContentFileRef(
          epubBookRef: testBookRef,
          contentMimeType: 'application/txt',
          contentType: EpubContentType.other,
          fileName: 'orthros.txt',
        );

        final EpubContentRef content = EpubContentRef(allFiles: <String, EpubTextContentFileRef>{'hello': file});

        testBookRef.content = content;

        expect(testBookRef, isNot(reference));
      });

      test('is false when Author changes', () async {
        testBookRef.author = 'NotOrthros';
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });

      test('is false when AuthorList changes', () async {
        testBookRef.authorList = <String>['NotOrthros'];
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });
      test('is false when Schema changes', () async {
        final EpubSchema schema = EpubSchema(contentDirectoryPath: 'some/random/path');

        testBookRef.schema = schema;
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });

      test('is false when Title changes', () async {
        testBookRef.title = 'The Philosophy of Epubs';
        expect(testBookRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
