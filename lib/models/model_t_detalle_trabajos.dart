


import 'package:ausangate_op/utils/parse_fecha_nula.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';

class TDetalleTrabajoModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String codigoGrupo;
    String idRestriccionAlimentos;
    String idCantidadPaxguia;
    String idItinerariodiasnoches;
    String idTipogasto;
    DateTime fechaInicio;
    DateTime fechaFin;
    String descripcion;
    double costoAsociados;


    TDetalleTrabajoModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,
        required this.codigoGrupo,
        required this.idRestriccionAlimentos,
        required this.idCantidadPaxguia,
        required this.idItinerariodiasnoches,
        required this.idTipogasto,
        required this.fechaInicio,
        required this.fechaFin,
        required this.descripcion,
        required this.costoAsociados,
    });
   
    factory TDetalleTrabajoModel.fromJson(Map<String, dynamic> json) => TDetalleTrabajoModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        codigoGrupo: json["codigo_grupo"],
        idRestriccionAlimentos: json["id_restriccionAlimentos"],
        idCantidadPaxguia: json["id_cantidad_paxguia"],
        idItinerariodiasnoches: json["id_itinerariodiasnoches"],
        idTipogasto: json["id_tipogasto"],
        fechaInicio: parseDateTime(json["fecha_inicio"]),
        fechaFin:parseDateTime(json["fecha_fin"]),
        descripcion: json["descripcion"],
        costoAsociados: parseToDouble(json["costo_asociados"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,

        "codigo_grupo": codigoGrupo,
        "id_restriccionAlimentos": idRestriccionAlimentos,
        "id_cantidad_paxguia": idCantidadPaxguia,
        "id_itinerariodiasnoches": idItinerariodiasnoches,
        "id_tipogasto": idTipogasto,
        "fecha_inicio": fechaInicio.toIso8601String(),
        "fecha_fin": fechaFin.toIso8601String(),
        "descripcion": descripcion,
        "costo_asociados": costoAsociados,
    };
}

