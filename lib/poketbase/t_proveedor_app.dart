
import 'package:pocketbase/pocketbase.dart';

class TProveedor {
  
  static getProveedorAlmacen() async {
    final pb = PocketBase('https://planet-broken.pockethost.io');

    final records = await pb.collection('proveedor_app').getFullList(
    sort: '-created',
    );
    return records;
  }
}