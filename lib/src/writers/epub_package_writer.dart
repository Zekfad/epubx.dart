import 'package:xml/xml.dart';

import '../schema/opf/epub_metadata.dart';
import '../schema/opf/epub_package.dart';
import '../schema/opf/epub_version.dart';
import 'epub_guide_writer.dart';
import 'epub_manifest_writer.dart';
import 'epub_metadata_writer.dart';
import 'epub_spine_writer.dart';

const String _namespace = 'http://www.idpf.org/2007/opf';

String writeContent(EpubPackage package) {
  final XmlBuilder builder = XmlBuilder()..processing('xml', 'version="1.0" encoding="UTF-8" standalone="no"');

  builder.element('package', attributes: <String, String>{
    'version': package.version == EpubVersion.epub2 ? '2.0' : '3.0',
    'unique-identifier': package.uniqueIdentifier!,
  }, nest: () {
    builder.namespace(_namespace);

    writeMetadata(builder, package.metadata ?? EpubMetadata(), package.version);
    writeManifest(builder, package.manifest);
    writeSpine(builder, package.spine!);
    if (package.guide != null) {
      writeGuide(builder, package.guide!);
    }
  });

  return builder.buildDocument().toXmlString(pretty: true);
}
