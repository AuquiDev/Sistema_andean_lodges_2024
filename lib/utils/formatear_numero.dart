String formatearNumero(double numero) {
  if (numero % 1 == 0) {
    // Si el número no tiene decimales, mostrarlo como entero
    return numero.toInt().toString();
  } else {
    // Si el número tiene decimales, mostrarlo con un solo decimal
    return numero.toStringAsFixed(1);
  }
}

// Ejemplo de uso
double numero1 = 10.0;
double numero2 = 15.5;

// print(formatearNumero(numero1));  // Salida: "10"
// print(formatearNumero(numero2));  // Salida: "15.5"