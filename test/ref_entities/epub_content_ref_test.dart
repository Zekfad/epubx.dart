library epubreadertest;

import 'package:archive/archive.dart';
import 'package:repub/repub.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final EpubContentRef reference = EpubContentRef();

  late EpubContentRef testContent;
  late EpubTextContentFileRef textContentFile;
  late EpubByteContentFileRef byteContentFile;

  setUp(() async {
    final Archive archive = Archive();
    final EpubBookRef refBook = EpubBookRef(epubArchive: archive);

    testContent = EpubContentRef();

    textContentFile = EpubTextContentFileRef(
      epubBookRef: refBook,
      contentMimeType: 'application/text',
      contentType: EpubContentType.other,
      fileName: 'orthros.txt',
    );

    byteContentFile = EpubByteContentFileRef(
      epubBookRef: refBook,
      contentMimeType: 'application/orthros',
      contentType: EpubContentType.other,
      fileName: 'orthros.bin',
    );
  });

  group('EpubContentRef', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testContent, equals(reference));
      });

      test('is false when Html changes', () async {
        testContent.html['someKey'] = textContentFile;
        expect(testContent, isNot(reference));
      });

      test('is false when Css changes', () async {
        testContent.css['someKey'] = textContentFile;
        expect(testContent, isNot(reference));
      });

      test('is false when Images changes', () async {
        testContent.images['someKey'] = byteContentFile;
        expect(testContent, isNot(reference));
      });

      test('is false when Fonts changes', () async {
        testContent.fonts['someKey'] = byteContentFile;
        expect(testContent, isNot(reference));
      });

      test('is false when AllFiles changes', () async {
        testContent.allFiles['someKey'] = byteContentFile;
        expect(testContent, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testContent.hashCode, equals(reference.hashCode));
      });

      test('is false when Html changes', () async {
        testContent.html['someKey'] = textContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test('is false when Css changes', () async {
        testContent.css['someKey'] = textContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test('is false when Images changes', () async {
        testContent.images['someKey'] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test('is false when Fonts changes', () async {
        testContent.fonts['someKey'] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test('is false when AllFiles changes', () async {
        testContent.allFiles['someKey'] = byteContentFile;
        expect(testContent.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
