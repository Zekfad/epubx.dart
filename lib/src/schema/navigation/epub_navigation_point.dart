import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';

class EpubNavigationPoint {
  String? id;
  String? cssClass;
  String? playOrder;
  List<EpubNavigationLabel> navigationLabels;
  EpubNavigationContent? content;
  List<EpubNavigationPoint> childNavigationPoints;

  EpubNavigationPoint(
      {this.id,
      this.cssClass,
      this.playOrder,
      this.navigationLabels = const <EpubNavigationLabel>[],
      this.content,
      this.childNavigationPoints = const <EpubNavigationPoint>[]});

  @override
  int get hashCode {
    final List<int> objects = <int>[
      id.hashCode,
      cssClass.hashCode,
      playOrder.hashCode,
      content.hashCode,
      ...navigationLabels.map((EpubNavigationLabel label) => label.hashCode),
      ...childNavigationPoints.map((EpubNavigationPoint point) => point.hashCode)
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationPoint) {
      return false;
    }

    if (!collections.listsEqual(navigationLabels, other.navigationLabels)) {
      return false;
    }

    if (!collections.listsEqual(childNavigationPoints, other.childNavigationPoints)) {
      return false;
    }

    return id == other.id && cssClass == other.cssClass && playOrder == other.playOrder && content == other.content;
  }

  @override
  String toString() => 'Id: $id, Content.Source: ${content!.source}';
}
