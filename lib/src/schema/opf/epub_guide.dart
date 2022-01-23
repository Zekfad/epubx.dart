import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_guide_reference.dart';

class EpubGuide {
  List<EpubGuideReference> items;

  EpubGuide({this.items = const <EpubGuideReference>[]});

  @override
  int get hashCode {
    final List<int> objects = <int>[...items.map((EpubGuideReference item) => item.hashCode)];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubGuide) {
      return false;
    }

    return collections.listsEqual(items, other.items);
  }
}
