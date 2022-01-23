// ignore_for_file: avoid_classes_with_only_static_members

import 'package:xml/xml.dart' show XmlBuilder;

import '../schema/navigation/epub_navigation.dart';
// import '../schema/navigation/epub_navigation_doc_author.dart';
import '../schema/navigation/epub_navigation_doc_title.dart';
import '../schema/navigation/epub_navigation_head.dart';
import '../schema/navigation/epub_navigation_head_meta.dart';
import '../schema/navigation/epub_navigation_label.dart';
import '../schema/navigation/epub_navigation_map.dart';
import '../schema/navigation/epub_navigation_point.dart';

class EpubNavigationWriter {
  static const String _namespace = 'http://www.daisy.org/z3986/2005/ncx/';

  static String writeNavigation(EpubNavigation navigation) {
    final XmlBuilder builder = XmlBuilder();
    builder
      ..processing('xml', 'version="1.0" encoding="UTF-8" standalone="no"')
      ..element('ncx', attributes: <String, String>{
        'version': '2005-1',
        'lang': 'en',
      }, nest: () {
        builder.namespace(_namespace);

        writeNavigationHead(builder, navigation.head!);
        writeNavigationDocTitle(builder, navigation.docTitle!);
        writeNavigationMap(builder, navigation.navMap!);
      });

    return builder.buildDocument().toXmlString();
  }

  static void writeNavigationDocTitle(XmlBuilder builder, EpubNavigationDocTitle title) {
    builder.element('docTitle', nest: () {
      title.titles.forEach(builder.text);
    });
  }

  static void writeNavigationHead(XmlBuilder builder, EpubNavigationHead head) {
    builder.element('head', nest: () {
      for (final EpubNavigationHeadMeta item in head.metadata) {
        builder.element('meta', attributes: <String, String>{
          'content': item.content!,
          'name': item.name!
        });
      }
    });
  }

  static void writeNavigationMap(XmlBuilder builder, EpubNavigationMap map) {
    builder.element('navMap', nest: () {
      for (final EpubNavigationPoint item in map.points!) {
        writeNavigationPoint(builder, item);
      }
    });
  }

  static void writeNavigationPoint(XmlBuilder builder, EpubNavigationPoint point) {
    builder.element('navPoint', attributes: <String, String>{
      'id': point.id!,
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
}
