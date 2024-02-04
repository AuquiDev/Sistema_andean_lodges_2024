
// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:pocketbase/pocketbase.dart';

class ViewInventarioGeneralProductos {
  
  //es estatico para poder llamar al metodo directamente con al 
  //notacion  + el nombre: ejemplo: PocketBase.getViewAndesRace100k()
  //significa que no es necesario crear un objeto de esa clase para poder 
  //acceder al método, ya que está asociado directamente con la clase en sí.
 static getView_v_inventario_general_producto() async{
  
    final pb =  PocketBase('https://planet-broken.pockethost.io');

    final records = await pb.collection('v_inventario_general_producto').getFullList();
    // print('DATA GENERAL=> : $records');
    return records;
  }

 static getViewv_alert_existencias_productos() async {
  final pb =  PocketBase('https://planet-broken.pockethost.io');

  final  records = await pb.collection('v_alert_existencias_productos').getFullList();
  // print('DATA invet.ALERTA EXISTENCIAS  => : $records');
  return records;
 }


 static getViewv_orden_compra_fechaV_stock_productos() async {
  final pb =  PocketBase('https://planet-broken.pockethost.io');

  final  records = await pb.collection('v_orden_compra_fechaV_stock_productos').getFullList();
  // print('DATA invet.ORDEN COMPRA  => : $records');
  return records;
 }
}

