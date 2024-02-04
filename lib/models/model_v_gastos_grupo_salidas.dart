

import 'package:ausangate_op/utils/parse_fecha_nula.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';

class ViewGastosGrupoSalidasModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime fechaInicio;
    DateTime fechaFin;
    double cantidadDias;
    String categoriaOTipoDeTrabajo;
    String codigoGrupo;
    String idCodigoGrupo;
    String grupo;
    double montoTotalInversion;
    String descripcion;
    DateTime fcreated;
    DateTime fupdated;

    ViewGastosGrupoSalidasModel({
        required this.id,
        required this.collectionId,
        required this.collectionName,
        required this.fechaInicio,
        required this.fechaFin,
        required this.cantidadDias,
        required this.categoriaOTipoDeTrabajo,
        required this.codigoGrupo,
        required this.idCodigoGrupo,
        required this.grupo,
        required this.montoTotalInversion,
        required this.descripcion,
        required this.fcreated,
        required this.fupdated,
    });
      set setId(String value) {
        id = value;
      }
      set setCollectionId(String value) {
        collectionId = value;
      }

      set setCollectionName(String value) {
        collectionName = value;
      }
    factory ViewGastosGrupoSalidasModel.fromJson(Map<String, dynamic> json) => 
    ViewGastosGrupoSalidasModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        fechaInicio: parseDateTime(json["fecha_inicio"]),
        fechaFin: parseDateTime(json["fecha_fin"]),
        cantidadDias: parseToDouble(json["cantidad_dias"]),
        categoriaOTipoDeTrabajo: json["Categoria_o_tipo_de_trabajo"],
        codigoGrupo: json["codigo_grupo"],
        idCodigoGrupo: json["id_codigoGrupo"],
        grupo: json["grupo"]?? '',
        montoTotalInversion: json["monto_total_Inversion"].toDouble(),
        descripcion: json["descripcion"],
        fcreated: DateTime.parse(json["fcreated"]),
        fupdated: DateTime.parse(json["fupdated"]),
    );
    
    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFin,
        "cantidad_dias": cantidadDias,
        "Categoria_o_tipo_de_trabajo": categoriaOTipoDeTrabajo,
        "codigo_grupo": codigoGrupo,
        "id_codigoGrupo": idCodigoGrupo,
        "grupo": grupo,
        "monto_total_Inversion": montoTotalInversion,
        "descripcion": descripcion,
        "fcreated": fcreated,
        "fupdated": fupdated,
    };
}
