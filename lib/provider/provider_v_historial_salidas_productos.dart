
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ausangate_op/models/model_v_historial_salidas_productos.dart';
import 'package:ausangate_op/poketbase/v_historial_salidas_productos.dart';

class ViewHistorialSalidasProductosProvider with ChangeNotifier {
  List<ViewHistorialSalidasProductosModel> listHistorialSalidas = [];

  ViewHistorialSalidasProductosProvider(){
    // ignore: avoid_print
    print('Historial salidas Inicializado');
    getViewHistorialSalidas();
  }

  List<ViewHistorialSalidasProductosModel> get e => listHistorialSalidas;

  void setHistorial(ViewHistorialSalidasProductosModel e) {
    listHistorialSalidas.add(e);
    notifyListeners();
  } 

  getViewHistorialSalidas()async {
    List<RecordModel> response = await ViewHistorialSalidasProductos.get_v_Hitorial_salidas_productos();
    for (var e in response) {
      var dataView = ViewHistorialSalidasProductosModel.fromJson(e.data);
      dataView.setId = e.id;
      dataView.setCollectionId = e.collectionId;
      dataView.setCollectionName = e.collectionName;
      setHistorial(dataView);
    }
    // print('DATA GETPROVIDER: $response');
    notifyListeners();
  }

  // Future<List<ViewHistorialSalidasProductosModel>> getViewHistorialSalidas() async {
  //    List<RecordModel> response = await ViewHistorialSalidasProductos.get_v_Hitorial_salidas_productos();
  //    List<ViewHistorialSalidasProductosModel> nuevosDatos = [];
  //    for (var e in response) {
  //     var dataView = ViewHistorialSalidasProductosModel.fromJson(e.data);
  //     dataView.setId = e.id;
  //     dataView.setCollectionId = e.collectionId;
  //     dataView.setCollectionName = e.collectionName;
  //     nuevosDatos.add(dataView);
  //   }
  //   return nuevosDatos;
  // }

  //METODO DE actualizar la pagina con datos nuevos del servidor. 
  Future<void> actualizarDatosDesdeServidor() async {
    // List<ViewHistorialSalidasProductosModel> newDate = await getViewHistorialSalidas();//extra
    listHistorialSalidas.clear();
    // listHistorialSalidas.addAll(newDate);//extra
    await getViewHistorialSalidas();
    notifyListeners();
  }
  
}