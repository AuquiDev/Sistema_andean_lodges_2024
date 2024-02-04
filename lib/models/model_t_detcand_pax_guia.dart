

class TCantidadPaxGuiaModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String pax;
    String guia;
    String descripcion;

    TCantidadPaxGuiaModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,
        required this.pax,
        required this.guia,
        required this.descripcion,
    });

    factory TCantidadPaxGuiaModel.fromJson(Map<String, dynamic> json) => TCantidadPaxGuiaModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        pax: json["pax"],
        guia: json["guia"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "pax": pax,
        "guia": guia,
        "descripcion": descripcion,
    };
}
