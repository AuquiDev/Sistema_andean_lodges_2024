// ignore_for_file: unnecessary_type_check, unnecessary_null_comparison

import 'package:ausangate_op/models/model_v_historial_salidas_productos.dart';
import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:flutter/material.dart';

class ImageDetailsInventario extends StatelessWidget {
  const ImageDetailsInventario({
    super.key,
    required this.e,
  });

  final ViewInventarioGeneralProductosModel e;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffF6F3EB),
          border: Border.all(
              style: BorderStyle.solid, color: Colors.black12, width: .5)),
      height: 150,
      width: 150,
      child: Image.network(
         e.imagen != null && e.imagen is String && e.imagen.isNotEmpty
            ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.imagen}'
            : 'https://via.placeholder.com/300',
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/img/andeanlodges.png',
            height: 150,
          ); // Widget a mostrar si hay un error al cargar la imagen
        },

      ),
    );
  }
}

class ImageDetailsHistorialSalidas extends StatelessWidget {
  const ImageDetailsHistorialSalidas({
    super.key,
    required this.e,
    this.size = 150,
  });

  final ViewHistorialSalidasProductosModel e;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: const Color(0xffF6F3EB),
              border: Border.all(
                  style: BorderStyle.solid, color: Colors.black12, width: .5)),
          height: size,
          width: size,
          child: Image.network(
             e.imagen != null &&
                    e.imagen is String &&
                    e.imagen.isNotEmpty
                ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.imagen}'
                : 'https://via.placeholder.com/300',
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/img/andeanlodges.png',
            height: 150,
          ); // Widget a mostrar si hay un error al cargar la imagen
        },
        // fit: BoxFit.cover,

      ),
        ),
        const Icon(Icons.arrow_right_alt),
        Container(
          decoration: BoxDecoration(
              color: const Color(0xffF6F3EB),
              border: Border.all(
                  style: BorderStyle.solid, color: Colors.black12, width: .5)),
          height: size,
          width: size,
          child: Image.network(
             e.imagen != null &&
                    e.imagen is String &&
                    e.imagen.isNotEmpty
                ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.imagenEmpleado}'
                : 'https://via.placeholder.com/300',
           loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset(
            'assets/img/andeanlodges.png',
            height: 150,
          ); // Widget a mostrar si hay un error al cargar la imagen
        },
        // fit: BoxFit.cover,
      
      ),
        ),
      ],
    );
  }
}
