library epubreadertest;

import 'dart:math';

import 'package:repub/repub.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

Future<void> main() async {
  final RandomDataGenerator generator = RandomDataGenerator(Random(123778), 10);

  final EpubNavigationHead reference = generator.randomEpubNavigationHead();

  late EpubNavigationHead testGuideReference;
  setUp(() async {
    testGuideReference = EpubNavigationHead(
      metadata: List<EpubNavigationHeadMeta>.from(reference.metadata),
    );
  });

  group('EpubNavigationHead', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testGuideReference, equals(reference));
      });

      test('is false when Metadata changes', () async {
        testGuideReference.metadata.add(generator.randomNavigationHeadMeta());
        expect(testGuideReference, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testGuideReference.hashCode, equals(reference.hashCode));
      });

      test('is false when Metadata changes', () async {
        testGuideReference.metadata.add(generator.randomNavigationHeadMeta());
        expect(testGuideReference.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
