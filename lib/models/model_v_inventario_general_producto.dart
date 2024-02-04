//SIRVE PARA LAS VISTAS DE INVENTARIO, GENERAL, POR LABERGURES, ORDEN DE O CMPRA Y ALERTAS. 


import 'package:ausangate_op/utils/parse_fecha_nula.dart';

class ViewInventarioGeneralProductosModel {
   String? id;
  //  String? created;
  //  String? updated;
  DateTime fechaModificacion;
  DateTime fechaCreacion;
   String? collectionId;
   String? collectionName;
  //DATOS 
    String idUbicaion;//NEW
    String nombreUbicacion;
    String idCategoria;//NEW
    String categoria;
    String imagen;
    String idProducto;//NEW
    String producto;
    DateTime? fechaVencimiento;
    String tipoProducto;
    String idProveedor;//NEW
    String nombreEmpresaProveedor;
    double cantidadEntrada;//#
    double cantidadSalida;//#
    double stock;//#
    String estadoFecha;
    String estadoStock;
    double precioUnd;//#
    String unidMedida;
    String marcaProducto;//
    String descripcionUbicDetll;
    String documentUsoPreparacionReceta;
    double precioUnidadSalidaGrupo;//#
    String unidMedidaSalida;

     ViewInventarioGeneralProductosModel({
      required this.id,
      // required this.created,
      // required this.updated,
      required this.fechaModificacion,
        required this.fechaCreacion,
      required this.collectionId,
      required this.collectionName,
      //DATOS 
        required this.idUbicaion,//
        required this.nombreUbicacion,
        required this.idCategoria,//
        required this.categoria,
        required this.imagen,
        required this.idProducto,//
        required this.producto,
        required this.fechaVencimiento,
        required this.tipoProducto,
        required this.idProveedor,//
        required this.nombreEmpresaProveedor,
        required this.cantidadEntrada,
        required this.cantidadSalida,
        required this.stock,
        required this.estadoFecha,
        required this.estadoStock,
        required this.precioUnd,
        required this.unidMedida,
        required this.marcaProducto,//
        required this.descripcionUbicDetll,
        required this.documentUsoPreparacionReceta,
        required this.precioUnidadSalidaGrupo,
        required this.unidMedidaSalida,
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

     factory ViewInventarioGeneralProductosModel.fromJson(Map<String, dynamic> json) {
       return ViewInventarioGeneralProductosModel(
        id: json["id"],
        // created: json["created"], 
        // updated: json["updated"],
        fechaModificacion: DateTime.parse(json["fecha_modificacion"]),
        fechaCreacion: DateTime.parse(json["fecha_creacion"]),
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        //DATOS 
        idUbicaion: json["id_ubicaion"],//
        nombreUbicacion: json["nombre_ubicacion"],
        idCategoria: json["id_categoria"],//
        categoria: json["categoria"],
        imagen: json["imagen"],
        idProducto: json["id_producto"],
        producto: json["producto"],
        fechaVencimiento: parseDateTime(json["fecha_vencimiento"]),
        tipoProducto: json["tipo_producto"],
        idProveedor: json["id_proveedor"],
        nombreEmpresaProveedor: json["nombre_empresa_proveedor"],
        cantidadEntrada: json["cantidad_entrada"] != null ? double.parse(json["cantidad_entrada"].toString()) : 0.0,
        cantidadSalida: json["cantidad_salida"] != null ? double.parse(json["cantidad_salida"].toString()) : 0.0,
        stock: json["stock"] != null ? double.parse(json["stock"].toString()) : 0.0,
        estadoFecha: json["estado_fecha"],
        estadoStock: json["estado_stock"],
        precioUnd: json["precio_und"] != null ? double.parse(json["precio_und"].toString()) : 0.0,
        unidMedida : json["unid_medida"]?? '',
        marcaProducto: json["marca_producto"] ?? '',
        descripcionUbicDetll: json["Descripcion_Ubic_detll"],
        documentUsoPreparacionReceta: json["document_uso_preparacion_receta"],
        precioUnidadSalidaGrupo: json["precio_unidad_salida_grupo"] != null ? double.parse(json["precio_unidad_salida_grupo"].toString()) : 0.0,
        unidMedidaSalida: json["unid_medida_salida"], 
       
         );
     }

    


    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "id_ubicaion": idUbicaion,
        "nombre_ubicacion": nombreUbicacion,
        "id_categoria": idCategoria,
        "categoria": categoria,
        "imagen": imagen,
        "id_producto": idProducto,
        "producto": producto,
        "fecha_vencimiento": fechaVencimiento,
        "tipo_producto": tipoProducto,
        "id_proveedor": idProveedor,
        "nombre_empresa_proveedor": nombreEmpresaProveedor,
        "cantidad_entrada": cantidadEntrada,
        "cantidad_salida": cantidadSalida,
        "stock": stock,
        "estado_fecha": estadoFecha,
        "estado_stock": estadoStock,
        "precio_und": precioUnd,
        "unid_medida": unidMedida,
        "marca_producto": marcaProducto,
        "Descripcion_Ubic_detll": descripcionUbicDetll,
        "document_uso_preparacion_receta": documentUsoPreparacionReceta,
        "precio_unidad_salida_grupo": precioUnidadSalidaGrupo,
        "unid_medida_salida": unidMedidaSalida,
        "fecha_modificacion": fechaModificacion,
        "fecha_creacion": fechaCreacion,
    };

}


