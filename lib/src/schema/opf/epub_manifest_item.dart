import 'package:quiver/core.dart';

class EpubManifestItem {
  String? id;
  String? href;
  String? mediaType;
  String? requiredNamespace;
  String? requiredModules;
  String? fallback;
  String? fallbackStyle;

  EpubManifestItem({this.id, this.href, this.mediaType, this.requiredNamespace, this.requiredModules, this.fallback, this.fallbackStyle});

  @override
  int get hashCode => hashObjects(
      <int>[id.hashCode, href.hashCode, mediaType.hashCode, requiredNamespace.hashCode, requiredModules.hashCode, fallback.hashCode, fallbackStyle.hashCode]);

  @override
  bool operator ==(Object other) {
    if (other is! EpubManifestItem) {
      return false;
    }

    return id == other.id &&
        href == other.href &&
        mediaType == other.mediaType &&
        requiredNamespace == other.requiredNamespace &&
        requiredModules == other.requiredModules &&
        fallback == other.fallback &&
        fallbackStyle == other.fallbackStyle;
  }

  @override
  String toString() => 'Id: $id, Href = $href, MediaType = $mediaType';
}
