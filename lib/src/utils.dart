bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

bool isUpperCase(String s) {
  if (s.toUpperCase() == s) {
    return true;
  }
  return false;
}

int rankIndex(int startSquare) {
  return startSquare ~/ 8;
}
