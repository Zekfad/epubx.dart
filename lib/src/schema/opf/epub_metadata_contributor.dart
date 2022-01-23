import 'package:quiver/core.dart';

class EpubMetadataContributor {
  String? contributor;
  String? fileAs;
  String? role;

  EpubMetadataContributor({this.contributor, this.fileAs, this.role});

  @override
  int get hashCode => hash3(contributor.hashCode, fileAs.hashCode, role.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is! EpubMetadataContributor) {
      return false;
    }

    return contributor == other.contributor && fileAs == other.fileAs && role == other.role;
  }
}
