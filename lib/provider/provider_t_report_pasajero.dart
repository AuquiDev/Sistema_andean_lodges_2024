// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ausangate_op/api/path_key_api.dart';
import 'package:ausangate_op/models/model_t_report_pasajero.dart';
import 'package:ausangate_op/poketbase/t_report_pasajero.dart';
import 'package:pocketbase/pocketbase.dart';

class TReportPasajeroProvider with ChangeNotifier {
  List<TReportPasajeroModel> listReporttPasajero = [];

  TReportPasajeroProvider() {
    print('Reporte Pax inicilizado.');
    getTReportPsajeroProvider();
    realtime();
  }
  //SET y GETTER
  List<TReportPasajeroModel> get e => listReporttPasajero;

  void addReport(TReportPasajeroModel e) {
    listReporttPasajero.add(e);
    notifyListeners();
  }

  void updateTreport(TReportPasajeroModel e) {
    listReporttPasajero[listReporttPasajero.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTReport(TReportPasajeroModel e) {
    listReporttPasajero.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTReportPsajeroProvider() async {
    List<RecordModel> response = await TReportPasajero.getTEmpleado();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TReportPasajeroModel productos = TReportPasajeroModel.fromJson(e.data);
      addReport(productos);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postReportePasajeroProvider(
      {String? id,
      bool? idioma,
      String? idTrabajo,
      String? nombrePasajero,
      String? gmail,

      String? pregunta1,
      String? pregunta2,
      String? pregunta3,
      String? pregunta4,
      String? pregunta5,
      String? pregunta6,
      String? pregunta7,
      String? pregunta8,
      String? pregunta9,
      String? pregunta10,
      String? pregunta11,
      String? pregunta12,
      String? pregunta13,
      String? idEmpleados}) async {
    isSyncing = true;
    notifyListeners();
    TReportPasajeroModel data = TReportPasajeroModel(
        id: '',
        idioma: idioma!,
        idTrabajo: idTrabajo!,
        nombrePasajero: nombrePasajero!,
        gmail: gmail!,
        pregunta1: pregunta1!,
        pregunta2: pregunta2!,
        pregunta3: pregunta3!,
        pregunta4: pregunta4!,
        pregunta5: pregunta5!,
        pregunta6: pregunta6!,
        pregunta7: pregunta7!,
        pregunta8: pregunta8!,
        pregunta9: pregunta9!,
        pregunta10: pregunta10!,
        pregunta11: pregunta11!,
        pregunta12: pregunta12!,
        pregunta13: pregunta13!,
        idEmpleados: idEmpleados!
       );

    await TReportPasajero.postEmpleadosApp(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  putReportePasajeroProvider(
      {String? id,
      bool? idioma,
      String? idTrabajo,
      String? nombrePasajero,
      String? gmail,

      String? pregunta1,
      String? pregunta2,
      String? pregunta3,
      String? pregunta4,
      String? pregunta5,
      String? pregunta6,
      String? pregunta7,
      String? pregunta8,
      String? pregunta9,
      String? pregunta10,
      String? pregunta11,
      String? pregunta12,
      String? pregunta13,
      String? idEmpleados}) async {
    isSyncing = true;
    notifyListeners();
    TReportPasajeroModel data = TReportPasajeroModel(
        id: id,
         idioma: idioma!,
        idTrabajo: idTrabajo!,
        nombrePasajero: nombrePasajero!,
        gmail: gmail!,
        pregunta1: pregunta1!,
        pregunta2: pregunta2!,
        pregunta3: pregunta3!,
        pregunta4: pregunta4!,
        pregunta5: pregunta5!,
        pregunta6: pregunta6!,
        pregunta7: pregunta7!,
        pregunta8: pregunta8!,
        pregunta9: pregunta9!,
        pregunta10: pregunta10!,
        pregunta11: pregunta11!,
        pregunta12: pregunta12!,
        pregunta13: pregunta13!,
        idEmpleados: idEmpleados!);
    await TReportPasajero.putEmpleadosApp(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTEmpeladoProvider(String id) async {
    await TReportPasajero.deleteEmpleadosApp(id);
    notifyListeners();
  }

//METODO PARA POST O UPDATE
  Future<void> saveReportePasajero(TReportPasajeroModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postReportePasajeroProvider(
        id: '',
        idTrabajo: e.idTrabajo,
        idioma: e.idioma,
        nombrePasajero: e.nombrePasajero,
        gmail: e.gmail,
        pregunta1: e.pregunta1,
        pregunta2: e.pregunta2,
        pregunta3: e.pregunta3,
        pregunta4: e.pregunta4,
        pregunta5: e.pregunta5,
        pregunta6: e.pregunta6,
        pregunta7: e.pregunta7,
        pregunta8: e.pregunta8,
        pregunta9: e.pregunta9,
        pregunta10: e.pregunta10,
        pregunta11: e.pregunta11,
        pregunta12: e.pregunta12,
        pregunta13: e.pregunta13,
        idEmpleados: e.idEmpleados,
      );
      print('POST ASISTENCIA API ${e.nombrePasajero} ${e.id}');
    } else {
      await putReportePasajeroProvider(
        id: e.id,
       idTrabajo: e.idTrabajo,
        idioma: e.idioma,
        nombrePasajero: e.nombrePasajero,
        gmail: e.gmail,
        pregunta1: e.pregunta1,
        pregunta2: e.pregunta2,
        pregunta3: e.pregunta3,
        pregunta4: e.pregunta4,
        pregunta5: e.pregunta5,
        pregunta6: e.pregunta6,
        pregunta7: e.pregunta7,
        pregunta8: e.pregunta8,
        pregunta9: e.pregunta9,
        pregunta10: e.pregunta10,
        pregunta11: e.pregunta11,
        pregunta12: e.pregunta12,
        pregunta13: e.pregunta13,
        idEmpleados: e.idEmpleados,
      );
      print('PUT ASISTENCIA API ${e.nombrePasajero} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }


  Future<void> realtime() async {
    await pb.collection('reporte_pasajeros').subscribe('*', (e) {
      print('REALTIME Reporte PAsajeros ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addReport(TReportPasajeroModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTreport(TReportPasajeroModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTReport(TReportPasajeroModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
