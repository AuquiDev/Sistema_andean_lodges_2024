

 String formatFecha(DateTime fecha){
    //Lista de dias en español
      List<String> diasSemana = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
    
    //Meses del año en espalol
      List<String> mesesAnio = [
       "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
      ];

      //Obtener el día de la semana, el día del mes y el mes en texto
      String diaSemana = diasSemana[fecha.weekday -1];
      String diaMes = fecha.day.toString();
      String mesAno = mesesAnio[fecha.month - 1];
      String ano = fecha.year.toString();


      String fechaFormateada = "$diaSemana, $diaMes $mesAno $ano";
      return fechaFormateada;
  }


String formatFechaHora(DateTime fecha) {
  // Lista de días en español
  List<String> diasSemana = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];

  // Meses del año en español
  List<String> mesesAnio = [
    "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
  ];

  // Obtener el día de la semana, el día del mes y el mes en texto
  String diaSemana = diasSemana[fecha.weekday - 1];
  String diaMes = fecha.day.toString();
  String mesAno = mesesAnio[fecha.month - 1];
  String ano = fecha.year.toString();

  // Obtener la hora y el minuto
  // String hora = fecha.hour.toString().padLeft(2, '0');
  String minuto = fecha.minute.toString().padLeft(2, '0');

  // Determinar si es AM o PM
  String periodo = (fecha.hour < 12) ? 'AM' : 'PM';

  // Convertir la hora al formato de 12 horas
  int hora12 = (fecha.hour > 12) ? fecha.hour - 12 : fecha.hour;
  //Hora PEru IDfenrecai Horas
  int horaPeru = (hora12 - 5).abs();//abs me ayuda a quitar el signo si sale negativo VALOR ABSOLUTO

  // Crear la cadena formateada
  String fechaFormateada = "$diaSemana, $diaMes $mesAno $ano a las $horaPeru:$minuto $periodo";
  return fechaFormateada;
}


String formatFechaHoraNow(DateTime fecha) {
  // Lista de días en español
  List<String> diasSemana = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];

  // Meses del año en español
  List<String> mesesAnio = [
    "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
  ];

  // Obtener el día de la semana, el día del mes y el mes en texto
  String diaSemana = diasSemana[fecha.weekday - 1];
  String diaMes = fecha.day.toString();
  String mesAno = mesesAnio[fecha.month - 1];
  String ano = fecha.year.toString();

  // Obtener la hora y el minuto
  // String hora = fecha.hour.toString().padLeft(2, '0');
  String minuto = fecha.minute.toString().padLeft(2, '0');

  // Determinar si es AM o PM
  String periodo = (fecha.hour < 12) ? 'AM' : 'PM';

  // Convertir la hora al formato de 12 horas
  int hora12 = (fecha.hour > 12) ? fecha.hour - 12 : fecha.hour;
  //Hora PEru IDfenrecai Horas
  // int horaPeru = (hora12 - 5).abs();//abs me ayuda a quitar el signo si sale negativo VALOR ABSOLUTO

  // Crear la cadena formateada
  String fechaFormateada = "$diaSemana, $diaMes $mesAno $ano a las $hora12:$minuto $periodo";
  return fechaFormateada;
}
//AGRUPAR LISTA POR CATEGORIA FECHA DE VENCIMIENTO


  String fechaFiltrada(DateTime fecha) {
    //Meses del año en espalol
    List<String> mesesAnio = [
      "Ene",
      "Feb",
      "Mar",
      "Abr",
      "May",
      "Jun",
      "Jul",
      "Ago",
      "Sep",
      "Oct",
      "Nov",
      "Dic"
    ];
    String mesAno = mesesAnio[fecha.month - 1];
    String ano = fecha.year.toString();
    String fechaFormateada =
        fecha.year == 1998 ? '(fecha nula)' : '$mesAno $ano';
    return fechaFormateada;
  }


 String formatFechaDiaMes(DateTime fecha){
    //Lista de dias en español
      List<String> diasSemana = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
    
    //Meses del año en espalol
      List<String> mesesAnio = [
       "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
      ];

      //Obtener el día de la semana, el día del mes y el mes en texto
      String diaSemana = diasSemana[fecha.weekday -1];
      String diaMes = fecha.day.toString();
      String mesAno = mesesAnio[fecha.month - 1];


      String fechaFormateada = "Vence\n$diaSemana,\n$diaMes $mesAno";
      return fechaFormateada;
  }

