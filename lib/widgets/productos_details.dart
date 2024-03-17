
// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/pages/productos_details.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:ausangate_op/widgets/custom_card_productos.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeatilsCardCustom extends StatelessWidget {
  const DeatilsCardCustom({super.key, required this.e});
  final ViewInventarioGeneralProductosModel e;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Table(
            border: TableBorder.all(width: 2, color: Colors.white),
            children: [
              TableRow(children: [
                _content(
                  value: e.fechaVencimiento == null
                      ? 'null'
                      : formatFechaPDfdiaMesAno(e.fechaVencimiento!),
                  title: 'Fecha de Vencimiento',
                  color: Colors.grey,
                ),
                _content(
                  value: e.estadoFecha.isEmpty ? 'null' : e.estadoFecha,
                  title: 'Estado Fecha',
                  color: getColorfechav(e),
                ),
                _content(
                  value: e.estadoStock.isEmpty ? 'null' : e.estadoStock,
                  title: 'Estado Stock',
                  color: getColorStock(e),
                ),
              ])
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    H2Text(
                      text: e.producto.toUpperCase(),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    Table(
                      border: TableBorder.all(width: 2, color: Colors.white),
                      children: [
                        TableRow(children: [
                          _content2(
                            value: 'Marca',
                            color: Colors.pink,
                          ),
                          _content2(
                            value: 'Categoría',
                            color: Colors.pink,
                          ),
                          _content2(
                            value: 'Ubicación',
                            color: Colors.pink,
                          ),
                          _content2(
                            value: 'Tipo',
                            color: Colors.pink,
                          ),
                          _content2(
                            value: 'Proveedor',
                            color: Colors.pink,
                          ),
                        ]),
                        TableRow(children: [
                          _content2(
                            value: e.marcaProducto.isEmpty
                                ? 'null'
                                : e.marcaProducto,
                            color: Colors.black45,
                          ),
                          _content2(
                            value: e.categoria.isEmpty ? 'null' : e.categoria,
                            color: Colors.black45,
                          ),
                          _content2(
                            value: e.nombreUbicacion.isEmpty
                                ? 'null'
                                : e.nombreUbicacion,
                            color: Colors.black45,
                          ),
                          _content2(
                            value: e.tipoProducto,
                            color: Colors.black45,
                          ),
                          _content2(
                            value: e.nombreEmpresaProveedor.isEmpty
                                ? 'null'
                                : e.nombreEmpresaProveedor,
                            color: Colors.black45,
                          ),
                        ])
                      ],
                    ),
                    Row(
                      children: [
                        const H2Text(
                          text: 'Documento adjunto: ',
                          fontSize: 15,
                          color: Colors.pink,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              if (e.documentUsoPreparacionReceta.isNotEmpty) {
                                _launchURL(
                                    'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.documentUsoPreparacionReceta}');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: const Text(
                                              'No hay documento disponible'),
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
                            icon: const Icon(Icons.open_in_new),
                            label: e.documentUsoPreparacionReceta.isNotEmpty
                                ? const H3Text(text: '')
                                : const H3Text(text: 'N/A')),
                      ],
                    ),
                    Table(
                      border: TableBorder.all(width: 2, color: Colors.white),
                      children: [
                        TableRow(children: [
                          _content2(
                            value: e.id,
                            color: Colors.white,
                          ),
                          _content2(value: 'Entradas', color: Colors.black),
                          _content2(value: 'Salidas', color: Colors.black),
                        ]),
                        TableRow(children: [
                          _content2(
                            value: 'Unidad de Medida',
                            color: Colors.black,
                          ),
                          _content(
                            value: e.unidMedida.isEmpty ? 'null' : e.unidMedida,
                            title: 'und compra',
                            color: Colors.blueGrey,
                          ),
                          _content(
                            value: e.unidMedidaSalida.isEmpty
                                ? 'null'
                                : e.unidMedidaSalida,
                            title: 'und distribución',
                            color: Colors.blueGrey,
                          ),
                        ]),
                        TableRow(children: [
                          _content2(
                            value: 'Precio',
                            color: Colors.black,
                          ),
                          _content(
                            value: e.precioUnd == null
                                ? 'null'
                                : 'S/.${e.precioUnd}',
                            title: 'precio compra',
                            color: Colors.blueGrey,
                          ),
                          _content(
                            value: e.precioUnidadSalidaGrupo == null
                                ? 'null'
                                : 'S/.${e.precioUnidadSalidaGrupo}',
                            title: 'precio distribución',
                            color: Colors.blueGrey,
                          ),
                        ])
                      ],
                    ),
                  ],
                ),
              ),
              if(size.width > 700)
              Container(
                padding: const EdgeInsets.all(10),
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H2Text(
                      text: 'DESCRIPCIÓN:',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    H2Text(
                      text: e.descripcionUbicDetll,
                      maxLines: 600,
                      fontSize: 14,
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              )
            ],
          ),
          (size.width <= 700) ?
              Container(
                padding: const EdgeInsets.all(10),
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H2Text(
                      text: 'DESCRIPCIÓN:',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    H2Text(
                      text: e.descripcionUbicDetll,
                      maxLines: 600,
                      fontSize: 14,
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ) : const SizedBox()
        ],
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


class BarStatus extends StatelessWidget {
  const BarStatus({
    super.key,
    required this.widget,
  });

  final DetailsProductos widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 100,
      height: 50,
      right: 10,
      top: 10,
      child: Table(
        border: TableBorder.all(width: 2, color: Colors.white10),
        children: [
          TableRow(
            children: [
              _content(
                value: (widget.e.stock != null && widget.e.stock != 0)
                    ? widget.e.stock.toString()
                    : '0',
                title: 'STOCK',
                color: getColorStock(widget.e),
              )
            ],
          ),
          TableRow(
            children: [
              _content(
                value: widget.e.cantidadEntrada.toString(),
                title: 'ENTRADAS',
                color: Colors.black87,
              )
            ],
          ),
          TableRow(
            children: [
              _content(
                value: widget.e.cantidadSalida.toString(),
                title: 'SALIDAS',
                color: Colors.black54,
              )
            ],
          )
        ],
      ),
    );
  }

  Container _content({String? value, String? title, Color? color}) {
    return Container(
        height: 60, // Especifica la altura deseada
        color: color!,
        child: Column(
          children: [
            FittedBox(
                child: H2Text(
              text: value ?? '',
              color: Colors.white,
              fontSize: 25,
            )),
            H2Text(
              text: title ?? '',
              fontSize: 12,
              color: Colors.white,
            ),
          ],
        ));
  }
}