// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ausangate_op/models/model_t_asistencia.dart';
import 'package:ausangate_op/provider/provider_t_asistencia.dart';
import 'package:ausangate_op/prueba_files/provider_prueba_files.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ausangate_op/prueba_files/model_prueba_files.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:provider/provider.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? imagenFile;
  List<File> listaImagenes = [];

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<TPruebaFileProvider>(context);

    // Obtiene la lista de asistencias dentro del onPressed
    List<TAsistenciaModel> listaAsistencia =
        Provider.of<TAsistenciaProvider>(context).listAsistencia;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subir Imágenes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Widget para previsualizar la imagen seleccionada
            imagenFile != null
                ? Image.file(imagenFile!, height: 100, width: 100)
                : const SizedBox.shrink(),

            // Widget para previsualizar las imágenes de la lista
            if (listaImagenes.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: listaImagenes.map((image) {
                    return Image.file(image, height: 90, width: 90);
                  }).toList(),
                ),
              ),

            // Image.asset(dataProvider.selectd, height: 200,),
            // Botones para seleccionar imágenes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 100,
                    );

                    if (pickedFile == null) {
                      print('No selecciono nada');
                    } else {
                      print('Tenemos Imagen ${pickedFile.path}');
                      //  dataProvider.updatedSelectedProductImage(pickedFile.path);
                      setState(() {
                        imagenFile = File(pickedFile.path);
                        listaImagenes.add(imagenFile!);
                        print('IMAGE: $imagenFile  : $listaImagenes');
                      });
                    }
                  },
                  child: const Icon(Icons.camera),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 100,
                    );
                    if (pickedFile == null) {
                      print('No selecciono nada');
                    } else {
                      print('Tenemos Imagen ${pickedFile.path}');
                      //  dataProvider.updatedSelectedProductImage(pickedFile.path);
                      setState(() {
                        imagenFile = File(pickedFile.path);
                        listaImagenes.add(imagenFile!);
                        print('IMAGE: $imagenFile  : $listaImagenes');
                      });
                    }
                  },
                  child: const Icon(Icons.photo),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print(listaAsistencia);
                //  if (listaAsistencia.isNotEmpty && listaImagenes.isNotEmpty) {

                await Provider.of<TPruebaFileProvider>(context, listen: false)
                    .updateTAsistenciaProvider(
                      id: 'csip9ctgzkptet1',
                  idEmpleados: 'hwxg3vrni7saf9x',
                  idTrabajo: 'e8oaqo4y6lewe8h',
                  listaprueba: listaAsistencia,
                  imagenFile: imagenFile,
                  listaImagenes: listaImagenes,
                );
                // } else {
                //   print('La lista de asistencias o la lista de imágenes está vacía');
                // }
              },
              child: const Text('Subir Imágenes'),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: dataProvider.listaPrueba.length,
              itemBuilder: (context, index) {
                final e = dataProvider.listaPrueba[index];
                return ListTile(
                  leading: ImagenPrueba(e: e),
                  title: H2Text(
                    text: e.id!,
                    fontSize: 12,
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}

class ImagenPrueba extends StatelessWidget {
  const ImagenPrueba({
    super.key,
    required this.e,
  });

  final TPruebaFilesModel e;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xffF6F3EB),
            border: Border.all(
                style: BorderStyle.solid, color: Colors.black12, width: .5)),
        height: 30,
        width: 30,
        child: Image.network(
           e.image != null && e.image is String && e.image!.isNotEmpty
              ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.image}'
              : 'https://via.placeholder.com/300',
           loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
          errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/img/andeanlodges.png',
            height: 150,
          ); // Widget a mostrar si hay un error al cargar la imagen
        },
        //  fit: BoxFit.cover,
        // height: size,
        // width: size,
        ),
      ),
    );
  }
}
