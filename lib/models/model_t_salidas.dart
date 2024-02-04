


import 'package:ausangate_op/utils/parse_string_a_double.dart';

class TSalidasAppModel {
    String id;
    // String collectionId;
    // String collectionName;
    DateTime? created;
    DateTime? updated;

    String idProducto;
    String idEmpleado;
    String idTrabajo;
    double cantidadSalida;
    String descripcionSalida;
    String idProveedor;

    TSalidasAppModel({
        required this.id,
        // required this.collectionId,
        // required this.collectionName,
         this.created,
         this.updated,

        required this.idProducto,
        required this.idEmpleado,
        required this.idTrabajo,
        required this.cantidadSalida,
        required this.descripcionSalida,
        required this.idProveedor,
    });

    factory TSalidasAppModel.fromJson(Map<String, dynamic> json) => TSalidasAppModel(
        id: json["id"],
        // collectionId: json["collectionId"],
        // collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idProducto: json["id_producto"],
        idEmpleado: json["id_empleado"],
        idTrabajo: json["id_trabajo"],
        cantidadSalida: parseToDouble(json["cantidad_salida"]),
        descripcionSalida: json["descripcion_salida"],
        idProveedor: json["id_proveedor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        // "collectionId": collectionId,
        // "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "id_producto": idProducto,
        "id_empleado": idEmpleado,
        "id_trabajo": idTrabajo,
        "cantidad_salida": cantidadSalida,
        "descripcion_salida": descripcionSalida,
        "id_proveedor": idProveedor,
    };
}
