import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';
import 'epub_navigation_page_target_type.dart';

class EpubNavigationPageTarget {
  String? id;
  String? value;
  EpubNavigationPageTargetType? type;
  String? cssClass;
  String? playOrder;
  List<EpubNavigationLabel>? navigationLabels;
  EpubNavigationContent? content;

  EpubNavigationPageTarget({this.id, this.value, this.type, this.cssClass, this.playOrder, this.navigationLabels, this.content});

  @override
  int get hashCode {
    final List<int> objects = <int>[
      id.hashCode,
      value.hashCode,
      type.hashCode,
      cssClass.hashCode,
      playOrder.hashCode,
      content.hashCode,
      ...navigationLabels?.map((EpubNavigationLabel label) => label.hashCode) ?? <int>[0]
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationPageTarget) {
      return false;
    }

    if (!(id == other.id &&
        value == other.value &&
        type == other.type &&
        cssClass == other.cssClass &&
        playOrder == other.playOrder &&
        content == other.content)) {
      return false;
    }

    return collections.listsEqual(navigationLabels, other.navigationLabels);
  }
}
