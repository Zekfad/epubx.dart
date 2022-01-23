import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_spine_item_ref.dart';

class EpubSpine {
  String? tableOfContents;
  List<EpubSpineItemRef> items;

  EpubSpine({
    this.tableOfContents,
    List<EpubSpineItemRef>? items,
  }) :
    items = items ?? <EpubSpineItemRef>[];

  @override
  int get hashCode {
    final List<int> objects = <int>[tableOfContents.hashCode, ...items.map((EpubSpineItemRef item) => item.hashCode)];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubSpine) {
      return false;
    }

    if (!collections.listsEqual(items, other.items)) {
      return false;
    }
    return tableOfContents == other.tableOfContents;
  }
}
