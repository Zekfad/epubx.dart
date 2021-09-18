library epubreadertest;

import 'dart:math';

import 'package:repub/repub.dart';
import 'package:test/test.dart';

import '../../random_data_generator.dart';

Future<void> main() async {
  const int length = 10;
  final RandomString randomString = RandomString(Random(123788));
  final RandomDataGenerator generator = RandomDataGenerator(Random(123778), length);

  final EpubMetadata reference = generator.randomEpubMetadata();
  late EpubMetadata testMetadata;
  setUp(() async {
    testMetadata = EpubMetadata(
        contributors: List<EpubMetadataContributor>.from(reference.contributors),
        coverages: List<String>.from(reference.coverages),
        creators: List<EpubMetadataCreator>.from(reference.creators),
        dates: List<EpubMetadataDate>.from(reference.dates),
        description: reference.description,
        formats: List<String>.from(reference.formats),
        identifiers: List<EpubMetadataIdentifier>.from(reference.identifiers),
        languages: List<String>.from(reference.languages),
        metaItems: List<EpubMetadataMeta>.from(reference.metaItems),
        publishers: List<String>.from(reference.publishers),
        relations: List<String>.from(reference.relations),
        rights: List<String>.from(reference.rights),
        sources: List<String>.from(reference.sources),
        subjects: List<String>.from(reference.subjects),
        titles: List<String>.from(reference.titles),
        types: List<String>.from(reference.types));
  });

  group('EpubMetadata', () {
    group('.equals', () {
      test('is true for equivalent objects', () async {
        expect(testMetadata, equals(reference));
      });
      test('is false when Contributors changes', () async {
        testMetadata.contributors = <EpubMetadataContributor>[EpubMetadataContributor()];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Coverages changes', () async {
        testMetadata.coverages = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Creators changes', () async {
        testMetadata.creators = <EpubMetadataCreator>[EpubMetadataCreator()];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Dates changes', () async {
        testMetadata.dates = <EpubMetadataDate>[EpubMetadataDate()];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Description changes', () async {
        testMetadata.description = randomString.randomAlpha(length);
        expect(testMetadata, isNot(reference));
      });
      test('is false when Formats changes', () async {
        testMetadata.formats = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Identifiers changes', () async {
        testMetadata.identifiers = <EpubMetadataIdentifier>[EpubMetadataIdentifier()];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Languages changes', () async {
        testMetadata.languages = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when MetaItems changes', () async {
        testMetadata.metaItems = <EpubMetadataMeta>[EpubMetadataMeta()];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Publishers changes', () async {
        testMetadata.publishers = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Relations changes', () async {
        testMetadata.relations = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Rights changes', () async {
        testMetadata.rights = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Sources changes', () async {
        testMetadata.sources = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Subjects changes', () async {
        testMetadata.subjects = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Titles changes', () async {
        testMetadata.titles = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
      test('is false when Types changes', () async {
        testMetadata.types = <String>[randomString.randomAlpha(length)];
        expect(testMetadata, isNot(reference));
      });
    });

    group('.hashCode', () {
      test('is true for equivalent objects', () async {
        expect(testMetadata.hashCode, equals(reference.hashCode));
      });
      test('is false when Contributors changes', () async {
        testMetadata.contributors = <EpubMetadataContributor>[EpubMetadataContributor()];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Coverages changes', () async {
        testMetadata.coverages = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Creators changes', () async {
        testMetadata.creators = <EpubMetadataCreator>[EpubMetadataCreator()];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Dates changes', () async {
        testMetadata.dates = <EpubMetadataDate>[EpubMetadataDate()];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Description changes', () async {
        testMetadata.description = randomString.randomAlpha(length);
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Formats changes', () async {
        testMetadata.formats = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Identifiers changes', () async {
        testMetadata.identifiers = <EpubMetadataIdentifier>[EpubMetadataIdentifier()];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Languages changes', () async {
        testMetadata.languages = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when MetaItems changes', () async {
        testMetadata.metaItems = <EpubMetadataMeta>[EpubMetadataMeta()];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Publishers changes', () async {
        testMetadata.publishers = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Relations changes', () async {
        testMetadata.relations = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Rights changes', () async {
        testMetadata.rights = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Sources changes', () async {
        testMetadata.sources = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Subjects changes', () async {
        testMetadata.subjects = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Titles changes', () async {
        testMetadata.titles = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
      test('is false when Types changes', () async {
        testMetadata.types = <String>[randomString.randomAlpha(length)];
        expect(testMetadata.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
