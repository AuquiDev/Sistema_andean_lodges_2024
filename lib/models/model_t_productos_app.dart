

import 'package:ausangate_op/utils/parse_fecha_nula.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';

class TProductosAppModel {
    int? idsql;//Se añade con fines de uso en sqllite 
    String id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;
    //
    String idCategoria;
    String idUbicacion;
    String idProveedor;
   List<String>? imagen;
    String nombreProducto;
    String marcaProducto;
    String unidMedida;
    double precioUnd;
    String unidMedidaSalida;
    double precioUnidadSalidaGrupo;
    String descripcionUbicDetll;
    String tipoProducto;
    DateTime fechaVencimiento;
    bool estado;
    String? documentUsoPreparacionReceta;
    double? stock;

    TProductosAppModel({
        this.idsql,
        required this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,
        required this.idCategoria,
        required this.idUbicacion,
        required this.idProveedor,
         this.imagen,
        required this.nombreProducto,
        required this.marcaProducto,
        required this.unidMedida,
        required this.precioUnd,
        required this.unidMedidaSalida,
        required this.precioUnidadSalidaGrupo,
        required this.descripcionUbicDetll,
        required this.tipoProducto,
        required this.fechaVencimiento,
        required this.estado,
         this.documentUsoPreparacionReceta,
        this.stock,
    });
      
    factory TProductosAppModel.fromJson(Map<String, dynamic> json) => TProductosAppModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: json["created"],
       updated: json["updated"],
        idCategoria: json["id_categoria"],
        idUbicacion: json["id_ubicacion"],
        idProveedor: json["id_proveedor"],
        // imagen: json["imagen"],
        imagen: List<String>.from(json["imagen"] ?? []), // manejo de nulos
        nombreProducto: json["nombre_producto"],
        marcaProducto: json["marca_producto"],
        unidMedida: json["unid_medida"],
         unidMedidaSalida: json["unid_medida_salida"],
        descripcionUbicDetll: json["Descripcion_Ubic_detll"],
        tipoProducto: json["tipo_producto"],
        fechaVencimiento: parseDateTime(json["fecha_vencimiento"]),
        estado: json["estado"] ,
        documentUsoPreparacionReceta: json["document_uso_preparacion_receta"],
       precioUnd: parseToDouble(json["precio_und"]),
        precioUnidadSalidaGrupo: parseToDouble(json["precio_unidad_salida_grupo"]),
        stock: parseToDouble(json["stock"])
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "id_categoria": idCategoria,
        "id_ubicacion": idUbicacion,
        "id_proveedor": idProveedor,
        // "imagen": imagen,
        "nombre_producto": nombreProducto,
        "marca_producto": marcaProducto,
        "unid_medida": unidMedida,
        "precio_und": precioUnd,
        "unid_medida_salida": unidMedidaSalida,
        "precio_unidad_salida_grupo": precioUnidadSalidaGrupo,
        "Descripcion_Ubic_detll": descripcionUbicDetll,
        "tipo_producto": tipoProducto,
        "fecha_vencimiento": fechaVencimiento.toIso8601String(),
        "estado": estado,
        "document_uso_preparacion_receta": documentUsoPreparacionReceta,
        "stock": stock,
    };
}
