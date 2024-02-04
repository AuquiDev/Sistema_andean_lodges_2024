// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_t_dettipo_gasto.dart';
import 'package:ausangate_op/poketbase/t_det.tipo_gasto.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TTipoGastoProvider with ChangeNotifier {
  List<TTipoGastoModel> listTipogasto = [];

  TTipoGastoProvider() {
    print('Tip Gasto Inicializado');
    getTTipoGastoApp();
    realtime();
  }

  //SET Y GET
  List<TTipoGastoModel> get e => listTipogasto;

  void addITipoGasto(TTipoGastoModel e) {
    listTipogasto.add(e);
    notifyListeners();
  }

  void updateTTipoGasto(TTipoGastoModel e) {
    listTipogasto[listTipogasto.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTTipoGasto(TTipoGastoModel e) {
    listTipogasto.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTTipoGastoApp() async {
    List<RecordModel> response = await TTipoGasto.getTipoGastoPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TTipoGastoModel ubicaciones =  TTipoGastoModel.fromJson(e.data);
      addITipoGasto(ubicaciones);
    }).toList();
    print(date);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTTipoGastoProvider( {String? id, String? nombreGasto,String? descripcion}) async {
    isSyncing = true;
    notifyListeners();
    TTipoGastoModel data = TTipoGastoModel(
        id: '',
        nombreGasto: nombreGasto!,
        descripcion: descripcion!);

    await TTipoGasto.postTipoGastoApp(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTTipoGastoProvider( {String? id, String? nombreGasto,String? descripcion}) async {
    isSyncing = true;
    notifyListeners();
    TTipoGastoModel data = TTipoGastoModel(
        id: id,
        nombreGasto: nombreGasto!,
        descripcion: descripcion!);
    await TTipoGasto.putTipoGastoApp(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTTipoGastoProvider(String id) async {
    await TTipoGasto.deleteTipoGastoApp(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('Tipo_de_gasto').subscribe('*', (e) {
      print('REALTIME TipoGasto ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addITipoGasto(TTipoGastoModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTTipoGasto(TTipoGastoModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTTipoGasto(TTipoGastoModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
