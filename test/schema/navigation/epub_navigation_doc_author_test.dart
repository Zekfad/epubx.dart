library epubreadertest;

import 'dart:math';

import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

Future<void> main() async {
  final RandomDataGenerator generator = RandomDataGenerator(Random(7898), 10);
  final EpubNavigationDocAuthor reference = generator.randomNavigationDocAuthor();

  late EpubNavigationDocAuthor testNavigationDocAuthor;
  setUp(() async {
    testNavigationDocAuthor = EpubNavigationDocAuthor(
      authors: List<String>.from(reference.authors),
    );
  });

  group('EpubNavigationDocAuthor', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testNavigationDocAuthor, equals(reference));
      });

      test('is false when Authors changes', () async {
        testNavigationDocAuthor.authors.add(generator.randomString());
        expect(testNavigationDocAuthor, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testNavigationDocAuthor.hashCode, equals(reference.hashCode));
      });

      test('is false when Authors changes', () async {
        testNavigationDocAuthor.authors.add(generator.randomString());
        expect(testNavigationDocAuthor.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
