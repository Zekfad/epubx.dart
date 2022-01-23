import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubNavigationDocAuthor {
  List<String> authors;

  EpubNavigationDocAuthor({
    List<String>? authors,
  }) :
    authors = authors ?? <String>[];

  @override
  int get hashCode {
    final List<int> objects = <int>[...authors.map((String author) => author.hashCode)];
    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationDocAuthor) {
      return false;
    }

    return collections.listsEqual(authors, other.authors);
  }
}
