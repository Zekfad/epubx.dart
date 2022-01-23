import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_navigation_page_target.dart';

class EpubNavigationPageList {
  List<EpubNavigationPageTarget>? targets;

  EpubNavigationPageList({this.targets});

  @override
  int get hashCode => hashObjects(targets?.map((EpubNavigationPageTarget target) => target.hashCode) ?? <int>[0]);

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationPageList) {
      return false;
    }

    return collections.listsEqual(targets, other.targets);
  }
}
