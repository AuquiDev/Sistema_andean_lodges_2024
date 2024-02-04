// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_t_salidas.dart';
import 'package:ausangate_op/poketbase/t_salidas_productos.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TSalidasAppProvider with ChangeNotifier {
  List<TSalidasAppModel> listSalidas = [];
 
  TSalidasAppProvider() {
    print('Tabla Salidas inicilizado.');
    getSalidasAPP();
    realtime();
  }
  //SET y GETTER
  List<TSalidasAppModel> get e => listSalidas;

  void addTsalidas(TSalidasAppModel e) {
    listSalidas.add(e);
    notifyListeners();
  }

  void updateTsalidas(TSalidasAppModel e) {
    listSalidas[listSalidas.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTSalidas(TSalidasAppModel e) {
    listSalidas.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  //__________________________
  getSalidasAPP() async {
    List<RecordModel> response = await TSalidasApp.getSalidasApp();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TSalidasAppModel productos = TSalidasAppModel.fromJson(e.data);
      addTsalidas(productos);
    }).toList();
   
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postSalidasProvider( {String? id, String? idProducto,String? idEmpleado, String? idTrabajo,
  double? cantidadSalida,String? descripcionSalida, String? idProveedor}) async {
    isSyncing = true;
    notifyListeners();
    TSalidasAppModel data = TSalidasAppModel(
        id: '',
        idProducto: idProducto!,
        idEmpleado: idEmpleado!,
        idTrabajo: idTrabajo!,
        cantidadSalida: cantidadSalida!,
        descripcionSalida: descripcionSalida!,
        idProveedor:'');
    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
    await TSalidasApp.postSalidasApp(data);
  }

  updateSalidasProvider({String? id, String? idProducto,String? idEmpleado, String? idTrabajo,
  double? cantidadSalida,String? descripcionSalida, String? idProveedor}) async {
    isSyncing = true;
    notifyListeners();
   TSalidasAppModel data = TSalidasAppModel(
        id: id!,
        idProducto: idProducto!,
        idEmpleado: idEmpleado!,
        idTrabajo: idTrabajo!,
        cantidadSalida: cantidadSalida!,
        descripcionSalida: descripcionSalida!,
        idProveedor:'');
    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
    await TSalidasApp.putSalidasApp(id: id, data: data);
  }

  deleteTSalidasApp(String id) async {
    await TSalidasApp.deleteSalidasApp(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('productos_salida').subscribe('*', (e) {
      print('REALTIME SALIDAS ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
           e.record!.data["collectionId"] = e.record!.collectionId;
        e.record!.data["collectionName"] = e.record!.collectionName;
          addTsalidas(TSalidasAppModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
           e.record!.data["collectionId"] = e.record!.collectionId;
        e.record!.data["collectionName"] = e.record!.collectionName;
          updateTsalidas(TSalidasAppModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
           e.record!.data["collectionId"] = e.record!.collectionId;
        e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTSalidas(TSalidasAppModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
