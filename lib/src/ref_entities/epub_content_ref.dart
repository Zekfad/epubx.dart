import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_byte_content_file_ref.dart';
import 'epub_content_file_ref.dart';
import 'epub_text_content_file_ref.dart';

class EpubContentRef {
  late Map<String, EpubTextContentFileRef> html;
  late Map<String, EpubTextContentFileRef> css;
  late Map<String, EpubByteContentFileRef> images;
  late Map<String, EpubByteContentFileRef> fonts;
  late Map<String, EpubContentFileRef> allFiles;

  EpubContentRef({
    Map<String, EpubTextContentFileRef>? html,
    Map<String, EpubTextContentFileRef>? css,
    Map<String, EpubByteContentFileRef>? images,
    Map<String, EpubByteContentFileRef>? fonts,
    Map<String, EpubContentFileRef>? allFiles,
  }) {
    this.html = html ?? <String, EpubTextContentFileRef>{};
    this.css = css ?? <String, EpubTextContentFileRef>{};
    this.images = images ?? <String, EpubByteContentFileRef>{};
    this.fonts = fonts ?? <String, EpubByteContentFileRef>{};
    this.allFiles = allFiles ?? <String, EpubContentFileRef>{};
  }

  @override
  int get hashCode {
    final List<int> objects = <int>[
      ...html.keys.map((String key) => key.hashCode),
      ...html.values.map((EpubTextContentFileRef value) => value.hashCode),
      ...css.keys.map((String key) => key.hashCode),
      ...css.values.map((EpubTextContentFileRef value) => value.hashCode),
      ...images.keys.map((String key) => key.hashCode),
      ...images.values.map((EpubByteContentFileRef value) => value.hashCode),
      ...fonts.keys.map((String key) => key.hashCode),
      ...fonts.values.map((EpubByteContentFileRef value) => value.hashCode),
      ...allFiles.keys.map((String key) => key.hashCode),
      ...allFiles.values.map((EpubContentFileRef value) => value.hashCode)
    ];

    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubContentRef) {
      return false;
    }

    return collections.mapsEqual(html, other.html) &&
        collections.mapsEqual(css, other.css) &&
        collections.mapsEqual(images, other.images) &&
        collections.mapsEqual(fonts, other.fonts) &&
        collections.mapsEqual(allFiles, other.allFiles);
  }
}
