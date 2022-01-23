import 'dart:async';
import 'dart:convert' as convert;

import 'package:archive/archive.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:xml/xml.dart';

import '../schema/opf/epub_guide.dart';
import '../schema/opf/epub_guide_reference.dart';
import '../schema/opf/epub_manifest.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata.dart';
import '../schema/opf/epub_metadata_contributor.dart';
import '../schema/opf/epub_metadata_creator.dart';
import '../schema/opf/epub_metadata_date.dart';
import '../schema/opf/epub_metadata_identifier.dart';
import '../schema/opf/epub_metadata_meta.dart';
import '../schema/opf/epub_package.dart';
import '../schema/opf/epub_spine.dart';
import '../schema/opf/epub_spine_item_ref.dart';
import '../schema/opf/epub_version.dart';

EpubGuide readGuide(XmlElement guideNode) {
  final EpubGuide result = EpubGuide(items: <EpubGuideReference>[]);
  guideNode.children.whereType<XmlElement>().forEach((XmlElement guideReferenceNode) {
    if (guideReferenceNode.name.local.toLowerCase() == 'reference') {
      final EpubGuideReference guideReference = EpubGuideReference();
      for (final XmlAttribute guideReferenceNodeAttribute in guideReferenceNode.attributes) {
        final String attributeValue = guideReferenceNodeAttribute.value;
        switch (guideReferenceNodeAttribute.name.local.toLowerCase()) {
          case 'type':
            guideReference.type = attributeValue;
            break;
          case 'title':
            guideReference.title = attributeValue;
            break;
          case 'href':
            guideReference.href = attributeValue;
            break;
        }
      }
      if (guideReference.type == null || guideReference.type!.isEmpty) {
        throw Exception('Incorrect EPUB guide: item type is missing');
      }
      if (guideReference.href == null || guideReference.href!.isEmpty) {
        throw Exception('Incorrect EPUB guide: item href is missing');
      }
      result.items.add(guideReference);
    }
  });
  return result;
}

EpubManifest readManifest(XmlElement manifestNode) {
  final EpubManifest result = EpubManifest(items: <EpubManifestItem>[]);
  manifestNode.children.whereType<XmlElement>().forEach((XmlElement manifestItemNode) {
    if (manifestItemNode.name.local.toLowerCase() == 'item') {
      final EpubManifestItem manifestItem = EpubManifestItem();
      for (final XmlAttribute manifestItemNodeAttribute in manifestItemNode.attributes) {
        final String attributeValue = manifestItemNodeAttribute.value;
        switch (manifestItemNodeAttribute.name.local.toLowerCase()) {
          case 'id':
            manifestItem.id = attributeValue;
            break;
          case 'href':
            manifestItem.href = attributeValue;
            break;
          case 'media-type':
            manifestItem.mediaType = attributeValue;
            break;
          case 'required-namespace':
            manifestItem.requiredNamespace = attributeValue;
            break;
          case 'required-modules':
            manifestItem.requiredModules = attributeValue;
            break;
          case 'fallback':
            manifestItem.fallback = attributeValue;
            break;
          case 'fallback-style':
            manifestItem.fallbackStyle = attributeValue;
            break;
        }
      }

      if (manifestItem.id == null || manifestItem.id!.isEmpty) {
        throw Exception('Incorrect EPUB manifest: item ID is missing');
      }
      if (manifestItem.href == null || manifestItem.href!.isEmpty) {
        throw Exception('Incorrect EPUB manifest: item href is missing');
      }
      if (manifestItem.mediaType == null || manifestItem.mediaType!.isEmpty) {
        throw Exception('Incorrect EPUB manifest: item media type is missing');
      }
      result.items.add(manifestItem);
    }
  });
  return result;
}

EpubMetadata readMetadata(XmlElement metadataNode, EpubVersion? epubVersion) {
  final EpubMetadata result = EpubMetadata();
  metadataNode.children.whereType<XmlElement>().forEach((XmlElement metadataItemNode) {
    final String innerText = metadataItemNode.text;
    switch (metadataItemNode.name.local.toLowerCase()) {
      case 'title':
        result.titles.add(innerText);
        break;
      case 'creator':
        final EpubMetadataCreator creator = readMetadataCreator(metadataItemNode);
        result.creators.add(creator);
        break;
      case 'subject':
        result.subjects.add(innerText);
        break;
      case 'description':
        result.description = innerText;
        break;
      case 'publisher':
        result.publishers.add(innerText);
        break;
      case 'contributor':
        final EpubMetadataContributor contributor = readMetadataContributor(metadataItemNode);
        result.contributors.add(contributor);
        break;
      case 'date':
        final EpubMetadataDate date = readMetadataDate(metadataItemNode);
        result.dates.add(date);
        break;
      case 'type':
        result.types.add(innerText);
        break;
      case 'format':
        result.formats.add(innerText);
        break;
      case 'identifier':
        final EpubMetadataIdentifier identifier = readMetadataIdentifier(metadataItemNode);
        result.identifiers.add(identifier);
        break;
      case 'source':
        result.sources.add(innerText);
        break;
      case 'language':
        result.languages.add(innerText);
        break;
      case 'relation':
        result.relations.add(innerText);
        break;
      case 'coverage':
        result.coverages.add(innerText);
        break;
      case 'rights':
        result.rights.add(innerText);
        break;
      case 'meta':
        if (epubVersion == EpubVersion.epub2) {
          final EpubMetadataMeta meta = readMetadataMetaVersion2(metadataItemNode);
          result.metaItems.add(meta);
        } else if (epubVersion == EpubVersion.epub3) {
          final EpubMetadataMeta meta = readMetadataMetaVersion3(metadataItemNode);
          result.metaItems.add(meta);
        }
        break;
    }
  });
  return result;
}

EpubMetadataContributor readMetadataContributor(XmlElement metadataContributorNode) {
  final EpubMetadataContributor result = EpubMetadataContributor();
  for (final XmlAttribute metadataContributorNodeAttribute in metadataContributorNode.attributes) {
    final String attributeValue = metadataContributorNodeAttribute.value;
    switch (metadataContributorNodeAttribute.name.local.toLowerCase()) {
      case 'role':
        result.role = attributeValue;
        break;
      case 'file-as':
        result.fileAs = attributeValue;
        break;
    }
  }
  result.contributor = metadataContributorNode.text;
  return result;
}

EpubMetadataCreator readMetadataCreator(XmlElement metadataCreatorNode) {
  final EpubMetadataCreator result = EpubMetadataCreator();
  for (final XmlAttribute metadataCreatorNodeAttribute in metadataCreatorNode.attributes) {
    final String attributeValue = metadataCreatorNodeAttribute.value;
    switch (metadataCreatorNodeAttribute.name.local.toLowerCase()) {
      case 'role':
        result.role = attributeValue;
        break;
      case 'file-as':
        result.fileAs = attributeValue;
        break;
    }
  }
  result.creator = metadataCreatorNode.text;
  return result;
}

EpubMetadataDate readMetadataDate(XmlElement metadataDateNode) {
  final EpubMetadataDate result = EpubMetadataDate();
  final String? eventAttribute = metadataDateNode.getAttribute('event', namespace: metadataDateNode.name.namespaceUri);
  if (eventAttribute != null && eventAttribute.isNotEmpty) {
    result.event = eventAttribute;
  }
  result.date = metadataDateNode.text;
  return result;
}

EpubMetadataIdentifier readMetadataIdentifier(XmlElement metadataIdentifierNode) {
  final EpubMetadataIdentifier result = EpubMetadataIdentifier();
  for (final XmlAttribute metadataIdentifierNodeAttribute in metadataIdentifierNode.attributes) {
    final String attributeValue = metadataIdentifierNodeAttribute.value;
    switch (metadataIdentifierNodeAttribute.name.local.toLowerCase()) {
      case 'id':
        result.id = attributeValue;
        break;
      case 'scheme':
        result.scheme = attributeValue;
        break;
    }
  }
  result.identifier = metadataIdentifierNode.text;
  return result;
}

EpubMetadataMeta readMetadataMetaVersion2(XmlElement metadataMetaNode) {
  final EpubMetadataMeta result = EpubMetadataMeta();
  for (final XmlAttribute metadataMetaNodeAttribute in metadataMetaNode.attributes) {
    final String attributeValue = metadataMetaNodeAttribute.value;
    switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
      case 'name':
        result.name = attributeValue;
        break;
      case 'content':
        result.content = attributeValue;
        break;
    }
  }
  return result;
}

EpubMetadataMeta readMetadataMetaVersion3(XmlElement metadataMetaNode) {
  final EpubMetadataMeta result = EpubMetadataMeta();
  for (final XmlAttribute metadataMetaNodeAttribute in metadataMetaNode.attributes) {
    final String attributeValue = metadataMetaNodeAttribute.value;
    switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
      case 'id':
        result.id = attributeValue;
        break;
      case 'refines':
        result.refines = attributeValue;
        break;
      case 'property':
        result.property = attributeValue;
        break;
      case 'scheme':
        result.scheme = attributeValue;
        break;
    }
  }
  result.content = metadataMetaNode.text;
  return result;
}

Future<EpubPackage> readPackage(Archive epubArchive, String rootFilePath) async {
  final ArchiveFile? rootFileEntry = epubArchive.files.firstWhereOrNull((ArchiveFile testFile) => testFile.name == rootFilePath);
  if (rootFileEntry == null) {
    throw Exception('EPUB parsing error: root file not found in archive.');
  }
  final XmlDocument containerDocument = XmlDocument.parse(convert.utf8.decode(rootFileEntry.content));
  const String opfNamespace = 'http://www.idpf.org/2007/opf';
  final XmlElement packageNode = containerDocument.findElements('package', namespace: opfNamespace).firstWhere((XmlElement? elem) => elem != null);
  final EpubPackage result = EpubPackage();
  final String? epubVersionValue = packageNode.getAttribute('version');
  if (epubVersionValue == '2.0') {
    result.version = EpubVersion.epub2;
  } else if (epubVersionValue == '3.0') {
    result.version = EpubVersion.epub3;
  } else {
    throw Exception('Unsupported EPUB version: $epubVersionValue.');
  }
  final XmlElement? metadataNode =
      packageNode.findElements('metadata', namespace: opfNamespace).cast<XmlElement?>().firstWhere((XmlElement? elem) => elem != null);
  if (metadataNode == null) {
    throw Exception('EPUB parsing error: metadata not found in the package.');
  }
  final EpubMetadata metadata = readMetadata(metadataNode, result.version);
  result.metadata = metadata;
  final XmlElement? manifestNode =
      packageNode.findElements('manifest', namespace: opfNamespace).cast<XmlElement?>().firstWhere((XmlElement? elem) => elem != null);
  if (manifestNode == null) {
    throw Exception('EPUB parsing error: manifest not found in the package.');
  }
  final EpubManifest manifest = readManifest(manifestNode);
  result.manifest = manifest;

  final XmlElement? spineNode = packageNode.findElements('spine', namespace: opfNamespace).cast<XmlElement?>().firstWhere((XmlElement? elem) => elem != null);
  if (spineNode == null) {
    throw Exception('EPUB parsing error: spine not found in the package.');
  }
  final EpubSpine spine = readSpine(spineNode);
  result.spine = spine;
  final XmlElement? guideNode = packageNode.findElements('guide', namespace: opfNamespace).firstWhereOrNull((XmlElement? elem) => elem != null);
  if (guideNode != null) {
    final EpubGuide guide = readGuide(guideNode);
    result.guide = guide;
  }
  return result;
}

EpubSpine readSpine(XmlElement spineNode) {
  final EpubSpine result = EpubSpine(items: <EpubSpineItemRef>[]);
  final String? tocAttribute = spineNode.getAttribute('toc');
  result.tableOfContents = tocAttribute;
  spineNode.children.whereType<XmlElement>().forEach((XmlElement spineItemNode) {
    if (spineItemNode.name.local.toLowerCase() == 'itemref') {
      final String? idRefAttribute = spineItemNode.getAttribute('idref');
      if (idRefAttribute == null || idRefAttribute.isEmpty) {
        throw Exception('Incorrect EPUB spine: item ID ref is missing');
      }
      final String? linearAttribute = spineItemNode.getAttribute('linear');
      final EpubSpineItemRef spineItemRef =
          EpubSpineItemRef(idRef: idRefAttribute, isLinear: linearAttribute == null || (linearAttribute.toLowerCase() == 'no'));
      result.items.add(spineItemRef);
    }
  });
  return result;
}
