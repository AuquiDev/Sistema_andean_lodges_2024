


import 'package:ausangate_op/utils/parse_fecha_nula.dart';

class TAsistenciaModel { 
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    
    String idEmpleados;
    String idTrabajo;
    DateTime horaEntrada;
    DateTime? horaSalida;
    String nombrePersonal;
    String actividadRol;
    String detalles;

    TAsistenciaModel({
         this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,
        
        required this.idEmpleados,
        required this.idTrabajo,
        required this.horaEntrada,
         this.horaSalida,
        required this.nombrePersonal,
        required this.actividadRol,
        required this.detalles,
    });

    factory TAsistenciaModel.fromJson(Map<String, dynamic> json) => TAsistenciaModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idEmpleados: json["id_empleados"],
        idTrabajo: json["id_trabajo"],
        horaEntrada: parseDateTime(json["hora_entrada"]),
        horaSalida: parseDateTime(json["hora_salida"]),
        nombrePersonal: json["nombre_personal"],
        actividadRol: json["actividad_rol"],
        detalles: json["detalles"],
    );


    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        // "created": created,
        // "updated": updated,
        "id_empleados": idEmpleados,
        "id_trabajo": idTrabajo,
        "hora_entrada": horaEntrada.toIso8601String(),
        "hora_salida": horaSalida?.toIso8601String(),
        "nombre_personal": nombrePersonal,
        "actividad_rol": actividadRol,
        "detalles": detalles,
    };
}
