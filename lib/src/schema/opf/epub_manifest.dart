import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_manifest_item.dart';

class EpubManifest {
  List<EpubManifestItem> items;

  EpubManifest({this.items = const <EpubManifestItem>[]});

  @override
  int get hashCode => hashObjects(items.map((EpubManifestItem item) => item.hashCode));

  @override
  bool operator ==(Object other) {
    if (other is! EpubManifest) {
      return false;
    }
    return collections.listsEqual(items, other.items);
  }
}
