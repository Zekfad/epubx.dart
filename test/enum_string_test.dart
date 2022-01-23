library epubtest;

import 'package:repub/repub.dart';
import 'package:test/test.dart';

void main() {
  test('Enum One', () {
    expect(EnumFromString<Simple>(Simple.values).get('one'), equals(Simple.one));
  });
  test('Enum Two', () {
    expect(EnumFromString<Simple>(Simple.values).get('two'), equals(Simple.two));
  });
  test('Enum One', () {
    expect(EnumFromString<Simple>(Simple.values).get('three'), equals(Simple.three));
  });
  test('Enum One Upper Case', () {
    expect(EnumFromString<Simple>(Simple.values).get('ONE'), equals(Simple.one));
  });
}

enum Simple { one, two, three }
