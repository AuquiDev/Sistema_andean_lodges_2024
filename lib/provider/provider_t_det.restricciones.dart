// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_t_detrestricciones.dart';
import 'package:ausangate_op/poketbase/t_det.restricciones.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TRestriccionesProvider with ChangeNotifier {
  List<TRestriccionesModel> listaRestricciones = [];

  TRestriccionesProvider() {
    print('Restricciones Inicializado');
    getTRestriccionesApp();
    realtime();
  }

  //SET Y GET
  List<TRestriccionesModel> get e => listaRestricciones;

  void addIRestricciones(TRestriccionesModel e) {
    listaRestricciones.add(e);
    notifyListeners();
  }

  void updateTRestricciones(TRestriccionesModel e) {
    listaRestricciones[listaRestricciones.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTRestricciones(TRestriccionesModel e) {
    listaRestricciones.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTRestriccionesApp() async {
    List<RecordModel> response = await TRestricciones.getRestriccionesPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TRestriccionesModel ubicaciones =  TRestriccionesModel.fromJson(e.data);
      addIRestricciones(ubicaciones);
    }).toList();
    print(date);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTRestriccionesProvider( {String? id, String? nombreRestriccion,String? descripcion}) async {
    isSyncing = true;
    notifyListeners();
    TRestriccionesModel data = TRestriccionesModel(
        id: '',
        nombreRestriccion: nombreRestriccion!,
        descripcion: descripcion!);

    await TRestricciones.postRestriccionesPK(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTRestriccionesProvider( {String? id, String? nombreRestriccion,String? descripcion}) async {
    isSyncing = true;
    notifyListeners();
    TRestriccionesModel data = TRestriccionesModel(
        id: id,
        nombreRestriccion: nombreRestriccion!,
        descripcion: descripcion!);
    await TRestricciones.putRestriccionespK(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTRestriccionesProvider(String id) async {
    await TRestricciones.deleteRestriccionesPk(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('restricciones_alimenticias').subscribe('*', (e) {
      print('REALTIME Restricciones ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addIRestricciones(TRestriccionesModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTRestricciones(TRestriccionesModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTRestricciones(TRestriccionesModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
