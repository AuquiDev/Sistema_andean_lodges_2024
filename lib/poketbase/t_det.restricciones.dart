// TRestricciones



import 'package:ausangate_op/models/model_t_detrestricciones.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TRestricciones {
  static getRestriccionesPk() async {
    final records = await pb.collection('restricciones_alimenticias').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postRestriccionesPK(TRestriccionesModel data) async {
    final record =
        await pb.collection('restricciones_alimenticias').create(body: data.toJson());

    return record;
  }

  static  putRestriccionespK({String? id, TRestriccionesModel? data}) async {
    final record =
        await pb.collection('restricciones_alimenticias').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteRestriccionesPk(String id) async {
    final record = await pb.collection('restricciones_alimenticias').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}