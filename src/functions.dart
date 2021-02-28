bool isNumeric(String s) {
 if (s == null) {
   return false;
 }
 return double.tryParse(s) != null;
}

bool isUpperCase(String s){
  if (s != null && s.toUpperCase() == s) {
   return true;
 }
  return false;
}