
import 'dart:io';

import 'package:ausangate_op/prueba_files/model_prueba_files.dart';
import 'package:ausangate_op/utils/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class TPruebaFile {
  static getAsitenciaPk() async {
    final records = await pb.collection('reporte_guia').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk({TPruebaFilesModel? data, File? imagenFile,  List<File>? listaImagenes}) async {
    final record =  await pb.collection('reporte_guia').create(
        body: data!.toJson(), 
          files: [
            // Adjuntar la imagen principal al formulario
            if (imagenFile != null)
            http.MultipartFile.fromBytes(
              'image',
              await imagenFile.readAsBytes(),
              filename: 'image.jpg',
            ),
            // Adjuntar la lista de imágenes al formulario
            if (listaImagenes != null)
            for (var i = 0; i < listaImagenes.length; i++)
              http.MultipartFile.fromBytes(
                'images',
                await listaImagenes[i].readAsBytes(),
                filename: 'image$i.jpg',
              ),
          ],
        );

    return record;
  }

  static  putAsitneciaPk({String? id, TPruebaFilesModel? data, File? imagenFile,  List<File>? listaImagenes,}) async {
    final record = await pb.collection('reporte_guia').update(id!, body: data!.toJson(),
     files: [
            // Adjuntar la imagen principal al formulario
            if (imagenFile != null)
            http.MultipartFile.fromBytes(
              'image',
              await imagenFile.readAsBytes(),
              filename: 'image.jpg',
            ),
            // Adjuntar la lista de imágenes al formulario
            if (listaImagenes != null)
            for (var i = 0; i < listaImagenes.length; i++)
              http.MultipartFile.fromBytes(
                'images',
                await listaImagenes[i].readAsBytes(),
                filename: 'image$i.jpg',
              ),
          ],);
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('reporte_guia').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}