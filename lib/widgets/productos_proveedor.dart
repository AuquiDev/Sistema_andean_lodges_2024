
// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_proveedor.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProveedorCard extends StatelessWidget {
  const ProveedorCard({
    super.key,
    required this.e,
  });
  final TProveedorModel e;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H2Text(
                      text: 'DATOS DEL PROVEEDOR:',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H2Text(
                                text: e.nombreEmpresaProveedor.isEmpty
                                    ? 'null'
                                    : e.nombreEmpresaProveedor.toString(),
                                fontSize: 15,
                                maxLines: 10,
                                color: Colors.white,
                              ),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    if (e.urlGoogleMaps.isNotEmpty) {
                                      _launchURL(e.urlGoogleMaps);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          content: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.pinkAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                width: 300,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: const Text(
                                                    'No hay link disponible'),
                                              ),
                                            ],
                                          ),
                                          duration: const Duration(
                                              seconds:
                                                  3), // Puedes ajustar la duración según tus preferencias
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                  label: e.urlGoogleMaps.isNotEmpty
                                      ? const H3Text(text: 'Ver')
                                      : const H3Text(text: 'N/A')),
                            ],
                          ),
                          Table(
                              border: TableBorder.all(
                                  width: 2, color: Colors.white),
                              children: [
                                TableRow(children: [
                                  _content(
                                      value: e.categoriaProvision.isEmpty
                                          ? 'null'
                                          : e.categoriaProvision.toString(),
                                      title: 'Categoría',
                                      color: Colors.black),
                                ]),
                                TableRow(children: [
                                  _content(
                                      value: e.numeroCuentaProveedor.isEmpty
                                          ? 'null'
                                          : e.numeroCuentaProveedor,
                                      title: 'Nro. Cuenta',
                                      color: Colors.black),
                                ]),
                                TableRow(children: [
                                  _content(
                                      value: e.correoProveedor.isEmpty
                                          ? 'null'
                                          : e.correoProveedor,
                                      title: 'Correo',
                                      color: Colors.black),
                                ]),
                              ]),
                        ],
                      ),
                    ),
                    Table(
                      border: TableBorder.all(width: 2, color: Colors.white),
                      children: [
                        TableRow(children: [
                          _content2(value: 'Contacto', color: Colors.teal),
                          _content2(value: 'Razón Social', color: Colors.teal),
                          _content2(value: 'Ubicación', color: Colors.teal),
                          // _content2(value: 'Ciudad', color: Colors.teal),
                        ]),
                        TableRow(children: [
                          _content2(
                              value: e.nombreContactoProveedor.isEmpty
                                  ? 'null'
                                  : e.nombreContactoProveedor,
                              color: Colors.black38),
                          _content2(
                              value: e.razonSocial.isEmpty
                                  ? 'null'
                                  : e.razonSocial.toString(),
                              color: Colors.black38),
                          _content2(
                              value: e.ciudadProveedor.isEmpty
                                  ? 'null'
                                  : e.ciudadProveedor.toString(),
                              color: Colors.black38),
                        ]),
                        TableRow(children: [
                          _content2(
                              value: e.telefonoProveedor.isEmpty
                                  ? 'null'
                                  : e.telefonoProveedor,
                              color: Colors.black38),
                          _content(
                              value: e.rucProveedor.isEmpty
                                  ? 'null'
                                  : e.rucProveedor,
                              title: 'RUC',
                              color: Colors.black38),
                          _content2(
                              value: e.direccionProveedor.isEmpty
                                  ? 'null'
                                  : e.direccionProveedor.toString(),
                              color: Colors.black38),
                        ]),
                      ],
                    ),
                    H2Text(
                      text: e.detalleAtencionOtros.isEmpty
                          ? 'null'
                          : e.detalleAtencionOtros.toString(),
                      fontSize: 15,
                      maxLines: 10,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ),
              if (size.width > 700) _imageGps()
            ],
          ),
          (size.width <= 700) ? _imageGps() : const SizedBox()
        ],
      ),
    );
  }

  Container _imageGps() {
    return Container(
      color: Colors.black,
      margin: const EdgeInsets.only(top: 26),
      width: 400,
      height: 316,
      child: Image.network(
        (e.imagenGps != null && e.imagenGps.isNotEmpty)
            ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.imagenGps}'
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
          return Image.asset('assets/img/andeanlodges.png');
        },
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Container _content({String? value, String? title, Color? color}) {
    return Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        color: color!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: H2Text(
                text: value ?? '',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            FittedBox(
              child: H2Text(
                text: title ?? '',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Container _content2({String? value, Color? color}) {
    return Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        color: color!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: H2Text(
                text: value ?? '',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ));
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
