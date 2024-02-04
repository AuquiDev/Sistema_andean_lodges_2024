
import 'package:ausangate_op/models/model_t_detcand_pax_guia.dart';
import 'package:ausangate_op/poketbase/t_detcand_paxguia.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TCantidadPaxGuiaProvider with ChangeNotifier {
  List<TCantidadPaxGuiaModel> listapaxguias = [];

  TCantidadPaxGuiaProvider() {
    print('Tabla Detalle Trabajo inicilizado.');
    getTCantidadPaxGuia();
    realtime();
  }
  //SET y GETTER
  List<TCantidadPaxGuiaModel> get e => listapaxguias;

  void addCantidadPaxGuia(TCantidadPaxGuiaModel e) {
    listapaxguias.add(e);
    notifyListeners();
  }

  void updateTCantidadPaxGuia(TCantidadPaxGuiaModel e) {
    listapaxguias[listapaxguias.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTCantidadPaxGuia(TCantidadPaxGuiaModel e) {
    listapaxguias.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

   getTCantidadPaxGuia() async {
     List<RecordModel> response = await TCantidadPaxGuia.getTCantidadPaxGuiaPK();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TCantidadPaxGuiaModel cantiPaxGuia =  TCantidadPaxGuiaModel.fromJson(e.data);
      addCantidadPaxGuia(cantiPaxGuia);
    }).toList();
    print(date);
    notifyListeners();
    return date;
  }


  //METODOS POST
  bool isSyncing = false;
  postTCantidadPaxGuiaProvider({String? id, String? pax, String? guia, String? descripcion }) async {
    isSyncing = true;
    notifyListeners();
    TCantidadPaxGuiaModel data = TCantidadPaxGuiaModel(
        id: '',
        pax: pax!,
        guia: guia!,
        descripcion: descripcion!,
        );
    await TCantidadPaxGuia.postTCantidadPaxGuiaPK(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTCantidadPaxGuiaProvider({String? id, String? pax, String? guia, String? descripcion }) async {
    isSyncing = true;
    notifyListeners();
    TCantidadPaxGuiaModel data = TCantidadPaxGuiaModel(
        id: id,
        pax: pax!,
        guia: guia!,
        descripcion: descripcion!,
        );
    await TCantidadPaxGuia.putTCantidadPaxGuiaPK(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTCantidadPaxGuiaProvider(String id) async {
    await TCantidadPaxGuia.deleteTCantidadPaxGuiaPk(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('cantidad_pasajeros_guia').subscribe('*', (e) {
      print('REALTIME Trabajo ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addCantidadPaxGuia(TCantidadPaxGuiaModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTCantidadPaxGuia(TCantidadPaxGuiaModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTCantidadPaxGuia(TCantidadPaxGuiaModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
