import 'package:quiver/core.dart';

class EpubGuideReference {
  String? type;
  String? title;
  String? href;

  EpubGuideReference({this.type, this.title, this.href});

  @override
  int get hashCode => hash3(type.hashCode, title.hashCode, href.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is! EpubGuideReference) {
      return false;
    }

    return type == other.type && title == other.title && href == other.href;
  }

  @override
  String toString() => 'Type: $type, Href: $href';
}
