// ignore_for_file: avoid_print

import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/poketbase/t_productos_app.dart';

class TProductosAppProvider with ChangeNotifier {
  List<TProductosAppModel> listProductos = [];
  //   final tSQLproductoProvider = Provider.of<DBProductoAppProvider>(context);
  // List<TProductosAppModel> listSqlproducto = tSQLproductoProvider.listsql;
  TProductosAppProvider() {
    print('Tabla Prodctos inicilizado.');
    getProductosAPP();
    realtime();
  }


  //SET y GETTER
  List<TProductosAppModel> get e => listProductos;

  void addTProductos(TProductosAppModel e) {
    listProductos.add(e);
    notifyListeners();
  }

  void updateTProductos(TProductosAppModel e) {
    listProductos[listProductos.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTProductos(TProductosAppModel e) {
    listProductos.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }
  
  //__________________________
   getProductosAPP() async {
    List<RecordModel> response = await TProductosApp.getProductoApp();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TProductosAppModel productos = TProductosAppModel.fromJson(e.data);
      addTProductos(productos);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postProductosProvider(
      {String? id,
      String? idCategoria,
      String? idUbicacion,
      String? idProveedor,
      String? nombreProducto,
      String? marcaProducto,
      String? unidMedida,
      double? precioUnd,
      String? unidMedidaSalida,
      double? precioUnidadSalidaGrupo,
      String? descripcionUbicDetll,
      String? tipoProducto,
      DateTime? fechaVencimiento,
      bool? estado}) async {
     isSyncing = true;
    notifyListeners();
    TProductosAppModel data = TProductosAppModel(
      id: '',
      idCategoria: idCategoria!,
      idUbicacion: idUbicacion!,
      idProveedor: idProveedor!,
      // imagen: imagen,
      nombreProducto: nombreProducto!,
      marcaProducto: marcaProducto!,
      unidMedida: unidMedida!,
      precioUnd: precioUnd!,
      unidMedidaSalida: unidMedidaSalida!,
      precioUnidadSalidaGrupo: precioUnidadSalidaGrupo!,
      descripcionUbicDetll: descripcionUbicDetll!,
      tipoProducto: tipoProducto!,
      fechaVencimiento: fechaVencimiento!,
      estado: estado!,
      // documentUsoPreparacionReceta: documentUsoPreparacionReceta
    );
    // RecordModel result = await TProductosApp.postProductosApp(data);
    // print(result.data);
    // addTProductos(TProductosAppModel.fromJson(result.data));
    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
    // notifyListeners();
    await TProductosApp.postProductosApp(data);
  }

  updateProductosProvider(
      {String? id,
      String? idCategoria,
      String? idUbicacion,
      String? idProveedor,
      String? nombreProducto,
      String? marcaProducto,
      String? unidMedida,
      double? precioUnd,
      String? unidMedidaSalida,
      double? precioUnidadSalidaGrupo,
      String? descripcionUbicDetll,
      String? tipoProducto,
      DateTime? fechaVencimiento,
      bool? estado}) async {
     isSyncing = true;
    notifyListeners();
    TProductosAppModel data = TProductosAppModel(
      id: id!,
      idCategoria: idCategoria!,
      idUbicacion: idUbicacion!,
      idProveedor: idProveedor!,
      // imagen: imagen,
      nombreProducto: nombreProducto!,
      marcaProducto: marcaProducto!,
      unidMedida: unidMedida!,
      precioUnd: precioUnd!,
      unidMedidaSalida: unidMedidaSalida!,
      precioUnidadSalidaGrupo: precioUnidadSalidaGrupo!,
      descripcionUbicDetll: descripcionUbicDetll!,
      tipoProducto: tipoProducto!,
      fechaVencimiento: fechaVencimiento!,
      estado: estado!,
      // documentUsoPreparacionReceta: documentUsoPreparacionReceta
    );
    // RecordModel result = await TProductosApp.postProductosApp(data);
    // print(result.data);
    // addTProductos(TProductosAppModel.fromJson(result.data));
    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
    // notifyListeners();
    await TProductosApp.putProductosApp(id: id, data: data);
  }

  deleteTProductosApp(String id) async {
    await TProductosApp.deleteProductosApp(id);
    notifyListeners();
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TProductosAppModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id.isEmpty) {
      await postProductosProvider(
        id: '',
        idCategoria: e.idCategoria,
        idUbicacion: e.idUbicacion,
        idProveedor: e.idProveedor,
        nombreProducto: e.nombreProducto,
        marcaProducto: e.marcaProducto,
        unidMedida: e.unidMedida,
        precioUnd: e.precioUnd,
        unidMedidaSalida: e.unidMedidaSalida,
        precioUnidadSalidaGrupo: e.precioUnidadSalidaGrupo,
        descripcionUbicDetll: e.descripcionUbicDetll,
        tipoProducto: e.tipoProducto,
        fechaVencimiento: e.fechaVencimiento,
        estado: e.estado,
      );
      print('INSERTADO API');
    } else {
      await updateProductosProvider(
        id: e.id,
        idCategoria: e.idCategoria,
        idUbicacion: e.idUbicacion,
        idProveedor: e.idProveedor,
        nombreProducto: e.nombreProducto,
        marcaProducto: e.marcaProducto,
        unidMedida: e.unidMedida,
        precioUnd: e.precioUnd,
        unidMedidaSalida: e.unidMedidaSalida,
        precioUnidadSalidaGrupo: e.precioUnidadSalidaGrupo,
        descripcionUbicDetll: e.descripcionUbicDetll,
        tipoProducto: e.tipoProducto,
        fechaVencimiento: e.fechaVencimiento,
        estado: e.estado,
      );
      print('EDITADO API');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    // RealtimeService response = await TProductosApp.realmTimePocket();
    await pb.collection('productos_app').subscribe('*', (e) {
      print('REALTIME ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addTProductos(TProductosAppModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTProductos(TProductosAppModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTProductos(TProductosAppModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
