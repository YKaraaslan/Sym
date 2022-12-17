extension ExtensionsString on String {
  bool isNumeric() => double.tryParse(this) != null;
  bool isUpperCase() => toUpperCase() == this;
}

extension ExtensionsInt on int {
  int rankIndex() => this ~/ 8;
}

extension Extensions on Enum {
  int getIndex() => index + 1;
  String getName() => toString().split('.').last;
}
