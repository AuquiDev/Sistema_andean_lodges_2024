
// ignore_for_file: non_constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

class ViewHistorialSalidasProductos {
  
  //es estatico para poder llamar al metodo directamente con al 
  //notacion  + el nombre: ejemplo: PocketBase.getViewAndesRace100k()
  //significa que no es necesario crear un objeto de esa clase para poder 
  //acceder al método, ya que está asociado directamente con la clase en sí.
 static get_v_Hitorial_salidas_productos() async{
  
    final pb =  PocketBase('https://planet-broken.pockethost.io');

    final records = await pb.collection('v_historial_salidas_productos').getFullList();
    // print('DATA HISTORIAL SALIDAS=> : $records');
    return records;
  }
}