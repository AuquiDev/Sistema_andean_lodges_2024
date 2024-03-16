// ignore_for_file: deprecated_member_use

import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
    required this.e,
  }) : super(key: key);

  final TProductosAppModel e;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.black26,
                title:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    H2Text(
                      text:
                          '${e.nombreProducto} - ${e.marcaProducto} - ${e.unidMedida}',
                       color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                     
                    ),
                     H2Text(
                      text:
                          '${e.imagen!.length.toString()} Imagenes.',
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
                content: SizedBox(
                  width:  double.maxFinite ,
                  height: MediaQuery.of(context).size.width > 500 ? 500 : 250 , // Altura máxima del ListView
                  child: ScrollWeb(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var imageUrl in e.imagen!)
                          GestureDetector(
                            onTap: () {
                              // Verificar si hay una URL antes de lanzarla
                              if (e.imagen != null &&
                                  e.imagen is List<String> &&
                                  e.imagen!.isNotEmpty) {
                                // Seleccionar la primera URL de la lista (puedes ajustar esto según tus necesidades)
                                // Abrir la URL utilizando url_launcher
                                _launchURL(
                                  'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/$imageUrl',
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                (e.imagen != null &&
                                        e.imagen is List<String> &&
                                        e.imagen!.isNotEmpty)
                                    ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/$imageUrl'
                                    : 'https://via.placeholder.com/300',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                actions: [
                 
                  TextButton(
                      onPressed: () {},
                      child: const H2Text(
                        text: 'Añadir',
                        color: Colors.white,
                        fontSize: 14,
                      )),
                  TextButton(
                      onPressed: () {Navigator.pop(context);},
                      child: const H2Text(
                        text: 'Cerrar',
                        color: Colors.white,
                        fontSize: 14,
                      ))
                ],
              );
            },
          );
        // }
      },
      child: Image.network(
        (e.imagen != null && e.imagen is List<String> && e.imagen!.isNotEmpty)
            ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.imagen![0]}'
            : 'https://via.placeholder.com/300',
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              ),
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Icon(Icons.image);
        },
        width: 25,
        height: 25,
        fit: BoxFit.cover,
      ),
    );
  }

  // Método para abrir una URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }
}
