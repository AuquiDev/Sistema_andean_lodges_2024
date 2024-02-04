
import 'package:ausangate_op/models/model_t_detitinerario.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TItinerario {
  static getItinerarioPk() async {
    final records = await pb.collection('itinerario_grupos').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postitinerarioApp(TItinerarioModel data) async {
    final record =
        await pb.collection('itinerario_grupos').create(body: data.toJson());

    return record;
  }

  static  putItinerarioApp({String? id, TItinerarioModel? data}) async {
    final record =
        await pb.collection('itinerario_grupos').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteItinerarioApp(String id) async {
    final record = await pb.collection('itinerario_grupos').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}