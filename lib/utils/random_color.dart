
import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
  final Random random = Random();
  const int baseGreen = 100; // Valor base para el componente verde

  return Color.fromARGB(
    255,
    random.nextInt(56) + baseGreen,  // Rojo en el rango 100-155
    random.nextInt(100) + baseGreen, // Verde en el rango 100-199
    random.nextInt(56) + baseGreen,  // Azul en el rango 100-155
  );
}