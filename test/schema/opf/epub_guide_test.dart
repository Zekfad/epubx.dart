library epubreadertest;

import 'dart:math' show Random;

import 'package:repub/repub.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

Future<void> main() async {
  final RandomDataGenerator generator = RandomDataGenerator(Random(123445), 10);

  final EpubGuide reference = generator.randomEpubGuide();

  late EpubGuide testGuide;
  setUp(() async {
    testGuide = EpubGuide(
      items: List<EpubGuideReference>.from(reference.items),
    );
  });

  group('EpubGuide', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testGuide, equals(reference));
      });
      test('is false when Items changes', () async {
        testGuide.items.add(generator.randomEpubGuideReference());
        expect(testGuide, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testGuide.hashCode, equals(reference.hashCode));
      });
      test('is false when Items changes', () async {
        testGuide.items.add(generator.randomEpubGuideReference());
        expect(testGuide.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
