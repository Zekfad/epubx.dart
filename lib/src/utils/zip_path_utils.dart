String getDirectoryPath(String filePath) {
  final int lastSlashIndex = filePath.lastIndexOf('/');
  if (lastSlashIndex == -1) {
    return '';
  } else {
    return filePath.substring(0, lastSlashIndex);
  }
}

String? combine(String? directory, String? fileName) {
  if (directory == null || directory == '') {
    return fileName;
  } else {
    return '$directory/${fileName!}';
  }
}
