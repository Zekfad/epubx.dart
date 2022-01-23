import 'dart:async';
import 'dart:convert' as convert;

import 'package:archive/archive.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:xml/xml.dart' as xml;

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
import '../schema/navigation/epub_navigation_page_target_type.dart';
import '../schema/navigation/epub_navigation_point.dart';
import '../schema/navigation/epub_navigation_target.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_package.dart';
import '../schema/opf/epub_version.dart';
import '../utils/zip_path_utils.dart';

Future<EpubNavigation?> readNavigation(Archive epubArchive, String contentDirectoryPath, EpubPackage package) async {
  final EpubNavigation result = EpubNavigation();
  final String? tocId = package.spine!.tableOfContents;
  if (tocId == null || tocId.isEmpty) {
    if (package.version == EpubVersion.epub2) {
      throw Exception('EPUB parsing error: TOC ID is empty.');
    }
    return null;
  }

  final EpubManifestItem? tocManifestItem = package.manifest!.items.firstWhereOrNull((EpubManifestItem item) => item.id!.toLowerCase() == tocId.toLowerCase());
  if (tocManifestItem == null) {
    throw Exception('EPUB parsing error: TOC item $tocId not found in EPUB manifest.');
  }

  final String? tocFileEntryPath = combine(contentDirectoryPath, tocManifestItem.href);
  final ArchiveFile? tocFileEntry = epubArchive.files.firstWhereOrNull((ArchiveFile file) => file.name.toLowerCase() == tocFileEntryPath!.toLowerCase());
  if (tocFileEntry == null) {
    throw Exception('EPUB parsing error: TOC file $tocFileEntryPath not found in archive.');
  }

  final xml.XmlDocument containerDocument = xml.XmlDocument.parse(convert.utf8.decode(tocFileEntry.content));

  const String ncxNamespace = 'http://www.daisy.org/z3986/2005/ncx/';
  final xml.XmlElement? ncxNode = containerDocument.findAllElements('ncx', namespace: ncxNamespace).firstWhereOrNull((xml.XmlElement? elem) => elem != null);
  if (ncxNode == null) {
    throw Exception('EPUB parsing error: TOC file does not contain ncx element.');
  }

  final xml.XmlElement? headNode = ncxNode.findAllElements('head', namespace: ncxNamespace).firstWhereOrNull((xml.XmlElement? elem) => elem != null);
  if (headNode == null) {
    throw Exception('EPUB parsing error: TOC file does not contain head element.');
  }

  final EpubNavigationHead navigationHead = readNavigationHead(headNode);
  result.head = navigationHead;
  final xml.XmlElement? docTitleNode = ncxNode.findElements('docTitle', namespace: ncxNamespace).firstWhereOrNull((xml.XmlElement? elem) => elem != null);
  if (docTitleNode == null) {
    throw Exception('EPUB parsing error: TOC file does not contain docTitle element.');
  }

  final EpubNavigationDocTitle navigationDocTitle = readNavigationDocTitle(docTitleNode);
  result
    ..docTitle = navigationDocTitle
    ..docAuthors = <EpubNavigationDocAuthor>[];
  ncxNode.findElements('docAuthor', namespace: ncxNamespace).forEach((xml.XmlElement docAuthorNode) {
    final EpubNavigationDocAuthor navigationDocAuthor = readNavigationDocAuthor(docAuthorNode);
    result.docAuthors!.add(navigationDocAuthor);
  });

  final xml.XmlElement? navMapNode = ncxNode.findElements('navMap', namespace: ncxNamespace).firstWhereOrNull((xml.XmlElement? elem) => elem != null);
  if (navMapNode == null) {
    throw Exception('EPUB parsing error: TOC file does not contain navMap element.');
  }

  final EpubNavigationMap navMap = readNavigationMap(navMapNode);
  result.navMap = navMap;
  final xml.XmlElement? pageListNode = ncxNode.findElements('pageList', namespace: ncxNamespace).firstWhereOrNull((xml.XmlElement? elem) => elem != null);
  if (pageListNode != null) {
    final EpubNavigationPageList pageList = readNavigationPageList(pageListNode);
    result.pageList = pageList;
  }

  result.navLists = <EpubNavigationList>[];
  ncxNode.findElements('navList', namespace: ncxNamespace).forEach((xml.XmlElement navigationListNode) {
    final EpubNavigationList navigationList = readNavigationList(navigationListNode);
    result.navLists!.add(navigationList);
  });

  return result;
}

EpubNavigationContent readNavigationContent(xml.XmlElement navigationContentNode) {
  final EpubNavigationContent result = EpubNavigationContent();
  for (final xml.XmlAttribute navigationContentNodeAttribute in navigationContentNode.attributes) {
    final String attributeValue = navigationContentNodeAttribute.value;
    switch (navigationContentNodeAttribute.name.local.toLowerCase()) {
      case 'id':
        result.id = attributeValue;
        break;
      case 'src':
        result.source = attributeValue;
        break;
    }
  }
  if (result.source == null || result.source!.isEmpty) {
    throw Exception('Incorrect EPUB navigation content: content source is missing.');
  }

  return result;
}

EpubNavigationDocAuthor readNavigationDocAuthor(xml.XmlElement docAuthorNode) {
  final EpubNavigationDocAuthor result = EpubNavigationDocAuthor(authors: <String>[]);
  docAuthorNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement textNode) {
    if (textNode.name.local.toLowerCase() == 'text') {
      result.authors.add(textNode.text);
    }
  });
  return result;
}

EpubNavigationDocTitle readNavigationDocTitle(xml.XmlElement docTitleNode) {
  final EpubNavigationDocTitle result = EpubNavigationDocTitle(titles: <String>[]);
  docTitleNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement textNode) {
    if (textNode.name.local.toLowerCase() == 'text') {
      result.titles.add(textNode.text);
    }
  });
  return result;
}

EpubNavigationHead readNavigationHead(xml.XmlElement headNode) {
  final EpubNavigationHead result = EpubNavigationHead(metadata: <EpubNavigationHeadMeta>[]);

  headNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement metaNode) {
    if (metaNode.name.local.toLowerCase() == 'meta') {
      final EpubNavigationHeadMeta meta = EpubNavigationHeadMeta();
      for (final xml.XmlAttribute metaNodeAttribute in metaNode.attributes) {
        final String attributeValue = metaNodeAttribute.value;
        switch (metaNodeAttribute.name.local.toLowerCase()) {
          case 'name':
            meta.name = attributeValue;
            break;
          case 'content':
            meta.content = attributeValue;
            break;
          case 'scheme':
            meta.scheme = attributeValue;
            break;
        }
      }

      if (meta.name == null || meta.name!.isEmpty) {
        throw Exception('Incorrect EPUB navigation meta: meta name is missing.');
      }
      if (meta.content == null) {
        throw Exception('Incorrect EPUB navigation meta: meta content is missing.');
      }

      result.metadata.add(meta);
    }
  });
  return result;
}

EpubNavigationLabel readNavigationLabel(xml.XmlElement navigationLabelNode) {
  final EpubNavigationLabel result = EpubNavigationLabel();

  final xml.XmlElement? navigationLabelTextNode =
      navigationLabelNode.findElements('text', namespace: navigationLabelNode.name.namespaceUri).firstWhereOrNull((xml.XmlElement? elem) => elem != null);
  if (navigationLabelTextNode == null) {
    throw Exception('Incorrect EPUB navigation label: label text element is missing.');
  }

  result.text = navigationLabelTextNode.text;

  return result;
}

EpubNavigationList readNavigationList(xml.XmlElement navigationListNode) {
  final EpubNavigationList result = EpubNavigationList();
  for (final xml.XmlAttribute navigationListNodeAttribute in navigationListNode.attributes) {
    final String attributeValue = navigationListNodeAttribute.value;
    switch (navigationListNodeAttribute.name.local.toLowerCase()) {
      case 'id':
        result.id = attributeValue;
        break;
      case 'class':
        result.cssClass = attributeValue;
        break;
    }
  }
  navigationListNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationListChildNode) {
    switch (navigationListChildNode.name.local.toLowerCase()) {
      case 'navlabel':
        final EpubNavigationLabel navigationLabel = readNavigationLabel(navigationListChildNode);
        result.navigationLabels!.add(navigationLabel);
        break;
      case 'navtarget':
        final EpubNavigationTarget navigationTarget = readNavigationTarget(navigationListChildNode);
        result.navigationTargets!.add(navigationTarget);
        break;
    }
  });
  if (result.navigationLabels!.isEmpty) {
    throw Exception('Incorrect EPUB navigation page target: at least one navLabel element is required.');
  }
  return result;
}

EpubNavigationMap readNavigationMap(xml.XmlElement navigationMapNode) {
  final EpubNavigationMap result = EpubNavigationMap(points: <EpubNavigationPoint>[]);
  navigationMapNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationPointNode) {
    if (navigationPointNode.name.local.toLowerCase() == 'navpoint') {
      final EpubNavigationPoint navigationPoint = readNavigationPoint(navigationPointNode);
      result.points!.add(navigationPoint);
    }
  });
  return result;
}

EpubNavigationPageList readNavigationPageList(xml.XmlElement navigationPageListNode) {
  final EpubNavigationPageList result = EpubNavigationPageList(targets: <EpubNavigationPageTarget>[]);
  navigationPageListNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement pageTargetNode) {
    if (pageTargetNode.name.local == 'pageTarget') {
      final EpubNavigationPageTarget pageTarget = readNavigationPageTarget(pageTargetNode);
      result.targets!.add(pageTarget);
    }
  });

  return result;
}

EpubNavigationPageTarget readNavigationPageTarget(xml.XmlElement navigationPageTargetNode) {
  final EpubNavigationPageTarget result = EpubNavigationPageTarget(navigationLabels: <EpubNavigationLabel>[]);
  for (final xml.XmlAttribute navigationPageTargetNodeAttribute in navigationPageTargetNode.attributes) {
    final String attributeValue = navigationPageTargetNodeAttribute.value;
    switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
      case 'id':
        result.id = attributeValue;
        break;
      case 'value':
        result.value = attributeValue;
        break;
      case 'type':
        result.type = EpubNavigationPageTargetType.values.byName(attributeValue);
        break;
      case 'class':
        result.cssClass = attributeValue;
        break;
      case 'playorder':
        result.playOrder = attributeValue;
        break;
    }
  }
  if (result.type == EpubNavigationPageTargetType.undefined) {
    throw Exception('Incorrect EPUB navigation page target: page target type is missing.');
  }

  navigationPageTargetNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationPageTargetChildNode) {
    switch (navigationPageTargetChildNode.name.local.toLowerCase()) {
      case 'navlabel':
        final EpubNavigationLabel navigationLabel = readNavigationLabel(navigationPageTargetChildNode);
        result.navigationLabels!.add(navigationLabel);
        break;
      case 'content':
        final EpubNavigationContent content = readNavigationContent(navigationPageTargetChildNode);
        result.content = content;
        break;
    }
  });
  if (result.navigationLabels!.isEmpty) {
    throw Exception('Incorrect EPUB navigation page target: at least one navLabel element is required.');
  }

  return result;
}

EpubNavigationPoint readNavigationPoint(xml.XmlElement navigationPointNode) {
  final EpubNavigationPoint result = EpubNavigationPoint();
  for (final xml.XmlAttribute navigationPointNodeAttribute in navigationPointNode.attributes) {
    final String attributeValue = navigationPointNodeAttribute.value;
    switch (navigationPointNodeAttribute.name.local.toLowerCase()) {
      case 'id':
        result.id = attributeValue;
        break;
      case 'class':
        result.cssClass = attributeValue;
        break;
      case 'playorder':
        result.playOrder = attributeValue;
        break;
    }
  }
  if (result.id == null || result.id!.isEmpty) {
    throw Exception('Incorrect EPUB navigation point: point ID is missing.');
  }

  result
    ..navigationLabels = <EpubNavigationLabel>[]
    ..childNavigationPoints = <EpubNavigationPoint>[];
  navigationPointNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationPointChildNode) {
    switch (navigationPointChildNode.name.local.toLowerCase()) {
      case 'navlabel':
        final EpubNavigationLabel navigationLabel = readNavigationLabel(navigationPointChildNode);
        result.navigationLabels.add(navigationLabel);
        break;
      case 'content':
        final EpubNavigationContent content = readNavigationContent(navigationPointChildNode);
        result.content = content;
        break;
      case 'navpoint':
        final EpubNavigationPoint childNavigationPoint = readNavigationPoint(navigationPointChildNode);
        result.childNavigationPoints.add(childNavigationPoint);
        break;
    }
  });

  if (result.navigationLabels.isEmpty) {
    throw Exception('EPUB parsing error: navigation point ${result.id} should contain at least one navigation label.');
  }
  if (result.content == null) {
    throw Exception('EPUB parsing error: navigation point ${result.id} should contain content.');
  }

  return result;
}

EpubNavigationTarget readNavigationTarget(xml.XmlElement navigationTargetNode) {
  final EpubNavigationTarget result = EpubNavigationTarget();
  for (final xml.XmlAttribute navigationPageTargetNodeAttribute in navigationTargetNode.attributes) {
    final String attributeValue = navigationPageTargetNodeAttribute.value;
    switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
      case 'id':
        result.id = attributeValue;
        break;
      case 'value':
        result.value = attributeValue;
        break;
      case 'class':
        result.cssClass = attributeValue;
        break;
      case 'playorder':
        result.playOrder = attributeValue;
        break;
    }
  }
  if (result.id == null || result.id!.isEmpty) {
    throw Exception('Incorrect EPUB navigation target: navigation target ID is missing.');
  }

  navigationTargetNode.children.whereType<xml.XmlElement>().forEach((xml.XmlElement navigationTargetChildNode) {
    switch (navigationTargetChildNode.name.local.toLowerCase()) {
      case 'navlabel':
        final EpubNavigationLabel navigationLabel = readNavigationLabel(navigationTargetChildNode);
        result.navigationLabels.add(navigationLabel);
        break;
      case 'content':
        final EpubNavigationContent content = readNavigationContent(navigationTargetChildNode);
        result.content = content;
        break;
    }
  });
  if (result.navigationLabels.isEmpty) {
    throw Exception('Incorrect EPUB navigation target: at least one navLabel element is required.');
  }

  return result;
}
