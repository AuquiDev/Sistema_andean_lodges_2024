// ignore_for_file: deprecated_member_use

import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/provider/provider_t_categoria_almacen.dart';
import 'package:ausangate_op/provider/provider_t_proveedorapp.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/formatear_numero.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:ausangate_op/widgets/responsive_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppBarPRoductos extends StatelessWidget {
  const CustomAppBarPRoductos({
    super.key,
    required this.e,
  });

  final TProductosAppModel e;
  @override
  Widget build(BuildContext context) {
    String obtenerCategiria(String idCategoria) {
      final listaCategoria =
          Provider.of<TCategoriaProvider>(context).listcategory;
      for (var data in listaCategoria) {
        if (data.id == idCategoria) {
          return data.categoria;
        }
      }
      return '-';
    }

    final String categoria = obtenerCategiria(e.idCategoria);

    String obtenerUbicacion(String idUbicacion) {
      final listaCategoria =
          Provider.of<TUbicacionAlmacenProvider>(context).listUbicacion;
      for (var data in listaCategoria) {
        if (data.id == idUbicacion) {
          return data.nombreUbicacion;
        }
      }
      return '-';
    }

    final String ubicacion = obtenerUbicacion(e.idUbicacion);
    String obtenerProveedor(String idProveedor) {
      final listaCategoria =
          Provider.of<TProveedorProvider>(context).listaProveedor;
      for (var data in listaCategoria) {
        if (data.id == idProveedor) {
          return data.nombreEmpresaProveedor;
        }
      }
      return '-';
    }

    final String proveedor = obtenerProveedor(e.idProveedor);
    return ScrollWeb(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Card(
          surfaceTintColor: Colors.white,
          child: Container(
            margin: const EdgeInsets.all(10),
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ResponsiveTitleAppBar(
                    title: '${e.nombreProducto} ~ ${e.marcaProducto}',
                    subtitle: categoria),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    e.estado
                        ? const Icon(
                            Icons.check_box,
                            color: Colors.green,
                            size: 14,
                          )
                        : const Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.black,
                            size: 14,
                          ),
                    TextButton.icon(
                        onPressed: () {
                          if (e.documentUsoPreparacionReceta != null &&
                              e.documentUsoPreparacionReceta!.isNotEmpty) {
                            _launchURL(
                                'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.documentUsoPreparacionReceta}');
                          } else {
                            _messageDialog(context);
                          }
                        },
                        icon: const Icon(
                          Icons.open_in_new,
                          size: 14,
                        ),
                        label: e.documentUsoPreparacionReceta != null &&
                                e.documentUsoPreparacionReceta!.isNotEmpty
                            ? const H3Text(
                                text: 'Documento',
                                fontSize: 12,
                              )
                            : const H3Text(
                                text: 'N/A',
                                fontSize: 12,
                              ))
                  ],
                ),
                //GENERALES
                Container(
                  color: Colors.brown.withOpacity(.1),
                  child: Table(
                    border: TableBorder.all(width: .1),
                    columnWidths: const {
                      // Ancho de la primera columna (ajusta el valor según tus necesidades)
                      0: FixedColumnWidth(150),
                      // 1: FractionColumnWidth(1),
                    },
                    children: [
                      tableRows1(
                          text1: ubicacion,
                          text2: ' Almacén',
                          icon: const Icon(
                            Icons.location_on,
                            color: Colors.black,
                          )),
                      tableRows1(
                          text1: proveedor,
                          text2: ' Proveedor',
                          icon: const Icon(
                            Icons.airport_shuttle_rounded,
                            color: Colors.black,
                          )),
                      tableRows1(
                          text1: formatearNumero(e.stock!),
                          text2: ' Existencias',
                          icon: const Icon(
                            Icons.numbers_outlined,
                            color: Colors.black,
                          )),
                      tableRows1(
                          text1: formatFecha(e.fechaVencimiento),
                          text2: ' F. Vencimeinto',
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                          )),
                       tableRows1(
                          text1: categoria,
                          text2: 'Categoría',
                          icon: const Icon(
                            Icons.category_rounded,
                            color: Colors.black,
                          )),
                       tableRows1(
                          text1: e.marcaProducto,
                          text2: 'Marca',
                          icon: const Icon(
                            Icons.ballot_rounded,
                            color: Colors.black,
                          )),
                         tableRows1(
                          text1: e.tipoProducto,
                          text2: 'Tipo',
                          icon: const Icon(
                            Icons.ballot_rounded,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
           //ENTRADAS SALIDAS
                titletable(title: 'Distribución'),
                Container(
                  color: Colors.blue.withOpacity(.2),
                  child: Table(
                    border: TableBorder.all(width: .2, color: Colors.white),
                    children: [
                      tableRows(
                          text1: 'Campo',
                          text2: 'Entrada',
                          text3: 'Salida'),
                      tableRows2(
                          text1: 'Unidad Medida',
                          text2: e.unidMedida,
                          text3: e.unidMedidaSalida),
                      tableRows2(
                          text1: 'Precio',
                          text2: 's/. ${formatearNumero(e.precioUnd)}',
                          text3:
                              's/. ${formatearNumero(e.precioUnidadSalidaGrupo)}'),
                    ],
                  ),
                ),
                titletable(
                      title:
                          'Descripción (restriciones, detalles de grupo, recomendaciones):'),
                  H2Text(
                    text: e.descripcionUbicDetll,
                    fontSize: 12,
                    maxLines: 100,
                    textAlign: TextAlign.justify,
                  ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _messageDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No hay documento disponible'),
        duration: Duration(seconds: 3),
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

  Padding titletable({String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: FittedBox(
        child: H2Text(
          text: title!.toUpperCase(),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TableRow tableRows({String? text1, String? text2, String? text3}) {
    return TableRow(children: [
      TableCell(
        child: Center(
          child: H2Text(
            text: text1!,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: H2Text(
            text: text2!,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: H2Text(
            text: text3!,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    ]);
  }

  TableRow tableRows1({String? text1, String? text2, Icon? icon}) {
    return TableRow(children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            Expanded(
              child: H2Text(
                text: text2!,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      TableCell(
        child: Center(
          child: H2Text(
            text: text1!,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    ]);
  }

  TableRow tableRows2({String? text1, String? text2, String? text3}) {
    return TableRow(children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: H2Text(
            text: text1!,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: H2Text(
            text: text2!,
            fontSize: 12,
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: H2Text(
            text: text3!,
            fontSize: 12,
          ),
        ),
      ),
    ]);
  }
}

class ButtonEntradasSalidas extends StatelessWidget {
  const ButtonEntradasSalidas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 350),
      child: Column(
        children: [
         
    
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const H2Text(
                  text: 'Nueva Entrada',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const H2Text(
                  text: 'Nueva Salida',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

                      //  EntradasForm(producto: e),
                      // SalidasForm(producto: e)
        ],
      ),
    );
  }
}
