// ignore_for_file: avoid_print

import 'package:ausangate_op/api/path_key_api.dart';
import 'package:ausangate_op/models/model_t_detitinerario.dart';
import 'package:ausangate_op/poketbase/t_det.itinerario_grupo.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TItinerarioProvider with ChangeNotifier {
  List<TItinerarioModel> listItinerario = [];

  TItinerarioProvider() {
    print('Ubicacion Inicializado');
    getTItinerarioApp();
    realtime();
  }

  //SET Y GET
  List<TItinerarioModel> get e => listItinerario;

  void addItinerario(TItinerarioModel e) {
    listItinerario.add(e);
    notifyListeners();
  }

  void updateTItinerario(TItinerarioModel e) {
    listItinerario[listItinerario.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTItinerario(TItinerarioModel e) {
    listItinerario.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTItinerarioApp() async {
    List<RecordModel> response = await TItinerario.getItinerarioPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TItinerarioModel ubicaciones =  TItinerarioModel.fromJson(e.data);
      addItinerario(ubicaciones);
    }).toList();
    print(date);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTItinerarioProvider( {String? id, String? diasNoches,String? descripcion}) async {
    isSyncing = true;
    notifyListeners();
    TItinerarioModel data = TItinerarioModel(
        id: '',
        diasNoches: diasNoches!,
        descripcion: descripcion!);

    await TItinerario.postitinerarioApp(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTItinerarioProvider( {String? id, String? diasNoches,String? descripcion}) async {
    isSyncing = true;
    notifyListeners();
    TItinerarioModel data = TItinerarioModel(
        id: id,
        diasNoches: diasNoches!,
        descripcion: descripcion!);
    await TItinerario.putItinerarioApp(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTItinerarioProvider(String id) async {
    await TItinerario.deleteItinerarioApp(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('itinerario_grupos').subscribe('*', (e) {
      print('REALTIME Itinerario ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addItinerario(TItinerarioModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTItinerario(TItinerarioModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTItinerario(TItinerarioModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
