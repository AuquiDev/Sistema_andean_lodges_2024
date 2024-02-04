// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_t_categoria_productos.dart';
import 'package:ausangate_op/poketbase/t_categoria_almacen.dart';
import 'package:flutter/widgets.dart';
import 'package:pocketbase/pocketbase.dart';

class TCategoriaProvider with ChangeNotifier {
  List<TCategoriaModel> listcategory = [];

  TCategoriaProvider() {
    print('Lista Categoria Inicializado');
    getTCategoria();
  }

  //SET y GETTER
  List<TCategoriaModel> get e => listcategory;

  void addCategoria(TCategoriaModel e){
    listcategory.add(e);
    notifyListeners();
  }

  getTCategoria() async {
    List<RecordModel> response = await TCategoria.getCategoriaAlmacen();
    for(var e in response){
      var date = TCategoriaModel.fromJson(e.data);
      date.setId = e.id;
      date.created = DateTime.parse(e.created);
      date.updated = DateTime.parse(e.updated);
      date.collectionId = e.collectionId;
      date.collectionName = e.collectionName;
      addCategoria(date);
    }
    // print(response);
    notifyListeners();
  }
}
