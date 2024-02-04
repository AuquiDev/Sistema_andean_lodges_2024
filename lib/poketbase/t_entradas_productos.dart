
import 'package:ausangate_op/models/model_t_entradas.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';



class TEntradas {
  static getEntradas() async {
    final records = await pb.collection('productos_entradas').getFullList(
          sort: '-created',
        );
    return records;
  }

  static  postEntradasApp(TEntradasModel data) async {
    final record =
        await pb.collection('productos_entradas').create(body: data.toJson());

    return record;
  }

  static  putEntradasApp({String? id, TEntradasModel? data}) async {
    final record =
        await pb.collection('productos_entradas').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteEntradasApp(String id) async {
    final record = await pb.collection('productos_entradas').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}
