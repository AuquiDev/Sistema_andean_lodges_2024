
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/poketbase/v_inventario_general_productos.dart';


class ViewInventarioGeneralProductosProvider with ChangeNotifier {
  List<ViewInventarioGeneralProductosModel> listInventario = [];

  ViewInventarioGeneralProductosProvider(){
    print('ViewInventarioGeneralProductosProvider Inicializado');
    getViewInventarioGeneral();
  }

  //FUnciones dentro de una clase : get y setter.
  List<ViewInventarioGeneralProductosModel> get e => listInventario;

  void addInventarioGeneral(ViewInventarioGeneralProductosModel e){
    listInventario.add(e);
    notifyListeners();
  }
  
  getViewInventarioGeneral() async {
    List<RecordModel> response = await ViewInventarioGeneralProductos.getView_v_inventario_general_producto();
    for (var e in response) {
      var dataView = ViewInventarioGeneralProductosModel.fromJson(e.data);
      dataView.setId = e.id;
      dataView.setCollectionId = e.collectionId;
      dataView.setCollectionName = e.  collectionName;
      addInventarioGeneral(dataView);
    }
    // response.map((e) => addInventarioGeneral(ViewInventarioGeneralProductosModel.fromJson(e.data))).toList();
    // print('DATA GETPROVIDER: $response');
    notifyListeners();
  }
  
  //REVISAR LA DOCUMENTACION DEL FUTURE BUILDER SIMULAR REAL TIME
  Future<void> actualizarDatosDesdeServidor() async {
    // List<ViewInventarioGeneralProductosModel> nuevosDatos = await getViewInventarioGeneral();
    listInventario.clear();
    // listInventario.addAll(nuevosDatos);
    await getViewInventarioGeneral();
    print('nuevosDatos');
    notifyListeners();
  }
}


class ViewInventarioALERTAEXISTENCIASproductosProvider with ChangeNotifier {
  
  //LIsta temporal 
  List<ViewInventarioGeneralProductosModel> listAlertaExistencias = [];

  ViewInventarioALERTAEXISTENCIASproductosProvider(){
    print('ViewInventarioALERTAEXISTENCIASproductosProvider Inicializado');
    getViewInventarioALERTAproductosProvider();

  }

  //FUNCIONES get y seeter dentro de la clase
  List<ViewInventarioGeneralProductosModel> get e => listAlertaExistencias;
  //AÑADA la lista recibida del APi de tipo de objeto model a la
  // lista temporal. y el get muestra o permite mostrar ese dato
  void addInventarioOtros(ViewInventarioGeneralProductosModel e)  {
    listAlertaExistencias.add(e);
    notifyListeners();
  }

  //METODO GET
  getViewInventarioALERTAproductosProvider() async{
    List<RecordModel> response = await ViewInventarioGeneralProductos.getViewv_alert_existencias_productos();
    for (var e in response) {
      var dataView = ViewInventarioGeneralProductosModel.fromJson(e.data);
      dataView.setId = e.id;
      dataView.setCollectionId = e.collectionId;
      dataView.setCollectionName = e.collectionName;
      addInventarioOtros(dataView);
    }
    // print('DATA ALERTAEXISTENCIAS_PROVIDER: $response');
    notifyListeners();
  }

  //REVISAR LA DOCUMENTACION DEL FUTURE BUILDER SIMULAR REAL TIME
  Future<void> actualizarDatosDesdeServidor() async {
    // List<ViewInventarioGeneralProductosModel> nuevosDatos = await getViewInventarioALERTAproductosProvider();
    listAlertaExistencias.clear();
    // listAlertaExistencias.addAll(nuevosDatos);
    await getViewInventarioALERTAproductosProvider();
    print('nuevosDatos Alertas');
    notifyListeners();
  }
}


class ViewInventarioORDENCOMPRAFVSTOCKproductosProvider with ChangeNotifier {
  
  //LIsta temporal 
  List<ViewInventarioGeneralProductosModel> listOrdenCompra = [];

  ViewInventarioORDENCOMPRAFVSTOCKproductosProvider(){
    print('ViewInventarioORDENCOMPRAFVSTOCKproductosProvider Inicializado');
    getViewInventarioORDENCOMPRAproductosProvider();

  }

  //FUNCIONES get y seeter dentro de la clase
  List<ViewInventarioGeneralProductosModel> get e => listOrdenCompra;
  //AÑADA la lista recibida del APi de tipo de objeto model a la
  // lista temporal. y el get muestra o permite mostrar ese dato
  void addInventarioOtros(ViewInventarioGeneralProductosModel e)  {
    listOrdenCompra.add(e);
    notifyListeners();
  }

  //METODO GET
  getViewInventarioORDENCOMPRAproductosProvider() async{
    List<RecordModel> response = await ViewInventarioGeneralProductos.getViewv_orden_compra_fechaV_stock_productos();
    for (var e in response) {
      var dataView = ViewInventarioGeneralProductosModel.fromJson(e.data);
      dataView.setId = e.id;
      dataView.setCollectionId = e.collectionId;
      dataView.setCollectionName = e.collectionName;
      addInventarioOtros(dataView);
    }
    notifyListeners();
  }

  //REVISAR LA DOCUMENTACION DEL FUTURE BUILDER SIMULAR REAL TIME
  Future<void> actualizarDatosDesdeServidor() async {
    // List<ViewInventarioGeneralProductosModel> nuevosDatos = await getViewInventarioORDENCOMPRAproductosProvider();
    listOrdenCompra.clear();
    // listOrdenCompra.addAll(nuevosDatos);
    await getViewInventarioORDENCOMPRAproductosProvider();
     print('nuevosDatos Comopras');
    notifyListeners();
  }
}




