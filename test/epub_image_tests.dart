library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:repub/repub.dart';
import 'package:test/test.dart';

Future<void> main() async {
  const String fileName = 'alicesAdventuresUnderGround.epub';
  final String fullPath = path.join(io.Directory.current.path, 'test', 'res', fileName);
  final io.File targetFile = io.File(fullPath);
  if (targetFile.existsSync()) {
    throw Exception('Specified epub file not found: $fullPath');
  }
  final List<int> bytes = await targetFile.readAsBytes();

  test('Test Epub Image', () async {
    final EpubBook epubRef = await readBook(bytes);

    expect(epubRef.coverImage, isNotNull);

    expect(581, epubRef.coverImage!.width);
    expect(1034, epubRef.coverImage!.height);
  });

  test('Test Epub Ref Image', () async {
    final EpubBookRef epubRef = await openBook(bytes);

    final Image? coverImage = await epubRef.readCover();

    expect(coverImage, isNotNull);

    expect(581, coverImage!.width);
    expect(1034, coverImage.height);
  });
}
