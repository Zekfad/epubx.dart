import 'package:xml/xml.dart';

import '../schema/opf/epub_spine.dart';
import '../schema/opf/epub_spine_item_ref.dart';

void writeSpine(XmlBuilder builder, EpubSpine spine) {
  builder.element('spine', attributes: <String, String>{
    'toc': spine.tableOfContents!,
  }, nest: () {
    for (final EpubSpineItemRef spineitem in spine.items) {
      builder.element('itemref', attributes: <String, String>{
        'idref': spineitem.idRef,
        'linear': spineitem.isLinear ? 'yes' : 'no',
      });
    }
  });
}
