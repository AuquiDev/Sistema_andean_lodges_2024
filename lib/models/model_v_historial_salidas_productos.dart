


import 'package:ausangate_op/utils/parse_fecha_nula.dart';

class ViewHistorialSalidasProductosModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime fcreated;
    DateTime fupdated;

    String idProducto;
    DateTime fechaVencimeintoProducto;
    String imagen;
    String producto;
    String tipoProducto;
    String unidMedidaSalida;
    double cantidadSalida;
    double precioUnidadSalidaGrupo;
    double montoTotalSalida;
    String nombreUbicacion;
    String descripcionSalida;
    DateTime fechaRegistroSalida;
    String nombreEmpleado;
    String imagenEmpleado;
    String cargoPuesto;
    String codigoGrupo;
    String idCodigoGrupo;
    String grupo;
    DateTime fechaInicio;
    DateTime fechaFin;
    String categoriaOTipoDeTrabajo;
    String descripcion;


    ViewHistorialSalidasProductosModel({
        required this.id,
        required this.collectionId,
        required this.collectionName,
        required this.idProducto,
        required this.fechaVencimeintoProducto,
        required this.imagen,
        required this.producto,
        required this.tipoProducto,
        required this.unidMedidaSalida,
        required this.cantidadSalida,
        required this.precioUnidadSalidaGrupo,
        required this.montoTotalSalida,
        required this.nombreUbicacion,
        required this.descripcionSalida,
        required this.fechaRegistroSalida,
        required this.nombreEmpleado,
        required this.imagenEmpleado,
        required this.cargoPuesto,
        required this.codigoGrupo,
        required this.idCodigoGrupo,
        required this.grupo,
        required this.fechaInicio,
        required this.fechaFin,
        required this.categoriaOTipoDeTrabajo,
        required this.descripcion,
        required this.fcreated,
        required this.fupdated,
    });

    // Setter para 'id'
      set setId(String value) {
        id = value;
      }
      // set setCreated(String value) {
      //    updated = value;
      // }

      // set setUpdated(String value) {
      //   updated = value;
      // }
      set setCollectionId(String value) {
        collectionId = value;
      }

      set setCollectionName(String value) {
        collectionName = value;
      }
    factory ViewHistorialSalidasProductosModel.fromJson(Map<String, dynamic> json) => ViewHistorialSalidasProductosModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        idProducto: json["id_producto"],
        fechaVencimeintoProducto: parseDateTime(json["fecha_vencimeinto_producto"]),
        imagen: json["imagen"],
        producto: json["producto"],
        tipoProducto: json["tipo_producto"],
        unidMedidaSalida: json["unid_medida_salida"],
        cantidadSalida: (json["cantidad_salida"] is int)? json["cantidad_salida"].toDouble() : double.parse(json["cantidad_salida"]).toDouble(),
        precioUnidadSalidaGrupo: (json["precio_unidad_salida_grupo"] is int)
    ? (json["precio_unidad_salida_grupo"] as int).toDouble()
    : (json["precio_unidad_salida_grupo"] is double)
        ? json["precio_unidad_salida_grupo"]
        : double.parse(json["precio_unidad_salida_grupo"].toString()).toDouble(),

        montoTotalSalida: (json["monto_total_salida"] is num)
    ? (json["monto_total_salida"] is int)
        ? json["monto_total_salida"].toDouble()
        : json["monto_total_salida"]
    : double.parse(json["monto_total_salida"] ?? "0").toDouble(),
        nombreUbicacion: json["nombre_ubicacion"],
        descripcionSalida: json["descripcion_salida"],
        fechaRegistroSalida: parseDateTime(json["fecha_registro_salida"]),
        nombreEmpleado: json["nombre_empleado"] ?? '',
        imagenEmpleado: json["imagen_empleado"],
        cargoPuesto: json["cargo_puesto"],
        codigoGrupo: json["codigo_grupo"],
        idCodigoGrupo: json["id_codigoGrupo"],
        grupo: json["grupo"] ?? '',
        fechaInicio: parseDateTime(json["fecha_inicio"]),
        fechaFin: parseDateTime(json["fecha_fin"]),
        categoriaOTipoDeTrabajo: json["Categoria_o_tipo_de_trabajo"] ?? '',
        descripcion: json["descripcion"],
        fcreated: DateTime.parse(json["fcreated"]),
        fupdated: DateTime.parse(json["fupdated"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "id_producto": idProducto,
        "fecha_vencimeinto_producto": fechaVencimeintoProducto,
        "imagen": imagen,
        "producto": producto,
        "tipo_producto": tipoProducto,
        "unid_medida_salida": unidMedidaSalida,
        "cantidad_salida": cantidadSalida,
        "precio_unidad_salida_grupo": precioUnidadSalidaGrupo,
        "monto_total_salida": montoTotalSalida,
        "nombre_ubicacion": nombreUbicacion,
        "descripcion_salida": descripcionSalida,
        "fecha_registro_salida": fechaRegistroSalida,
        "nombre_empleado": nombreEmpleado,
        "imagen_empleado": imagenEmpleado,
        "cargo_puesto": cargoPuesto,
        "codigo_grupo": codigoGrupo,
        "id_codigoGrupo": idCodigoGrupo,
        "grupo": grupo,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "Categoria_o_tipo_de_trabajo": categoriaOTipoDeTrabajo,
        "descripcion": descripcion,
        "fcreated": fcreated,
        "fupdated": fupdated,
    };
}
