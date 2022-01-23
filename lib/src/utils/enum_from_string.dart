class EnumFromString<T> {
  List<T?> enumValues;

  EnumFromString(this.enumValues);

  T? get(String value) {
    final String enumString = '$T.$value';
    // ignore: null_closures
    return enumValues.firstWhere((T? f) => f.toString().toUpperCase() == enumString.toUpperCase(), orElse: null);
  }
}
