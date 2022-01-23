import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubNavigationDocTitle {
  List<String> titles;

  EpubNavigationDocTitle({
    List<String>? titles,
  }) :
    titles = titles ?? <String>[];

  @override
  int get hashCode {
    final List<int> objects = <int>[...titles.map((String title) => title.hashCode)];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationDocTitle) {
      return false;
    }

    return collections.listsEqual(titles, other.titles);
  }
}
