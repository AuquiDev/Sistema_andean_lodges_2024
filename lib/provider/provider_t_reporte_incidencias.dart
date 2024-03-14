// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:ausangate_op/api/path_key_api.dart';
import 'package:ausangate_op/models/model_t_reporte_incidencias.dart';
import 'package:ausangate_op/poketbase/t_reporte_incidencias.dart';
import 'package:pocketbase/pocketbase.dart';

class TReporteIncidenciasProvider with ChangeNotifier {
  List<TReporteIncidenciasModel> listaIncidencias = [];

  TReporteIncidenciasProvider() {
    print('TReporteIncidencias Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TReporteIncidenciasModel> get e => listaIncidencias;

  void addAsistencia(TReporteIncidenciasModel e) {
    listaIncidencias.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TReporteIncidenciasModel e) {
    listaIncidencias[listaIncidencias.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TReporteIncidenciasModel e) {
    listaIncidencias.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TReporteIncidencias.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TReporteIncidenciasModel ubicaciones =  TReporteIncidenciasModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? idEmpleados,String? idTrabajo, String? pregunta1,
  String? pregunta2, String? pregunta3, String? pregunta4, String? pregunta5, String? pregunta6,String? pregunta7  }) async {
    isSyncing = true;
    notifyListeners();
    TReporteIncidenciasModel data = TReporteIncidenciasModel(
        id: '',
        idEmpleados: idEmpleados!,
        idTrabajo: idTrabajo!,
        pregunta1: pregunta1!,
        pregunta2:pregunta2!,
        pregunta3:pregunta3!,
        pregunta4:pregunta4!,
        pregunta5:pregunta5!,
        pregunta6:pregunta6!,
        pregunta7:pregunta7!
        );

    await TReporteIncidencias.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {String? id, String? idEmpleados,String? idTrabajo, String? pregunta1,
  String? pregunta2, String? pregunta3, String? pregunta4, String? pregunta5, String? pregunta6,String? pregunta7  }) async {
    isSyncing = true;
    notifyListeners();
    TReporteIncidenciasModel data = TReporteIncidenciasModel(
        id: id!,
         idEmpleados: idEmpleados!,
        idTrabajo: idTrabajo!,
        pregunta1: pregunta1!,
        pregunta2:pregunta2!,
        pregunta3:pregunta3!,
        pregunta4:pregunta4!,
        pregunta5:pregunta5!,
        pregunta6:pregunta6!,
        pregunta7:pregunta7!);

    await TReporteIncidencias.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TReporteIncidencias.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TReporteIncidenciasModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idEmpleados: e.idEmpleados,
        idTrabajo: e.idTrabajo,
        pregunta1: e.pregunta1,
        pregunta2:e.pregunta2,
        pregunta3:e.pregunta3,
        pregunta4:e.pregunta4,
        pregunta5:e.pregunta5,
        pregunta6:e.pregunta6,
        pregunta7:e.pregunta7
       
      );
      print('POST ASISTENCIA API ${e.idEmpleados} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
         idEmpleados: e.idEmpleados,
        idTrabajo: e.idTrabajo,
        pregunta1: e.pregunta1,
        pregunta2:e.pregunta2,
        pregunta3:e.pregunta3,
        pregunta4:e.pregunta4,
        pregunta5:e.pregunta5,
        pregunta6:e.pregunta6,
        pregunta7:e.pregunta7
      );
      print('PUT ASISTENCIA API ${e.idEmpleados} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('reporte_incidencias').subscribe('*', (e) {
      print('REALTIME Reporte de Incidencias ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TReporteIncidenciasModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TReporteIncidenciasModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TReporteIncidenciasModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
