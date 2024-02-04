
class TTipoGastoModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String nombreGasto;
    String descripcion;

    TTipoGastoModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.nombreGasto,
        required this.descripcion,
    });

    factory TTipoGastoModel.fromJson(Map<String, dynamic> json) => TTipoGastoModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        nombreGasto: json["nombre_gasto"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "nombre_gasto": nombreGasto,
        "descripcion": descripcion,
    };
}
