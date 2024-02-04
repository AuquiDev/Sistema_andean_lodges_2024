
import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/poketbase/t_detalle_trabajo.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TDetalleTrabajoProvider with ChangeNotifier {
  List<TDetalleTrabajoModel> listaDetallTrabajo = [];

  TDetalleTrabajoProvider() {
    print('Tabla Detalle Trabajo inicilizado.');
    getTDetalleTrabajo();
    realtime();
  }
  //SET y GETTER
  List<TDetalleTrabajoModel> get e => listaDetallTrabajo;

  void addTdetalleTrabajo(TDetalleTrabajoModel e) {
    listaDetallTrabajo.add(e);
    notifyListeners();
  }

  void updateTdetalleTrabajo(TDetalleTrabajoModel e) {
    listaDetallTrabajo[listaDetallTrabajo.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTdetalleTrabajo(TDetalleTrabajoModel e) {
    listaDetallTrabajo.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

   getTDetalleTrabajo() async {
     List<RecordModel> response = await TDetalleTrabajo.getDetalleTrabajoPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TDetalleTrabajoModel ubicaciones =  TDetalleTrabajoModel.fromJson(e.data);
      addTdetalleTrabajo(ubicaciones);
    }).toList();
    print(date);
    notifyListeners();
    return date;
  }


  //METODOS POST
  bool isSyncing = false;
  postTdetalleTrabajoProvider({String? id, String? codigoGrupo, String? idRestriccionAlimentos,
  String? idCantidadPaxguia, String? idItinerariodiasnoches, String? idTipogasto, 
  DateTime? fechaInicio, DateTime? fechaFin,String? descripcion, double? costoAsociados }) async {
    isSyncing = true;
    notifyListeners();
    TDetalleTrabajoModel data = TDetalleTrabajoModel(
        id: '',
        codigoGrupo: codigoGrupo!,
        idRestriccionAlimentos: idRestriccionAlimentos!,
        idCantidadPaxguia: idCantidadPaxguia!,
        idTipogasto: idTipogasto!,
        idItinerariodiasnoches: idItinerariodiasnoches!,
        fechaInicio: fechaInicio!,
        fechaFin: fechaFin!,
        descripcion: descripcion!,
        costoAsociados: costoAsociados!
        );
    await TDetalleTrabajo.postDetalleTrabajoApp(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTdetalleTrabajoProvider({String? id, String? codigoGrupo, String? idRestriccionAlimentos,
  String? idCantidadPaxguia, String? idItinerariodiasnoches, String? idTipogasto, 
  DateTime? fechaInicio, DateTime? fechaFin,String? descripcion, double? costoAsociados }) async {
    isSyncing = true;
    notifyListeners();
    TDetalleTrabajoModel data = TDetalleTrabajoModel(
        id: '',
        codigoGrupo: codigoGrupo!,
        idRestriccionAlimentos: idRestriccionAlimentos!,
        idCantidadPaxguia: idCantidadPaxguia!,
        idTipogasto: idTipogasto!,
        idItinerariodiasnoches: idItinerariodiasnoches!,
        fechaInicio: fechaInicio!,
        fechaFin: fechaFin!,
        descripcion: descripcion!,
        costoAsociados: costoAsociados!
        );
    await TDetalleTrabajo.putDetalleTrabajoApp(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTdetalleTrabajoProvider(String id) async {
    await TDetalleTrabajo.deleteDetalleTrabajoApp(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('detalleTrabajos_empleados').subscribe('*', (e) {
      print('REALTIME Trabajo ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addTdetalleTrabajo(TDetalleTrabajoModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTdetalleTrabajo(TDetalleTrabajoModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTdetalleTrabajo(TDetalleTrabajoModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
