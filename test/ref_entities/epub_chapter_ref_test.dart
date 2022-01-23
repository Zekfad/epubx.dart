library epubreadertest;

import 'package:archive/archive.dart';
import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final Archive archive = Archive();
  final EpubBookRef bookRef = EpubBookRef(epubArchive: archive);
  final EpubTextContentFileRef contentFileRef = EpubTextContentFileRef(epubBookRef: bookRef);
  final EpubChapterRef reference = EpubChapterRef(
    epubTextContentFileRef: contentFileRef,
    anchor: 'anchor',
    contentFileName: 'orthros',
    subChapters: <EpubChapterRef>[],
    title: 'A New Look at Chapters',
  );

  late EpubBookRef bookRef2;
  late EpubChapterRef testChapterRef;
  setUp(() async {
    final Archive archive2 = Archive();
    bookRef2 = EpubBookRef(epubArchive: archive2);
    final EpubTextContentFileRef contentFileRef2 = EpubTextContentFileRef(epubBookRef: bookRef2);

    testChapterRef = EpubChapterRef(
      epubTextContentFileRef: contentFileRef2,
      anchor: 'anchor',
      contentFileName: 'orthros',
      subChapters: <EpubChapterRef>[],
      title: 'A New Look at Chapters',
    );
  });

  group('EpubChapterRef', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testChapterRef, equals(reference));
      });

      test('is false when Anchor changes', () async {
        testChapterRef.anchor = 'NotAnAnchor';
        expect(testChapterRef, isNot(reference));
      });

      test('is false when ContentFileName changes', () async {
        testChapterRef.contentFileName = 'NotOrthros';
        expect(testChapterRef, isNot(reference));
      });

      test('is false when SubChapters changes', () async {
        final EpubTextContentFileRef subchapterContentFileRef = EpubTextContentFileRef(epubBookRef: bookRef2);
        final EpubChapterRef chapter = EpubChapterRef(
          epubTextContentFileRef: subchapterContentFileRef,
          title: 'A Brave new Epub',
          contentFileName: 'orthros.txt',
        );
        testChapterRef.subChapters = <EpubChapterRef>[chapter];
        expect(testChapterRef, isNot(reference));
      });

      test('is false when Title changes', () async {
        testChapterRef.title = 'A Boring Old World';
        expect(testChapterRef, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testChapterRef.hashCode, equals(reference.hashCode));
      });

      test('is true for equivalent objects', () async {
        expect(testChapterRef.hashCode, equals(reference.hashCode));
      });

      test('is false when Anchor changes', () async {
        testChapterRef.anchor = 'NotAnAnchor';
        expect(testChapterRef.hashCode, isNot(reference.hashCode));
      });

      test('is false when ContentFileName changes', () async {
        testChapterRef.contentFileName = 'NotOrthros';
        expect(testChapterRef.hashCode, isNot(reference.hashCode));
      });

      test('is false when SubChapters changes', () async {
        final EpubTextContentFileRef subchapterContentFileRef = EpubTextContentFileRef(epubBookRef: bookRef2);
        final EpubChapterRef chapter = EpubChapterRef(
          epubTextContentFileRef: subchapterContentFileRef,
          title: 'A Brave new Epub',
          contentFileName: 'orthros.txt',
        );
        testChapterRef.subChapters = <EpubChapterRef>[chapter];
        expect(testChapterRef, isNot(reference));
      });

      test('is false when Title changes', () async {
        testChapterRef.title = 'A Boring Old World';
        expect(testChapterRef.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
