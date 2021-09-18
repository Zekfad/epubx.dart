import 'package:xml/xml.dart';

import '../schema/opf/epub_manifest.dart';
import '../schema/opf/epub_manifest_item.dart';

void writeManifest(XmlBuilder builder, EpubManifest? manifest) {
  builder.element('manifest', nest: () {
    for (final EpubManifestItem item in manifest!.items) {
      builder.element('item', nest: () {
        builder
          ..attribute('id', item.id!)
          ..attribute('href', item.href!)
          ..attribute('media-type', item.mediaType!);
      });
    }
  });
}
