
import 'package:ausangate_op/models/model_t_reporte_incidencias.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TReporteIncidencias {
  static getAsitenciaPk() async {
    final records = await pb.collection('reporte_incidencias').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk(TReporteIncidenciasModel data) async {
    final record =
        await pb.collection('reporte_incidencias').create(body: data.toJson());

    return record;
  }

  static  putAsitneciaPk({String? id, TReporteIncidenciasModel? data}) async {
    final record =
        await pb.collection('reporte_incidencias').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('reporte_incidencias').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}