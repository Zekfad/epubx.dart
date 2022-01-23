import 'package:xml/xml.dart';

import '../schema/opf/epub_metadata.dart';
import '../schema/opf/epub_metadata_contributor.dart';
import '../schema/opf/epub_metadata_creator.dart';
import '../schema/opf/epub_metadata_date.dart';
import '../schema/opf/epub_metadata_identifier.dart';
import '../schema/opf/epub_metadata_meta.dart';
import '../schema/opf/epub_version.dart';

const String _dcNamespace = 'http://purl.org/dc/elements/1.1/';
const String _opfNamespace = 'http://www.idpf.org/2007/opf';

void writeMetadata(XmlBuilder builder, EpubMetadata meta, EpubVersion? version) {
  builder.element('metadata', namespaces: <String, String>{_opfNamespace: 'opf', _dcNamespace: 'dc'}, nest: () {
    for (final String title in meta.titles) {
      builder.element('title', nest: title, namespace: _dcNamespace);
    }
    for (final EpubMetadataCreator creator in meta.creators) {
      builder.element('creator', namespace: _dcNamespace, nest: () {
        if (creator.role != null) {
          builder.attribute('role', creator.role!, namespace: _opfNamespace);
        }
        if (creator.fileAs != null) {
          builder.attribute('file-as', creator.fileAs!, namespace: _opfNamespace);
        }
        builder.text(creator.creator!);
      });
    }
    for (final String subject in meta.subjects) {
      builder.element('subject', nest: subject, namespace: _dcNamespace);
    }
    for (final String publisher in meta.publishers) {
      builder.element('publisher', nest: publisher, namespace: _dcNamespace);
    }
    for (final EpubMetadataContributor contributor in meta.contributors) {
      builder.element('contributor', namespace: _dcNamespace, nest: () {
        if (contributor.role != null) {
          builder.attribute('role', contributor.role!, namespace: _opfNamespace);
        }
        if (contributor.fileAs != null) {
          builder.attribute('file-as', contributor.fileAs!, namespace: _opfNamespace);
        }
        builder.text(contributor.contributor!);
      });
    }
    for (final EpubMetadataDate date in meta.dates) {
      builder.element('date', namespace: _dcNamespace, nest: () {
        if (date.event != null) {
          builder.attribute('event', date.event!, namespace: _opfNamespace);
        }
        builder.text(date.date!);
      });
    }
    for (final String type in meta.types) {
      builder.element('type', namespace: _dcNamespace, nest: type);
    }
    for (final String format in meta.formats) {
      builder.element('format', nest: format, namespace: _dcNamespace);
    }
    for (final EpubMetadataIdentifier id in meta.identifiers) {
      builder.element('identifier', namespace: _dcNamespace, nest: () {
        if (id.id != null) {
          builder.attribute('id', id.id!);
        }
        if (id.scheme != null) {
          builder.attribute('scheme', id.scheme!, namespace: _opfNamespace);
        }
        builder.text(id.identifier!);
      });
    }
    for (final String source in meta.sources) {
      builder.element('source', nest: source, namespace: _dcNamespace);
    }
    for (final String language in meta.languages) {
      builder.element('language', nest: language, namespace: _dcNamespace);
    }
    for (final String relation in meta.relations) {
      builder.element('relation', nest: relation, namespace: _dcNamespace);
    }
    for (final String coverage in meta.coverages) {
      builder.element('coverage', nest: coverage, namespace: _dcNamespace);
    }
    for (final String right in meta.rights) {
      builder.element('rights', nest: right, namespace: _dcNamespace);
    }
    for (final EpubMetadataMeta metaItem in meta.metaItems) {
      builder.element('meta', nest: () {
        if (version == EpubVersion.epub2) {
          if (metaItem.name != null) {
            builder.attribute('name', metaItem.name!);
          }
          if (metaItem.content != null) {
            builder.attribute('content', metaItem.content!);
          }
        } else if (version == EpubVersion.epub3) {
          if (metaItem.id != null) {
            builder.attribute('id', metaItem.id!);
          }
          if (metaItem.refines != null) {
            builder.attribute('refines', metaItem.refines!);
          }
          if (metaItem.property != null) {
            builder.attribute('property', metaItem.property!);
          }
          if (metaItem.scheme != null) {
            builder.attribute('scheme', metaItem.scheme!);
          }
        }
      });
    }

    if (meta.description != null) {
      builder.element('description', namespace: _dcNamespace, nest: meta.description);
    }
  });
}
