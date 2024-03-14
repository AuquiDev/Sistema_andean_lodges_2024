// To parse this JSON data, do
//
//     final tReportPassa = tReportPassaFromJson(jsonString);


import 'package:ausangate_op/models/model_t_asistencia.dart';

class TPruebaFilesModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;


    String idTrabajo;
    String idEmpleados;
    String? image;
    List<String>? images;
    List<TAsistenciaModel> listaprueba;

    TPruebaFilesModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idTrabajo,
        required this.idEmpleados,
         this.image,
         this.images,
        required this.listaprueba,
    });

    factory TPruebaFilesModel.fromJson(Map<String, dynamic> json) => TPruebaFilesModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idTrabajo: json["idTrabajo"],
        idEmpleados: json["idEmpleados"],
        image: json["image"],
        // images: List<String>.from(json["images"].map((x) => x)),
        images: json["images"] != null
            ? List<String>.from(json["images"].map((x) => x))
            : null,
        listaprueba: json['listaprueba'] != null
            ? List<TAsistenciaModel>.from(json['listaprueba'].map((item) => TAsistenciaModel.fromJson(item)))
            : [],

    );


    Map<String, dynamic> toJson() {
       print('PROVIER MODELO: ${listaprueba.length}');
    return {
      "id": id,
      "collectionId": collectionId,//No es nesesario enviar este campo al servidor
      "collectionName": collectionName,//No es nesesario enviar este campo al servidor
      // "created": created,//No es nesesario enviar este campo al servidor
      // "updated": updated,//No es nesesario enviar este campo al servidor
      "idTrabajo": idTrabajo,
      "idEmpleados": idEmpleados,
      "image": image,
      "images": images != null ? List<dynamic>.from(images!.map((x) => x)) : null,
     'listaprueba': listaprueba.map((asistencia) => asistencia.toJson()).toList(),
      // "listaprueba": listaprueba,
      
    };
  }

 
}
