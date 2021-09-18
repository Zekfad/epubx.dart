import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_byte_content_file.dart';
import 'epub_content_file.dart';
import 'epub_text_content_file.dart';

class EpubContent {
  late Map<String, EpubTextContentFile> html;
  late Map<String, EpubTextContentFile> css;
  late Map<String, EpubByteContentFile> images;
  late Map<String, EpubByteContentFile> fonts;
  late Map<String, EpubContentFile> allFiles;

  EpubContent({
    Map<String, EpubTextContentFile>? html,
    Map<String, EpubTextContentFile>? css,
    Map<String, EpubByteContentFile>? images,
    Map<String, EpubByteContentFile>? fonts,
    Map<String, EpubContentFile>? allFiles,
  }) {
    this.html = html ?? <String, EpubTextContentFile>{};
    this.css = css ?? <String, EpubTextContentFile>{};
    this.images = images ?? <String, EpubByteContentFile>{};
    this.fonts = fonts ?? <String, EpubByteContentFile>{};
    this.allFiles = allFiles ?? <String, EpubContentFile>{};
  }

  @override
  int get hashCode {
    final List<int> objects = <int>[
      ...html.keys.map((String key) => key.hashCode),
      ...html.values.map((EpubTextContentFile value) => value.hashCode),
      ...css.keys.map((String key) => key.hashCode),
      ...css.values.map((EpubTextContentFile value) => value.hashCode),
      ...images.keys.map((String key) => key.hashCode),
      ...images.values.map((EpubByteContentFile value) => value.hashCode),
      ...fonts.keys.map((String key) => key.hashCode),
      ...fonts.values.map((EpubByteContentFile value) => value.hashCode),
      ...allFiles.keys.map((String key) => key.hashCode),
      ...allFiles.values.map((EpubContentFile value) => value.hashCode),
    ];

    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubContent) {
      return false;
    }
    return collections.mapsEqual(html, other.html) &&
        collections.mapsEqual(css, other.css) &&
        collections.mapsEqual(images, other.images) &&
        collections.mapsEqual(fonts, other.fonts) &&
        collections.mapsEqual(allFiles, other.allFiles);
  }
}
