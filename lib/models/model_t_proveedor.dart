
class TProveedorModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String nombreContactoProveedor;
    String telefonoProveedor;
    String nombreEmpresaProveedor;
    String categoriaProvision;
    String razonSocial;
    String rucProveedor;
    String ciudadProveedor;
    String direccionProveedor;
    String detalleAtencionOtros;
    String correoProveedor;
    String numeroCuentaProveedor;
    String urlGoogleMaps;
    String imagenGps;

    TProveedorModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,
        required this.nombreContactoProveedor,
        required this.telefonoProveedor,
        required this.nombreEmpresaProveedor,
        required this.categoriaProvision,
        required this.razonSocial,
        required this.rucProveedor,
        required this.ciudadProveedor,
        required this.direccionProveedor,
        required this.detalleAtencionOtros,
        required this.correoProveedor,
        required this.numeroCuentaProveedor,
        required this.urlGoogleMaps,
        required this.imagenGps,
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
    factory TProveedorModel.fromJson(Map<String, dynamic> json) => TProveedorModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: json["created"],
        updated: json["updated"],
        nombreContactoProveedor: json["nombre_contacto_proveedor"],
        telefonoProveedor: json["telefono_proveedor"],
        nombreEmpresaProveedor: json["nombre_empresa_proveedor"],
        categoriaProvision: json["categoria_provision"],
        razonSocial: json["razon_social"],
        rucProveedor: json["ruc_proveedor"],
        ciudadProveedor: json["ciudad_proveedor"],
        direccionProveedor: json["direccion_proveedor"],
        detalleAtencionOtros: json["detalle_atencion_otros"],
        correoProveedor: json["correo_proveedor"],
        numeroCuentaProveedor: json["numero_cuenta_proveedor"],
        urlGoogleMaps: json["url_google_maps"],
        imagenGps: json["imagen_gps"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "nombre_contacto_proveedor": nombreContactoProveedor,
        "telefono_proveedor": telefonoProveedor,
        "nombre_empresa_proveedor": nombreEmpresaProveedor,
        "categoria_provision": categoriaProvision,
        "razon_social": razonSocial,
        "ruc_proveedor": rucProveedor,
        "ciudad_proveedor": ciudadProveedor,
        "direccion_proveedor": direccionProveedor,
        "detalle_atencion_otros": detalleAtencionOtros,
        "correo_proveedor": correoProveedor,
        "numero_cuenta_proveedor": numeroCuentaProveedor,
        "url_google_maps": urlGoogleMaps,
        "imagen_gps": imagenGps,
    };
}
