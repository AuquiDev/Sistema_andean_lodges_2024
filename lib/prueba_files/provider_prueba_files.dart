// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ausangate_op/models/model_t_asistencia.dart';
import 'package:ausangate_op/poketbase/t_asistencia.dart';
import 'package:ausangate_op/prueba_files/model_prueba_files.dart';
import 'package:ausangate_op/prueba_files/services_prueba_files.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TPruebaFileProvider with ChangeNotifier {
  List<TPruebaFilesModel> listaPrueba = [];

  TPruebaFileProvider() {
    print('Asistencia Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TPruebaFilesModel> get e => listaPrueba;

  void addAsistencia(TPruebaFilesModel e) {
    listaPrueba.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TPruebaFilesModel e) {
    listaPrueba[listaPrueba.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TPruebaFilesModel e) {
    listaPrueba.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TPruebaFile.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TPruebaFilesModel ubicaciones = TPruebaFilesModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider({ String? id, String? idEmpleados, String? idTrabajo,
    List<TAsistenciaModel>? listaprueba, File? imagenFile,List<File>? listaImagenes, }) async {
    isSyncing = true;
    notifyListeners();

    TPruebaFilesModel data = TPruebaFilesModel(
      id: '',
      idEmpleados: idEmpleados!,
      idTrabajo: idTrabajo!,
      listaprueba: listaprueba!,
    );
    print('PROVIER TAsistenciaModel: ${listaprueba.length}');
    await TPruebaFile.postAsistenciaPk(
        data: data, imagenFile: imagenFile, listaImagenes: listaImagenes);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider(  {String? id,String? idEmpleados,String? idTrabajo,
      File? imagenFile,List<File>? listaImagenes, 
      List<TAsistenciaModel>? listaprueba}) async {
    isSyncing = true;
    notifyListeners();
    TPruebaFilesModel data = TPruebaFilesModel(
      id: id,
      idEmpleados: idEmpleados!,
      idTrabajo: idTrabajo!,
      listaprueba: listaprueba!,
    );

    await TPruebaFile.putAsitneciaPk(id: id, data: data, imagenFile: imagenFile,listaImagenes: listaImagenes );

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TAsistencia.deleteAsistentciaPk(id);
    notifyListeners();
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TPruebaFilesModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idEmpleados: e.idEmpleados,
        idTrabajo: e.idTrabajo,
        listaprueba: e.listaprueba,
      );
      print('POST ASISTENCIA API ${e.listaprueba} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        idEmpleados: e.idEmpleados,
        idTrabajo: e.idTrabajo,
        listaprueba: e.listaprueba,
      );
      print('PUT ASISTENCIA API ${e.listaprueba} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('reporte_guia').subscribe('*', (e) {
      print('REALTIME Prueba ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TPruebaFilesModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TPruebaFilesModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TPruebaFilesModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
