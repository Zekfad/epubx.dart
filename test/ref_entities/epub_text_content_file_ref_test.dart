library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final Archive archive = Archive();
  final EpubBookRef epubRef = EpubBookRef(epubArchive: archive);

  final EpubTextContentFileRef reference = EpubTextContentFileRef(
    epubBookRef: epubRef,
    contentMimeType: 'application/test',
    contentType: EpubContentType.other,
    fileName: 'orthrosFile',
  );

  late EpubTextContentFileRef testFile;
  setUp(() async {
    final Archive archive2 = Archive();
    final EpubBookRef epubRef2 = EpubBookRef(epubArchive: archive2);

    testFile = EpubTextContentFileRef(
      epubBookRef: epubRef2,
      contentMimeType: 'application/test',
      contentType: EpubContentType.other,
      fileName: 'orthrosFile',
    );
  });

  group('EpubTextContentFile', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testFile, equals(reference));
      });

      test('is false when ContentMimeType changes', () async {
        testFile.contentMimeType = 'application/different';
        expect(testFile, isNot(reference));
      });

      test('is false when ContentType changes', () async {
        testFile.contentType = EpubContentType.css;
        expect(testFile, isNot(reference));
      });

      test('is false when FileName changes', () async {
        testFile.fileName = 'a_different_file_name.txt';
        expect(testFile, isNot(reference));
      });
    });
    group('.hashCode', () {
      test('is the same for equivalent content', () async {
        expect(testFile.hashCode, equals(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFile.contentMimeType = 'application/orthros';
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFile.contentType = EpubContentType.css;
        expect(testFile.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFile.fileName = 'a_different_file_name';
        expect(testFile.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
