

class AndesRaceModel {
   String? id;
   DateTime? created;
   DateTime? updated;
   String? collectionId;
   String? collectionName;
   
  final String runner;
  final List<String> document;
  final String option;
  final String realcion;
  final bool estado;

  AndesRaceModel({
    required this.id,
    required this.created,
    required this.updated, 
    required this.collectionId, 
    required this.collectionName,

    required this.runner,
    required this.document,
    required this.option,
    required this.realcion,
    required this.estado,
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

  factory AndesRaceModel.fromJson(Map<String, dynamic> json) {
    return AndesRaceModel(
        id: json["id"],
        created: json["created"],
        updated:json["updated"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        runner: json["runner"],
        document: List<String>.from(json["document"].map((x) => x)),
        option: json["option"],
        realcion: json["realcion"] ?? '',
        estado: json["estado"],
      );
  }
}


