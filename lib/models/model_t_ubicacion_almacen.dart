
class TUbicacionAlmacenModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;
    //
    String? imagen;
    String nombreUbicacion;
    String descripcionUbicacion;

    TUbicacionAlmacenModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

         this.imagen,
        required this.nombreUbicacion,
        required this.descripcionUbicacion,
    });

    factory TUbicacionAlmacenModel.fromJson(Map<String, dynamic> json) => TUbicacionAlmacenModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: json["created"],
        updated: json["updated"],
        imagen: json["imagen"],
        nombreUbicacion: json["nombre_ubicacion"],
        descripcionUbicacion: json["descripcion_ubicacion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        // "imagen": imagen,
        "nombre_ubicacion": nombreUbicacion,
        "descripcion_ubicacion": descripcionUbicacion,
    };
}
