class EpubNavigationLabel {
  String? text;

  EpubNavigationLabel({this.text});

  @override
  int get hashCode => text.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! EpubNavigationLabel) {
      return false;
    }
    return text == other.text;
  }

  @override
  String toString() => text!;
}
