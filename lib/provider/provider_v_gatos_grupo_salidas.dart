

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ausangate_op/models/model_v_gastos_grupo_salidas.dart';
import 'package:ausangate_op/poketbase/v_gastos_grupo_salidas.dart';

class ViewGastosGrupoSalidasProvider with ChangeNotifier {
  
  List<ViewGastosGrupoSalidasModel> listGastos = [];

  ViewGastosGrupoSalidasProvider (){
    print('Gastos Salidas inicializado');
    getViewGastosGruposalidas();
  }

  List<ViewGastosGrupoSalidasModel> get e => listGastos;

  void setGastos(ViewGastosGrupoSalidasModel e) {
    listGastos.add(e);
    notifyListeners();
  }

  getViewGastosGruposalidas() async {
    List<RecordModel> response = await ViewGastosGrupoSalidas.getView_gatos_grupo_salidas();
    for (var e in response) {
      var dataView = ViewGastosGrupoSalidasModel.fromJson(e.data);
      dataView.setId = e.id;
      dataView.setCollectionId = e.collectionId;
      dataView.setCollectionName = e.collectionName;
      setGastos(dataView);
    }
    // print('DATA PROVIDER GASTOS $response');
    notifyListeners();
  }
  
  //METODO DE actualizar la pagina con datos nuevos del servidor. 
 Future<void> actualizarDatosDesdeServidor() async {
  // List<ViewGastosGrupoSalidasModel> nuevosDatos = await getViewGastosGruposalidas();
  listGastos.clear();
  // listGastos.addAll(nuevosDatos);
   await getViewGastosGruposalidas();
  notifyListeners();
}


}