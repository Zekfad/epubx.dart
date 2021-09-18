import 'package:xml/xml.dart';

import '../schema/opf/epub_guide.dart';
import '../schema/opf/epub_guide_reference.dart';

void writeGuide(XmlBuilder builder, EpubGuide? guide) {
  builder.element('guide', nest: () {
    for (final EpubGuideReference guideItem in guide!.items) {
      builder.element('reference', attributes: <String, String>{'type': guideItem.type!, 'title': guideItem.title!, 'href': guideItem.href!});
    }
  });
}
