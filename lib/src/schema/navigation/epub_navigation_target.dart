import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';

class EpubNavigationTarget {
  String? id;
  String? cssClass;
  String? value;
  String? playOrder;
  List<EpubNavigationLabel> navigationLabels;
  EpubNavigationContent? content;

  EpubNavigationTarget({this.id, this.cssClass, this.value, this.playOrder, this.navigationLabels = const <EpubNavigationLabel>[], this.content});

  @override
  int get hashCode {
    final List<int> objects = <int>[
      id.hashCode,
      cssClass.hashCode,
      value.hashCode,
      playOrder.hashCode,
      content.hashCode,
      ...navigationLabels.map((EpubNavigationLabel label) => label.hashCode)
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationTarget) {
      return false;
    }

    if (!(id == other.id && cssClass == other.cssClass && value == other.value && playOrder == other.playOrder && content == other.content)) {
      return false;
    }

    return collections.listsEqual(navigationLabels, other.navigationLabels);
  }
}
