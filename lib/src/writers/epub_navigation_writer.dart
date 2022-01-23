import 'package:xml/xml.dart' show XmlBuilder, XmlDoctype;

import '../schema/navigation/epub_metadata.dart';
import '../schema/navigation/epub_navigation.dart';
import '../schema/navigation/epub_navigation_doc_author.dart';
import '../schema/navigation/epub_navigation_doc_title.dart';
import '../schema/navigation/epub_navigation_head.dart';
import '../schema/navigation/epub_navigation_head_meta.dart';
import '../schema/navigation/epub_navigation_label.dart';
import '../schema/navigation/epub_navigation_list.dart';
import '../schema/navigation/epub_navigation_map.dart';
import '../schema/navigation/epub_navigation_page_list.dart';
import '../schema/navigation/epub_navigation_page_target.dart';
import '../schema/navigation/epub_navigation_point.dart';
import '../schema/navigation/epub_navigation_target.dart';

const String _namespace = 'http://www.daisy.org/z3986/2005/ncx/';

String writeNavigation(EpubNavigation navigation) {
  final XmlBuilder builder = XmlBuilder();
  builder
    ..processing('xml', 'version="1.0" encoding="UTF-8" standalone="no"')
    ..xml('<!DOCTYPE ncx PUBLIC "-//NISO//DTD ncx 2005-1//EN"\n"http://www.daisy.org/z3986/2005/ncx-2005-1.dtd">')
    ..element('ncx', attributes: <String, String>{
      'version': '2005-1',
    }, nest: () {
      builder.namespace(_namespace);

      writeNavigationHead(builder, navigation.head!);
      writeNavigationDocTitle(builder, navigation.docTitle!);
      navigation.docAuthors?.forEach((EpubNavigationDocAuthor docAuthor) {
        writeNavigationDocAuthor(builder, docAuthor);
      });
      writeNavigationMap(builder, navigation.navMap!);
      if (navigation.pageList != null) {
        writeNavigationPageList(builder, navigation.pageList!);
      }
      navigation.navLists?.forEach((EpubNavigationList navList) {
        writeNavigationList(builder, navList);
      });
    });

  return builder.buildDocument().toXmlString(pretty: true);
}

void writeNavigationHead(XmlBuilder builder, EpubNavigationHead head) {
  builder.element('head', nest: () {
    for (final EpubNavigationHeadMeta item in head.metadata) {
      builder.element('meta', attributes: <String, String>{
        'name': item.name!,
        'content': item.content!,
      });
    }
  });
}

void writeNavigationDocTitle(XmlBuilder builder, EpubNavigationDocTitle title) {
  builder.element('docTitle', nest: () {
    builder.element('text', nest: () {
      builder.text(title.titles.join(', '));
    });
  });
}

void writeNavigationDocAuthor(XmlBuilder builder, EpubNavigationDocAuthor docAuthor) {
  for (final String author in docAuthor.authors) {
    builder.element('docAuthor', nest: () {
      builder.element('text', nest: () {
        builder.text(author);
      });
    });
  }
}

void writeNavigationMap(XmlBuilder builder, EpubNavigationMap map) {
  builder.element('navMap', nest: () {
    for (final EpubNavigationPoint item in map.points!) {
      writeNavigationPoint(builder, item);
    }
  });
}

void writeNavigationPageList(XmlBuilder builder, EpubNavigationPageList pageList) {
  builder.element('pageList', nest: () {
    for (final EpubNavigationPageTarget item in pageList.targets!) {
      writeNavigationPageTarget(builder, item);
    }
  });
}

void writeNavigationPageTarget(XmlBuilder builder, EpubNavigationPageTarget target) {
  builder.element('navTarget', attributes: <String, String>{
    'id': target.id!,
    if (target.cssClass != null)
      'class': target.cssClass!,
    'type': target.type!.name,
    if (target.value != null)
      'value': target.value!,
    'playOrder': target.playOrder!,
  }, nest: () {
    for (final EpubNavigationLabel item in target.navigationLabels!) {
      writeNavigationLabel(builder, item);
    }
    writeNavigationContent(builder, target.content!);
  });
}

void writeNavigationList(XmlBuilder builder, EpubNavigationList navList) {
  builder.element('navList', attributes: <String, String>{
    'id': navList.id!,
    if (navList.cssClass != null)
      'class': navList.cssClass!,
  }, nest: () {
    for (final EpubNavigationLabel item in navList.navigationLabels!) {
      writeNavigationLabel(builder, item);
    }
    for (final EpubNavigationTarget item in navList.navigationTargets!) {
      writeNavigationTarget(builder, item);
    }
  });
}

void writeNavigationLabel(XmlBuilder builder, EpubNavigationLabel label) {
  builder.element('navLabel', nest: () {
    builder.text(label.text!);
  });
}

void writeNavigationTarget(XmlBuilder builder, EpubNavigationTarget target) {
  builder.element('navTarget', attributes: <String, String>{
    'id': target.id!,
    if (target.cssClass != null)
      'class': target.cssClass!,
    if (target.value != null)
      'value': target.value!,
    'playOrder': target.playOrder!,
  }, nest: () {
    for (final EpubNavigationLabel item in target.navigationLabels) {
      writeNavigationLabel(builder, item);
    }
    writeNavigationContent(builder, target.content!);
  });
}

void writeNavigationContent(XmlBuilder builder, EpubNavigationContent content) {
  builder.element('content', attributes: {
    'id': content.id!,
    'src': content.source!,
  });
}

void writeNavigationPoint(XmlBuilder builder, EpubNavigationPoint point) {
  builder.element('navPoint', attributes: <String, String>{
    'id': point.id!,
    if (point.cssClass != null)
      'class': point.cssClass!,
    'playOrder': point.playOrder!,
  }, nest: () {
    for (final EpubNavigationLabel element in point.navigationLabels) {
      builder.element('navLabel', nest: () {
        builder.element('text', nest: () {
          builder.text(element.text!);
        });
      });
    }
    builder.element('content', attributes: <String, String>{
      'src': point.content!.source!,
    });
  });
}
