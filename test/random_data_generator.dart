import 'dart:math' show Random;

import 'package:epubx/epubx.dart';

class RandomString {
  final Random rng;

  RandomString(this.rng);

  static const int asciiStart = 33;
  static const int asciiEnd = 126;
  static const int numericStart = 48;
  static const int numericEnd = 57;
  static const int lowerAlphaStart = 97;
  static const int lowerAlphaEnd = 122;
  static const int upperAlphaStart = 65;
  static const int upperAlphaEnd = 90;

  /// Generates a random integer where [from] <= [to].
  int randomBetween(int from, int to) {
    if (from > to) {
      throw Exception('$from is not > $to');
    }
    return ((to - from) * rng.nextDouble()).toInt() + from;
  }

  /// Generates a random string of [length] with characters
  /// between ascii [from] to [to].
  /// Defaults to characters of ascii '!' to '~'.
  String randomString(int length, {int from = asciiStart, int to = asciiEnd}) =>
      String.fromCharCodes(List<int>.generate(length, (int index) => randomBetween(from, to)));

  /// Generates a random string of [length] with only numeric characters.
  String randomNumeric(int length) => randomString(length, from: numericStart, to: numericEnd);

  /// Generates a random string of [length] with only alpha characters.
  String randomAlpha(int length) {
    final int lowerAlphaLength = randomBetween(0, length);
    final int upperAlphaLength = length - lowerAlphaLength;
    final String lowerAlpha = randomString(lowerAlphaLength, from: lowerAlphaStart, to: lowerAlphaEnd);
    final String upperAlpha = randomString(upperAlphaLength, from: upperAlphaStart, to: upperAlphaEnd);
    return randomMerge(lowerAlpha, upperAlpha);
  }

  /// Generates a random string of [length] with alpha-numeric characters.
  String randomAlphaNumeric(int length) {
    final int alphaLength = randomBetween(0, length);
    final int numericLength = length - alphaLength;
    final String alpha = randomAlpha(alphaLength);
    final String numeric = randomNumeric(numericLength);
    return randomMerge(alpha, numeric);
  }

  /// Merge [a] with [b] and scramble characters.
  String randomMerge(String a, String b) {
    final List<int> mergedCodeUnits = List<int>.from('$a$b'.codeUnits)..shuffle(rng);
    return String.fromCharCodes(mergedCodeUnits);
  }
}

class RandomDataGenerator {
  final Random rng;
  late RandomString _randomString;
  final int _length;

  RandomDataGenerator(this.rng, this._length) {
    _randomString = RandomString(rng);
  }

  String randomString() => _randomString.randomAlphaNumeric(_length);

  EpubNavigationPoint randomEpubNavigationPoint([int depth = 0]) => EpubNavigationPoint(
        playOrder: randomString(),
        navigationLabels: <EpubNavigationLabel>[randomEpubNavigationLabel()],
        id: randomString(),
        content: randomEpubNavigationContent(),
        cssClass: randomString(),
        childNavigationPoints: depth > 0 ? <EpubNavigationPoint>[randomEpubNavigationPoint(depth - 1)] : <EpubNavigationPoint>[],
      );

  EpubNavigationContent randomEpubNavigationContent() => EpubNavigationContent(
        id: randomString(),
        source: randomString(),
      );

  EpubNavigationTarget randomEpubNavigationTarget() => EpubNavigationTarget(
        cssClass: randomString(),
        content: randomEpubNavigationContent(),
        id: randomString(),
        navigationLabels: <EpubNavigationLabel>[randomEpubNavigationLabel()],
        playOrder: randomString(),
        value: randomString(),
      );

  EpubNavigationLabel randomEpubNavigationLabel() => EpubNavigationLabel(
        text: randomString(),
      );

  EpubNavigationHead randomEpubNavigationHead() => EpubNavigationHead(
        metadata: <EpubNavigationHeadMeta>[randomNavigationHeadMeta()],
      );

  EpubNavigationHeadMeta randomNavigationHeadMeta() => EpubNavigationHeadMeta(
        content: randomString(),
        name: randomString(),
        scheme: randomString(),
      );

  EpubNavigationDocTitle randomNavigationDocTitle() => EpubNavigationDocTitle(
        titles: <String>[randomString()],
      );

  EpubNavigationDocAuthor randomNavigationDocAuthor() => EpubNavigationDocAuthor(
        authors: <String>[randomString()],
      );

  EpubPackage randomEpubPackage() => EpubPackage(
        guide: randomEpubGuide(),
        manifest: randomEpubManifest(),
        metadata: randomEpubMetadata(),
        spine: randomEpubSpine(),
        version: rng.nextBool() ? EpubVersion.epub2 : EpubVersion.epub3,
      );

  EpubSpine randomEpubSpine() {
    final EpubSpine reference = EpubSpine(
      items: <EpubSpineItemRef>[randomEpubSpineItemRef()],
      tableOfContents: _randomString.randomAlpha(_length),
    );
    return reference;
  }

  EpubSpineItemRef randomEpubSpineItemRef() => EpubSpineItemRef(idRef: _randomString.randomAlpha(_length), isLinear: true);

  EpubManifest randomEpubManifest() => EpubManifest(items: <EpubManifestItem>[randomEpubManifestItem()]);

  EpubManifestItem randomEpubManifestItem() => EpubManifestItem(
      fallback: _randomString.randomAlpha(_length),
      fallbackStyle: _randomString.randomAlpha(_length),
      href: _randomString.randomAlpha(_length),
      id: _randomString.randomAlpha(_length),
      mediaType: _randomString.randomAlpha(_length),
      requiredModules: _randomString.randomAlpha(_length),
      requiredNamespace: _randomString.randomAlpha(_length));

  EpubGuide randomEpubGuide() => EpubGuide(items: <EpubGuideReference>[randomEpubGuideReference()]);

  EpubGuideReference randomEpubGuideReference() => EpubGuideReference(
        href: _randomString.randomAlpha(_length),
        title: _randomString.randomAlpha(_length),
        type: _randomString.randomAlpha(_length),
      );

  EpubMetadata randomEpubMetadata() {
    final EpubMetadata reference = EpubMetadata(
      contributors: <EpubMetadataContributor>[randomEpubMetadataContributor()],
      coverages: <String>[_randomString.randomAlpha(_length)],
      creators: <EpubMetadataCreator>[randomEpubMetadataCreator()],
      dates: <EpubMetadataDate>[randomEpubMetadataDate()],
      description: _randomString.randomAlpha(_length),
      formats: <String>[_randomString.randomAlpha(_length)],
      identifiers: <EpubMetadataIdentifier>[randomEpubMetadataIdentifier()],
      languages: <String>[_randomString.randomAlpha(_length)],
      metaItems: <EpubMetadataMeta>[randomEpubMetadataMeta()],
      publishers: <String>[_randomString.randomAlpha(_length)],
      relations: <String>[_randomString.randomAlpha(_length)],
      rights: <String>[_randomString.randomAlpha(_length)],
      sources: <String>[_randomString.randomAlpha(_length)],
      subjects: <String>[_randomString.randomAlpha(_length)],
      titles: <String>[_randomString.randomAlpha(_length)],
      types: <String>[_randomString.randomAlpha(_length)],
    );

    return reference;
  }

  EpubMetadataMeta randomEpubMetadataMeta() => EpubMetadataMeta(
        content: _randomString.randomAlpha(_length),
        id: _randomString.randomAlpha(_length),
        name: _randomString.randomAlpha(_length),
        property: _randomString.randomAlpha(_length),
        refines: _randomString.randomAlpha(_length),
        scheme: _randomString.randomAlpha(_length),
      );

  EpubMetadataIdentifier randomEpubMetadataIdentifier() => EpubMetadataIdentifier(
        id: _randomString.randomAlpha(_length),
        identifier: _randomString.randomAlpha(_length),
        scheme: _randomString.randomAlpha(_length),
      );

  EpubMetadataDate randomEpubMetadataDate() => EpubMetadataDate(
        date: _randomString.randomAlpha(_length),
        event: _randomString.randomAlpha(_length),
      );

  EpubMetadataContributor randomEpubMetadataContributor() => EpubMetadataContributor(
        contributor: _randomString.randomAlpha(_length),
        fileAs: _randomString.randomAlpha(_length),
        role: _randomString.randomAlpha(_length),
      );

  EpubMetadataCreator randomEpubMetadataCreator() => EpubMetadataCreator(
        creator: _randomString.randomAlpha(_length),
        fileAs: _randomString.randomAlpha(_length),
        role: _randomString.randomAlpha(_length),
      );
}
