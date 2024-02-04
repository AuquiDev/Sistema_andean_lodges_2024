
class TCategoriaModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String categoria;
    String imagen;

    TCategoriaModel({
        required this.id,
        required this.collectionId,
        required this.collectionName,
        required this.created,
        required this.updated,
        required this.categoria,
        required this.imagen,
    });
     // Setter para 'id'
      set setId(String value) {
        id = value;
      }
      set setCreated(DateTime value) {
        created = value;
      }

      set setUpdated(DateTime value) {
        updated = value;
      }
      set setCollectionId(String value) {
        collectionId = value;
      }

      set setCollectionName(String value) {
        collectionName = value;
      }

    factory TCategoriaModel.fromJson(Map<String, dynamic> json) => TCategoriaModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: json["created"],
        updated: json["updated"],
        categoria: json["categoria"],
        imagen: json["imagen"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "categoria": categoria,
        "imagen": imagen,
    };
}
