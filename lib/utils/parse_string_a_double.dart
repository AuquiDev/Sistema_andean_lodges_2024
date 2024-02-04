double convertirTextoADouble(String texto) {
  try {
    // Intenta parsear la cadena a double
    return double.parse(texto);
  } catch (e) {
    // Si hay un error, intenta convertirlo a double como entero
    return double.tryParse(texto) ?? 0.0;
  }
}

double parseToDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    return double.parse(value.toString());
  }
}