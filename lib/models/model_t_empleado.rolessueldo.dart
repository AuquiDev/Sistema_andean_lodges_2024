


import 'package:ausangate_op/utils/parse_string_a_double.dart';

class TRolesSueldoModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String cargoPuesto;
    double sueldoBase;
    String tipoCalculoSueldo;
    String tipoMoneda;

    TRolesSueldoModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,
        required this.cargoPuesto,
        required this.sueldoBase,
        required this.tipoCalculoSueldo,
        required this.tipoMoneda,
    });

    factory TRolesSueldoModel.fromJson(Map<String, dynamic> json) => TRolesSueldoModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        cargoPuesto: json["cargo_puesto"],
        sueldoBase: parseToDouble(json["sueldo_base"]),
        tipoCalculoSueldo: json["tipo_calculo_sueldo"],
        tipoMoneda: json["tipo_moneda"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,
        "cargo_puesto": cargoPuesto,
        "sueldo_base": sueldoBase,
        "tipo_calculo_sueldo": tipoCalculoSueldo,
        "tipo_moneda": tipoMoneda,
    };
}
