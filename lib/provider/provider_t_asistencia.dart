// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:ausangate_op/models/model_t_asistencia.dart';
import 'package:ausangate_op/poketbase/t_asistencia.dart';
import 'package:pocketbase/pocketbase.dart';

class TAsistenciaProvider with ChangeNotifier {
  List<TAsistenciaModel> listAsistencia = [];

  TAsistenciaProvider() {
    print('Asistencia Inicializado');
    getTAsistenciaApp();
    // realtime();
  }

  //SET Y GET
  List<TAsistenciaModel> get e => listAsistencia;

  void addAsistencia(TAsistenciaModel e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TAsistenciaModel e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TAsistenciaModel e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TAsistencia.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TAsistenciaModel ubicaciones =  TAsistenciaModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? idEmpleados,String? idTrabajo, DateTime? horaEntrada,
  DateTime? horaSalida, String? nombrePersonal, String? actividadRol, String? detalles }) async {
    isSyncing = true;
    notifyListeners();
    TAsistenciaModel data = TAsistenciaModel(
        id: '',
        idEmpleados: idEmpleados!,
        idTrabajo: idTrabajo!,
        horaEntrada: horaEntrada!,
        horaSalida: horaSalida,
        nombrePersonal: nombrePersonal!,
        actividadRol: actividadRol!,
        detalles: detalles!
        );

    await TAsistencia.postAsistenciaPk(data);
    //AGREGAR LISTA TEMPORAL 
    addAsistencia(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {String? id, String? idEmpleados,String? idTrabajo, DateTime? horaEntrada,
  DateTime? horaSalida, String? nombrePersonal, String? actividadRol, String? detalles }) async {
    isSyncing = true;
    notifyListeners();
    TAsistenciaModel data = TAsistenciaModel(
        id: id!,
        idEmpleados: idEmpleados!,
        idTrabajo: idTrabajo!,
        horaEntrada: horaEntrada!,
        horaSalida: horaSalida!,
        nombrePersonal: nombrePersonal!,
        actividadRol: actividadRol!,
        detalles: detalles!);

    await TAsistencia.putAsitneciaPk(id: id, data: data);

   //AGREGAR LISTA TEMPORAL 
   updateTAsistencia(data);


    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TAsistencia.deleteAsistentciaPk(id);
    //DELETE LISTA TEMPORAL 
     listAsistencia.removeWhere((detalle) => detalle.id == id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TAsistenciaModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idEmpleados: e.idEmpleados,
        idTrabajo: e.idTrabajo,
        horaEntrada: e.horaEntrada,
        horaSalida: e.horaSalida,
        nombrePersonal: e.nombrePersonal,
        actividadRol: e.actividadRol,
        detalles: e.detalles,
      );
      print('POST ASISTENCIA API ${e.nombrePersonal} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        idEmpleados: e.idEmpleados,
        idTrabajo: e.idTrabajo,
        horaEntrada: e.horaEntrada,
        horaSalida: e.horaSalida,
        nombrePersonal: e.nombrePersonal,
        actividadRol: e.actividadRol,
        detalles: e.detalles,
      );
      print('PUT ASISTENCIA API ${e.nombrePersonal} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  // Future<void> realtime() async {
  //   await pb.collection('asistencia_empleados').subscribe('*', (e) {
  //     print('REALTIME Asistencia ${e.action}');

  //     switch (e.action) {
  //       case 'create':
  //         e.record!.data['id'] = e.record!.id;
  //         e.record!.data['created'] = DateTime.parse(e.record!.created);
  //         e.record!.data['updated'] = DateTime.parse(e.record!.updated);
  //         e.record!.data["collectionId"] = e.record!.collectionId;
  //         e.record!.data["collectionName"] = e.record!.collectionName;
  //         addAsistencia(TAsistenciaModel.fromJson(e.record!.data));
  //         break;
  //       case 'update':
  //         e.record!.data['id'] = e.record!.id;
  //         e.record!.data['created'] = DateTime.parse(e.record!.created);
  //         e.record!.data['updated'] = DateTime.parse(e.record!.updated);
  //         e.record!.data["collectionId"] = e.record!.collectionId;
  //         e.record!.data["collectionName"] = e.record!.collectionName;
  //         updateTAsistencia(TAsistenciaModel.fromJson(e.record!.data));
  //         break;
  //       case 'delete':
  //         e.record!.data['id'] = e.record!.id;
  //         e.record!.data['created'] = DateTime.parse(e.record!.created);
  //         e.record!.data['updated'] = DateTime.parse(e.record!.updated);
  //         e.record!.data["collectionId"] = e.record!.collectionId;
  //         e.record!.data["collectionName"] = e.record!.collectionName;
  //         deleteTAsistencia(TAsistenciaModel.fromJson(e.record!.data));
  //         break;
  //       default:
  //     }
  //   });
  // }
}
