class TReportPasajeroModel {
  int? idsql; //Se añade con fines de uso en sqllite
  String? id;
  String? collectionId;
  String? collectionName;
  DateTime? created;
  DateTime? updated;
  String idEmpleados;
  String idTrabajo;
  String nombrePasajero;
  String gmail;
  bool idioma;

  String pregunta1;
  String pregunta2;
  String pregunta3;
  String pregunta4;
  String pregunta5;
  String pregunta6;
  String pregunta7;
  String pregunta8;
  String pregunta9;
  String pregunta10;
  String pregunta11;
  String pregunta12;
  String pregunta13;

  TReportPasajeroModel({
    this.idsql,
    this.id,
    this.collectionId,
    this.collectionName,
    this.created,
    this.updated,
    required this.idEmpleados,
    required this.idTrabajo,
    required this.nombrePasajero,
    required this.gmail,
    required this.idioma,
    required this.pregunta1,
    required this.pregunta2,
    required this.pregunta3,
    required this.pregunta4,
    required this.pregunta5,
    required this.pregunta6,
    required this.pregunta7,
    required this.pregunta8,
    required this.pregunta9,
    required this.pregunta10,
    required this.pregunta11,
    required this.pregunta12,
    required this.pregunta13,
  });

  factory TReportPasajeroModel.fromJson(Map<String, dynamic> json) =>
      TReportPasajeroModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idEmpleados: json["idEmpleados"],
        idTrabajo: json["idTrabajo"],
        nombrePasajero: json["nombre_pasajero"],
        gmail: json["gmail"],
        idioma: json["idioma"],
        pregunta1: json["pregunta1"],
        pregunta2: json["pregunta2"],
        pregunta3: json["pregunta3"],
        pregunta4: json["pregunta4"],
        pregunta5: json["pregunta5"],
        pregunta6: json["pregunta6"],
        pregunta7: json["pregunta7"],
        pregunta8: json["pregunta8"],
        pregunta9: json["pregunta9"],
        pregunta10: json["pregunta10"],
        pregunta11: json["pregunta11"],
        pregunta12: json["pregunta12"],
        pregunta13: json["pregunta13"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "idEmpleados": idEmpleados,
        "idTrabajo": idTrabajo,
        "nombre_pasajero": nombrePasajero,
        "gmail": gmail,
        "idioma": idioma,
        "pregunta1": pregunta1,
        "pregunta2": pregunta2,
        "pregunta3": pregunta3,
        "pregunta4": pregunta4,
        "pregunta5": pregunta5,
        "pregunta6": pregunta6,
        "pregunta7": pregunta7,
        "pregunta8": pregunta8,
        "pregunta9": pregunta9,
        "pregunta10": pregunta10,
        "pregunta11": pregunta11,
        "pregunta12": pregunta12,
        "pregunta13": pregunta13,
      };
}
