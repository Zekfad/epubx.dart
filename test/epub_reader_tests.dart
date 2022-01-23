library epubreadertest;

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:repub/repub.dart';
import 'package:test/test.dart';

Future<void> main() async {
  const String fileName = 'hittelOnGoldMines.epub';
  final String fullPath = path.join(io.Directory.current.path, 'test', 'res', fileName);
  final io.File targetFile = io.File(fullPath);
  if (!targetFile.existsSync()) {
    throw Exception('Specified epub file not found: $fullPath');
  }

  final List<int> bytes = await targetFile.readAsBytes();
  test('Test Epub Ref', () async {
    final EpubBookRef epubRef = await openBook(bytes);

    expect(epubRef.author, equals('John S. Hittell'));
    expect(epubRef.title, equals('Hittel on Gold Mines and Mining'));
  });
  test('Test Epub Read', () async {
    final EpubBook epubRef = await readBook(bytes);

    expect(epubRef.author, equals('John S. Hittell'));
    expect(epubRef.title, equals('Hittel on Gold Mines and Mining'));
  });

  test('Test can read', () async {
    final String baseName = path.join(io.Directory.current.path, 'test', 'res', 'std');
    final io.Directory baseDir = io.Directory(baseName);
    if (!baseDir.existsSync()) {
      throw Exception('Base path does not exist: $baseName');
    }

    await baseDir.list(followLinks: false).forEach((io.FileSystemEntity fe) async {
      try {
        final io.File tf = io.File(fe.path);
        final List<int> bytes = await tf.readAsBytes();
        final EpubBook book = await readBook(bytes);
        expect(book, isNotNull);
      } on io.IOException catch (e) {
        print('File: ${fe.path}, Exception: $e');
        fail('Caught error...');
      }
    });
  });

  test('Test can open', () async {
    final String baseName = path.join(io.Directory.current.path, 'test', 'res', 'std');
    final io.Directory baseDir = io.Directory(baseName);
    if (!baseDir.existsSync()) {
      throw Exception('Base path does not exist: $baseName');
    }

    await baseDir.list(followLinks: false).forEach((io.FileSystemEntity fe) async {
      try {
        final io.File tf = io.File(fe.path);
        final Uint8List bytes = await tf.readAsBytes();
        final EpubBookRef ref = await openBook(bytes);
        expect(ref, isNotNull);
      } on io.IOException catch (e) {
        print('File: ${fe.path}, Exception: $e');
        fail('Caught error...');
      }
    });
  });
}
