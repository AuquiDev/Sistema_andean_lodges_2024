


import 'package:ausangate_op/models/model_t_dettipo_gasto.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TTipoGasto {
  static getTipoGastoPk() async {
    final records = await pb.collection('Tipo_de_gasto').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postTipoGastoApp(TTipoGastoModel data) async {
    final record =
        await pb.collection('Tipo_de_gasto').create(body: data.toJson());

    return record;
  }

  static  putTipoGastoApp({String? id, TTipoGastoModel? data}) async {
    final record =
        await pb.collection('Tipo_de_gasto').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteTipoGastoApp(String id) async {
    final record = await pb.collection('Tipo_de_gasto').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}