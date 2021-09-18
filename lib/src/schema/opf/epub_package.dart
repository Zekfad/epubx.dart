import 'package:quiver/core.dart';

import 'epub_guide.dart';
import 'epub_manifest.dart';
import 'epub_metadata.dart';
import 'epub_spine.dart';
import 'epub_version.dart';

class EpubPackage {
  EpubVersion? version;
  EpubMetadata? metadata;
  EpubManifest? manifest;
  EpubSpine? spine;
  EpubGuide? guide;

  EpubPackage({this.version, this.metadata, this.manifest, this.spine, this.guide});

  @override
  int get hashCode => hashObjects(<int>[version.hashCode, metadata.hashCode, manifest.hashCode, spine.hashCode, guide.hashCode]);

  @override
  bool operator ==(Object other) {
    if (other is! EpubPackage) {
      return false;
    }

    return version == other.version && metadata == other.metadata && manifest == other.manifest && spine == other.spine && guide == other.guide;
  }
}
