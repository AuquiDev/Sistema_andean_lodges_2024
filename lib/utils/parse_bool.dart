 bool parseBool(String value) {
  String lowerCaseValue = value.toLowerCase();
  
  if (lowerCaseValue == 'true') {
    return true;
  } else if (lowerCaseValue == 'false') {
    return false;
  } else {
    return false;
    // throw FormatException("Valor booleano no válido: $value");
  }
}
