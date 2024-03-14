
import 'package:ausangate_op/api/path_key_api.dart';
import 'package:ausangate_op/models/model_t_report_pasajero.dart';
import 'package:pocketbase/pocketbase.dart'; 

class TReportPasajero {
  static getTEmpleado() async {
    final records = await pb.collection('reporte_pasajeros').getFullList(
          sort: '-created',
        );
    return records;
  }

  static postEmpleadosApp(TReportPasajeroModel data) async {
    final record =
        await pb.collection('reporte_pasajeros').create(body: data.toJson());

    return record;
  }

  static putEmpleadosApp({String? id, TReportPasajeroModel? data}) async {
    final record = await pb
        .collection('reporte_pasajeros')
        .update(id!, body: data!.toJson());
    return record;
  }

  static Future deleteEmpleadosApp(String id) async {
    final record = await pb.collection('reporte_pasajeros').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}
