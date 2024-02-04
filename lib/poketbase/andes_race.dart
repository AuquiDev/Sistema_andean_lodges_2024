import 'package:pocketbase/pocketbase.dart';

class AndesRace {
    
  static getAndesRace() async {
     final pb = PocketBase('https://apu-ausangate.pockethost.io');
    // También puedes recuperar todos los registros a la vez a través de getFullList
    //UTILIZAMOS esta variable debuelve toda la coleccion. 
    final records = await pb.collection('andesrace').getFullList(
      sort: '-created',
    );
    // print('DATA $records');
    return records;
  }

  
}


class ViewAndesRace { 
  static getViewAndesRace100k () async {
    final pb = PocketBase('https://apu-ausangate.pockethost.io');
    // you can also fetch all records at once via getFullList
    final records = await pb.collection('v_runner_100k').getFullList(
      // sort: '-created', // COMENTA ESTO APRA VER UNA VISTA CONSULTA POKETBASE
    );
    // print('data ${records}');
    return records;
  }
}