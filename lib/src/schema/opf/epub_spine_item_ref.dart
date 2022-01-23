import 'package:quiver/core.dart';

class EpubSpineItemRef {
  String idRef;
  bool isLinear;

  EpubSpineItemRef({required this.idRef, required this.isLinear});

  @override
  int get hashCode => hash2(idRef.hashCode, isLinear.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is! EpubSpineItemRef) {
      return false;
    }

    return idRef == other.idRef && isLinear == other.isLinear;
  }

  @override
  String toString() => 'IdRef: $idRef';
}
