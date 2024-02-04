import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TProductosApp {
  static getProductoApp() async {
    final records = await pb.collection('productos_app').getFullList(
          sort: '-created',
        );
    return records;
  }

  static  postProductosApp(TProductosAppModel data) async {
    final record =
        await pb.collection('productos_app').create(body: data.toJson());
    return record;
  }

  static  putProductosApp({String? id, TProductosAppModel? data}) async {
    final record =
        await pb.collection('productos_app').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteProductosApp(String id) async {
    final record = await pb.collection('productos_app').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    // return pb.collection('productos_app').subscribe('*', (e) {
    //   print('REALTIME ${e.action}');
    //   print('REALTIME ${e.record}');
    // });
    return pb.realtime;
  }
}
