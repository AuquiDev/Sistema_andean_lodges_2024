
// ignore_for_file: non_constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

class ViewGastosGrupoSalidas {
  
  static getView_gatos_grupo_salidas () async {
    final  pb = PocketBase('https://planet-broken.pockethost.io');

    final records = await pb.collection('v_gastos_por_grupo_salidas_productos').getFullList();
    // print("Hola GASTO"  + '$records');
    return records;
  }
}