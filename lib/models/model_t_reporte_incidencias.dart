class TReporteIncidenciasModel {
  int? idsql; //Se añade con fines de uso en sqllite
  String? id;
  String? collectionId;
  String? collectionName;
  DateTime? created;
  DateTime? updated;

  String idTrabajo;
  String idEmpleados;
  String pregunta1;
  String pregunta2;
  String pregunta3;
  String pregunta4;
  String pregunta5;
  String pregunta6;
  String pregunta7;

  TReporteIncidenciasModel({
    this.idsql,
    this.id,
    this.collectionId,
    this.collectionName,
    this.created,
    this.updated,
    required this.idTrabajo,
    required this.idEmpleados,
    required this.pregunta1,
    required this.pregunta2,
    required this.pregunta3,
    required this.pregunta4,
    required this.pregunta5,
    required this.pregunta6,
    required this.pregunta7,
  });

  factory TReporteIncidenciasModel.fromJson(Map<String, dynamic> json) =>
      TReporteIncidenciasModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idTrabajo: json["idTrabajo"],
        idEmpleados: json["idEmpleados"],
        pregunta1: json["pregunta1"],
        pregunta2: json["pregunta2"],
        pregunta3: json["pregunta3"],
        pregunta4: json["pregunta4"],
        pregunta5: json["pregunta5"],
        pregunta6: json["pregunta6"],
        pregunta7: json["pregunta7"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "idTrabajo": idTrabajo,
        "idEmpleados": idEmpleados,
        "pregunta1": pregunta1,
        "pregunta2": pregunta2,
        "pregunta3": pregunta3,
        "pregunta4": pregunta4,
        "pregunta5": pregunta5,
        "pregunta6": pregunta6,
        "pregunta7": pregunta7,
      };
}
