

class TItinerarioModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String diasNoches;
    String descripcion;

    TItinerarioModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.diasNoches,
        required this.descripcion,
    });

    factory TItinerarioModel.fromJson(Map<String, dynamic> json) => TItinerarioModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        diasNoches: json["dias_noches"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "dias_noches": diasNoches,
        "descripcion": descripcion,
    };
}
