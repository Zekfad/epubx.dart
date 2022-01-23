import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_navigation_point.dart';

class EpubNavigationMap {
  List<EpubNavigationPoint>? points;

  EpubNavigationMap({this.points});

  @override
  int get hashCode => hashObjects(points?.map((EpubNavigationPoint point) => point.hashCode) ?? <int>[0]);

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationMap) {
      return false;
    }

    return collections.listsEqual(points, other.points);
  }
}
