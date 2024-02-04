
// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_t_proveedor.dart';
import 'package:ausangate_op/poketbase/t_proveedor_app.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TProveedorProvider with ChangeNotifier {
  List<TProveedorModel> listaProveedor = [];

  TProveedorProvider(){
    print('Lista de Proveedores inicializado');
    getTProveedorApp();
  }
  List<TProveedorModel> get e => listaProveedor;

  void addtProveedor(TProveedorModel e){
    listaProveedor.add(e);
    notifyListeners();
  }

  getTProveedorApp() async {
    List<RecordModel> response = await TProveedor.getProveedorAlmacen();
    
    for (var e in response) {
      var date = TProveedorModel.fromJson(e.data);
      date.setId = e.id;
      date.created = DateTime.parse(e.created);
      date.updated = DateTime.parse(e.updated);
      date.collectionId = e.collectionId;
      date.collectionName = e.collectionName;
      addtProveedor(date);
    }
    // print(response);
    notifyListeners();
  }
}