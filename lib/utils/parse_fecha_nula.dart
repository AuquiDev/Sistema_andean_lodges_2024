  DateTime parseDateTime(dynamic value) {
      if (value == null || value.toString().isEmpty) {
        // Asignar una fecha predeterminada si el valor es nulo o vacío
        return DateTime(1998, 1, 1); // Puedes cambiar esta fecha según tus necesidades
      } else {
        // Intentar convertir el valor a DateTime
        try {
          return DateTime.parse(value.toString());
        } catch (e) {
          // En caso de error al parsear, asignar una fecha por defecto
          return DateTime(1998, 1, 1); // Puedes cambiar esta fecha según tus necesidades
        }
      }
    }