
import 'package:pocketbase/pocketbase.dart';

class TCategoria {
  
  static getCategoriaAlmacen() async {
    final pb = PocketBase('https://planet-broken.pockethost.io');

    final records = await pb.collection('productos_categoria').getFullList(
    sort: '-created',
    );
    return records;
  }
}