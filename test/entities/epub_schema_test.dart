library epubreadertest;

import 'package:repub/repub.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final EpubSchema reference =
      EpubSchema(package: EpubPackage(version: EpubVersion.epub2), navigation: EpubNavigation(), contentDirectoryPath: 'some/random/path');

  late EpubSchema testSchema;
  setUp(() async {
    testSchema = EpubSchema(package: EpubPackage(version: EpubVersion.epub2), navigation: EpubNavigation(), contentDirectoryPath: 'some/random/path');
  });

  group('EpubSchema', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testSchema, equals(reference));
      });

      test('is false when Package changes', () async {
        final EpubPackage package = EpubPackage(guide: EpubGuide(), version: EpubVersion.epub3);

        testSchema.package = package;
        expect(testSchema, isNot(reference));
      });

      test('is false when Navigation changes', () async {
        testSchema.navigation = EpubNavigation(
          docTitle: EpubNavigationDocTitle(),
          docAuthors: <EpubNavigationDocAuthor>[EpubNavigationDocAuthor()],
        );

        expect(testSchema, isNot(reference));
      });

      test('is false when ContentDirectoryPath changes', () async {
        testSchema.contentDirectoryPath = 'some/other/random/path/to/dev/null';
        expect(testSchema, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testSchema.hashCode, equals(reference.hashCode));
      });

      test('is false when Package changes', () async {
        final EpubPackage package = EpubPackage(
          guide: EpubGuide(),
        )..version = EpubVersion.epub3;

        testSchema.package = package;
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test('is false when Navigation changes', () async {
        testSchema.navigation = EpubNavigation(
          docTitle: EpubNavigationDocTitle(),
          docAuthors: <EpubNavigationDocAuthor>[EpubNavigationDocAuthor()],
        );

        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test('is false when ContentDirectoryPath changes', () async {
        testSchema.contentDirectoryPath = 'some/other/random/path/to/dev/null';
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
