

import 'package:ausangate_op/utils/parse_fecha_nula.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';

class TEntradasModel {
    String? id;
    // String? collectionId;
    // String? collectionName;
    DateTime? created;
    DateTime? updated;
    
    String idProducto;
    String idProveedor;
    String idEmpleado;
    double cantidadEntrada; 
    double precioEntrada;
    double? costoTotal;
    String descripcionEntrada;
    DateTime fechaVencimientoEntrada;

    TEntradasModel({
        required this.id,
        // required this.collectionId,
        // required this.collectionName,
         this.created,
         this.updated,
        required this.idProducto,
        required this.idProveedor,
        required this.idEmpleado,
        required this.cantidadEntrada,
        required this.precioEntrada,
         this.costoTotal,
        required this.descripcionEntrada,
        required this.fechaVencimientoEntrada,
    });

    factory TEntradasModel.fromJson(Map<String, dynamic> json) => TEntradasModel(
        id: json["id"],
        // collectionId: json["collectionId"],
        // collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idProducto: json["id_producto"],
        idProveedor: json["id_proveedor"],
        idEmpleado: json["id_empleado"],
        cantidadEntrada: parseToDouble(json["cantidad_entrada"]),
        precioEntrada: parseToDouble(json["precio_entrada"]),
        costoTotal: parseToDouble(json["costo_total"]),
        descripcionEntrada: json["descripcion_entrada"],
        fechaVencimientoEntrada: parseDateTime(json["fecha_vencimiento_entrada"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        // "collectionId": collectionId,
        // "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "id_producto": idProducto,
        "id_proveedor": idProveedor,
        "id_empleado": idEmpleado,
        "cantidad_entrada": cantidadEntrada,
        "precio_entrada": precioEntrada,
        "costo_total": costoTotal,
        "descripcion_entrada": descripcionEntrada,
        "fecha_vencimiento_entrada": fechaVencimientoEntrada.toIso8601String(),
    };
}
