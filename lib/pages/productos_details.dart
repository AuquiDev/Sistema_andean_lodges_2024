// ignore_for_file: deprecated_member_use

import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/widgets/imagen_path_productos.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsProductos extends StatelessWidget {
  const DetailsProductos({super.key, required this.e});
  final ViewInventarioGeneralProductosModel e;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScrollWeb(
          child: SingleChildScrollView(
            physics:
                const ClampingScrollPhysics(), //Comportamiento de desplazamiento si nefecto de rebote.
            child: Container(
              // margin: const EdgeInsets.all(10),
              constraints: const BoxConstraints(maxWidth: 450),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // H1Text(
                    //   text: e.producto,
                    //   fontWeight: FontWeight.w900,
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageDetailsInventario(e: e),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: H1Text(
                          text: e.descripcionUbicDetll,
                          fontSize: 12,
                          textAlign: TextAlign.justify,
                          maxLines: 50,
                        ))
                      ],
                    ),
                    DataTable(
                        headingRowHeight: 20,
                        dataRowHeight: 35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        columns: const [
                          DataColumn(
                              label: H2Text(
                            text: 'Campo',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                          DataColumn(
                              label: H2Text(
                            text: 'Descripción',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                        rows: [
                          _dataRow('Ubicación'.toUpperCase(),
                              e.nombreUbicacion.toString()),
                          _dataRow('Categoria'.toUpperCase(), e.categoria),
                          _dataRow('Producto'.toUpperCase(), e.producto),
                          _dataRow('Marca'.toUpperCase(), e.marcaProducto),
                          _dataRow(
                              'Tipo Producto'.toUpperCase(), e.tipoProducto),
                          _dataRow('Proveedor'.toUpperCase(),
                              e.nombreEmpresaProveedor),
                          _dataRow('fecha Vencimiento'.toUpperCase(),
                              '${formatFecha(e.fechaVencimiento!)}\n[ ${e.estadoFecha} ]'),
                          _dataRow('Existencias'.toUpperCase(),
                              '${e.stock.toStringAsFixed(2)}\n[ ${e.estadoStock} ] '),
                          _dataRow('ENTRADAS', ''),
                          _dataRow('   - Precio',
                              'S/.${e.precioUnd.toStringAsFixed(2)}'),
                          _dataRow('   - Und. Medida ', e.unidMedida),
                          
                          _dataRow('SALIDAS', ''),
                          _dataRow('   - Precio und.',
                              'S/.${e.precioUnidadSalidaGrupo.toStringAsFixed(2)}'),
                          _dataRow('   - Und. Medida', e.unidMedidaSalida),
                          DataRow(cells: [
                            //CODUMENTO Receta
                            const DataCell(H3Text(
                              text: 'DOCUMENTO',
                              fontWeight: FontWeight.bold,
                            )),
                            DataCell(
                                //H3Text(text: e.documentUsoPreparacionReceta)
                                TextButton.icon(
                                    onPressed: () {
                                      if (e.documentUsoPreparacionReceta
                                          .isNotEmpty) {
                                        _launchURL(
                                            'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.documentUsoPreparacionReceta}');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'No hay documento disponible'),
                                            duration: Duration(
                                                seconds:
                                                    3), // Puedes ajustar la duración según tus preferencias
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.open_in_new),
                                    label: e.documentUsoPreparacionReceta
                                            .isNotEmpty
                                        ? const H3Text(text: '')
                                        : const H3Text(text: 'N/A'))),
                          ]),
                          // _dataRow('Total Entradas',
                          //     e.cantidadEntrada.toStringAsFixed(2).toString()),
                          // _dataRow('Total Salidas',
                          //     e.cantidadSalida.toStringAsFixed(2).toString()),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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

  DataRow _dataRow(String campo, String description) {
    return DataRow(
      cells: [
        DataCell(H3Text(
          text: campo,
          fontWeight: FontWeight.bold,
        )),
        DataCell(H3Text(text: description)),
      ],
    );
  }
}
