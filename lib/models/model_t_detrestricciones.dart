
class TRestriccionesModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String nombreRestriccion;
    String descripcion;

    TRestriccionesModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.nombreRestriccion,
        required this.descripcion,
    });

    factory TRestriccionesModel.fromJson(Map<String, dynamic> json) => TRestriccionesModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        nombreRestriccion: json["nombre_restriccion"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "nombre_restriccion": nombreRestriccion,
        "descripcion": descripcion,
    };
}
