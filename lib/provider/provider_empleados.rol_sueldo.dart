// TRolesSueldoModel

// ignore_for_file: avoid_print

import 'package:ausangate_op/api/path_key_api.dart';
import 'package:ausangate_op/models/model_t_empleado.rolessueldo.dart';
import 'package:ausangate_op/poketbase/t_roles_sueldo.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TRolesSueldoProvider with ChangeNotifier {
  List<TRolesSueldoModel> listRolesSueldo = [];

  TRolesSueldoProvider() {
    print('Roles Sueldo Inicializado');
    getTRolesSueldoProvider();
    realtime();
  }

  //SET Y GET
  List<TRolesSueldoModel> get e => listRolesSueldo;

  void addtRolesSueldo(TRolesSueldoModel e) {
    listRolesSueldo.add(e);
    notifyListeners();
  }

  void updateTRolesSueldo(TRolesSueldoModel e) {
    listRolesSueldo[listRolesSueldo.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTRolesSueldo(TRolesSueldoModel e) {
    listRolesSueldo.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTRolesSueldoProvider() async {
    List<RecordModel> response = await TRolesSueldo.getRolesSueldoApp();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TRolesSueldoModel ubicaciones =  TRolesSueldoModel.fromJson(e.data);
      addtRolesSueldo(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTRolesSueldoProvider( {String? id, String? cargoPuesto,double? sueldoBase,String? tipoCalculoSueldo, String? tipoMoneda}) async {
    isSyncing = true;
    notifyListeners();
    TRolesSueldoModel data = TRolesSueldoModel(
        id: '',
        cargoPuesto: cargoPuesto!,
        sueldoBase: sueldoBase!,
        tipoCalculoSueldo: tipoCalculoSueldo!,
        tipoMoneda: tipoMoneda!
        );

    await TRolesSueldo.postRolesSueldoApp(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTRolesSueldoProvider({String? id, String? cargoPuesto,double? sueldoBase,String? tipoCalculoSueldo, String? tipoMoneda}) async {
    isSyncing = true;
    notifyListeners();
    TRolesSueldoModel data = TRolesSueldoModel(
        id: '',
        cargoPuesto: cargoPuesto!,
        sueldoBase: sueldoBase!,
        tipoCalculoSueldo: tipoCalculoSueldo!,
        tipoMoneda: tipoMoneda!
        );
    await TRolesSueldo.putRolesSueldoApp(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTRolesSueldoProvider(String id) async {
    await TRolesSueldo.deleteRolesSueldoApp(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('rolesSueldo_Empleados').subscribe('*', (e) {
      print('REALTIME RolesSueldo ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addtRolesSueldo(TRolesSueldoModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTRolesSueldo(TRolesSueldoModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTRolesSueldo(TRolesSueldoModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
