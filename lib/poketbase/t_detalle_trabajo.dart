


import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TDetalleTrabajo {
  static getDetalleTrabajoPk() async {
    final records = await pb.collection('detalleTrabajos_empleados').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postDetalleTrabajoApp(TDetalleTrabajoModel data) async {
    final record =
        await pb.collection('detalleTrabajos_empleados').create(body: data.toJson());

    return record;
  }

  static  putDetalleTrabajoApp({String? id, TDetalleTrabajoModel? data}) async {
    final record =
        await pb.collection('detalleTrabajos_empleados').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteDetalleTrabajoApp(String id) async {
    final record = await pb.collection('detalleTrabajos_empleados').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}