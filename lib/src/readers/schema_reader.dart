import 'dart:async';

import 'package:archive/archive.dart';

import '../entities/epub_schema.dart';
import '../schema/navigation/epub_navigation.dart';
import '../schema/opf/epub_package.dart';
import '../utils/zip_path_utils.dart';
import 'navigation_reader.dart';
import 'package_reader.dart';
import 'root_file_path_reader.dart';

Future<EpubSchema> readSchema(Archive epubArchive) async {
  final EpubSchema result = EpubSchema();

  final String rootFilePath = (await getRootFilePath(epubArchive))!;
  final String contentDirectoryPath = getDirectoryPath(rootFilePath);
  result.contentDirectoryPath = contentDirectoryPath;

  final EpubPackage package = await readPackage(epubArchive, rootFilePath);
  result.package = package;

  final EpubNavigation? navigation = await readNavigation(epubArchive, contentDirectoryPath, package);
  result.navigation = navigation;

  return result;
}
