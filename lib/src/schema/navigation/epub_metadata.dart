import 'package:quiver/core.dart';

class EpubNavigationContent {
  String? id;
  String? source;

  EpubNavigationContent({this.id, this.source});

  @override
  int get hashCode => hash2(id.hashCode, source.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationContent) {
      return false;
    }
    return id == other.id && source == other.source;
  }

  @override
  String toString() => 'Source: $source';
}
