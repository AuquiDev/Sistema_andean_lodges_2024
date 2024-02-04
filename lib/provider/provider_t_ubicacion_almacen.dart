// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_t_ubicacion_almacen.dart';
import 'package:ausangate_op/poketbase/t_ubicacion_almacen.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TUbicacionAlmacenProvider with ChangeNotifier {
  List<TUbicacionAlmacenModel> listUbicacion = [];

  TUbicacionAlmacenProvider() {
    print('Ubicacion Inicializado');
    getTUbicacionApp();
    realtime();
  }

  //SET Y GET
  List<TUbicacionAlmacenModel> get e => listUbicacion;

  void addtubicacion(TUbicacionAlmacenModel e) {
    listUbicacion.add(e);
    notifyListeners();
  }

  void updateTUbicaciones(TUbicacionAlmacenModel e) {
    listUbicacion[listUbicacion.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTUbicaciones(TUbicacionAlmacenModel e) {
    listUbicacion.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTUbicacionApp() async {
    List<RecordModel> response = await TUbicacionAlmacen.getUbicacionAlmacen();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TUbicacionAlmacenModel ubicaciones =  TUbicacionAlmacenModel.fromJson(e.data);
      addtubicacion(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTUbicacionesProvider( {String? id, String? nombreUbicacion,String? descripcionUbicacion}) async {
    isSyncing = true;
    notifyListeners();
    TUbicacionAlmacenModel data = TUbicacionAlmacenModel(
        id: '',
        nombreUbicacion: nombreUbicacion!,
        descripcionUbicacion: descripcionUbicacion!);

    await TUbicacionAlmacen.postUbicacionApp(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTUbicacionesProvider({String? id, String? nombreUbicacion, String? descripcionUbicacion}) async {
    isSyncing = true;
    notifyListeners();
    TUbicacionAlmacenModel data = TUbicacionAlmacenModel(
        id: id!,
        nombreUbicacion: nombreUbicacion!,
        descripcionUbicacion: descripcionUbicacion!);
    await TUbicacionAlmacen.putUbicacionApp(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTUbicacionesApp(String id) async {
    await TUbicacionAlmacen.deleteUbicacionApp(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ubicacion_almacen').subscribe('*', (e) {
      print('REALTIME Ubicaicon ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addtubicacion(TUbicacionAlmacenModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTUbicaciones(TUbicacionAlmacenModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTUbicaciones(TUbicacionAlmacenModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
