library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final Archive archive = Archive();
  final EpubBookRef ref = EpubBookRef(epubArchive: archive);

  final EpubByteContentFileRef reference = EpubByteContentFileRef(
    epubBookRef: ref,
    contentMimeType: 'application/test',
    contentType: EpubContentType.other,
    fileName: 'orthrosFile',
  );

  late EpubByteContentFileRef testFileRef;

  setUp(() async {
    final Archive archive2 = Archive();
    final EpubBookRef ref2 = EpubBookRef(epubArchive: archive2);

    testFileRef = EpubByteContentFileRef(
      epubBookRef: ref2,
      contentMimeType: 'application/test',
      contentType: EpubContentType.other,
      fileName: 'orthrosFile',
    );
  });

  group('EpubByteContentFileRef', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testFileRef, equals(reference));
      });

      test('is false when ContentMimeType changes', () async {
        testFileRef.contentMimeType = 'application/different';
        expect(testFileRef, isNot(reference));
      });

      test('is false when ContentType changes', () async {
        testFileRef.contentType = EpubContentType.css;
        expect(testFileRef, isNot(reference));
      });

      test('is false when FileName changes', () async {
        testFileRef.fileName = 'a_different_file_name.txt';
        expect(testFileRef, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is the same for equivalent content', () async {
        expect(testFileRef.hashCode, equals(reference.hashCode));
      });

      test('changes when ContentMimeType changes', () async {
        testFileRef.contentMimeType = 'application/orthros';
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when ContentType changes', () async {
        testFileRef.contentType = EpubContentType.css;
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });

      test('changes when FileName changes', () async {
        testFileRef.fileName = 'a_different_file_name';
        expect(testFileRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
