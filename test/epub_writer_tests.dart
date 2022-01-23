library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:repub/repub.dart';
import 'package:test/test.dart';

Future<void> main() async {
  const String fileName = 'alicesAdventuresUnderGround.epub';
  final String fullPath = path.join(io.Directory.current.path, 'test', 'res', fileName);
  final io.File targetFile = io.File(fullPath);
  if (!targetFile.existsSync()) {
    throw Exception('Specified epub file not found: $fullPath');
  }

  final List<int> bytes = await targetFile.readAsBytes();

  test('Book Round Trip', () async {
    final EpubBook book = await readBook(bytes);

    final List<int>? written = writeBook(book);
    final EpubBook bookRoundTrip = await readBook(written!);

    expect(bookRoundTrip, equals(book));
  });
}
