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
            physics: const ClampingScrollPhysics(), //Comportamiento de desplazamiento si nefecto de rebote.
            child: Container(
              margin: const EdgeInsets.all(10),
              constraints: const BoxConstraints(maxWidth: 450),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    H1Text(
                      text: e.producto,
                      fontWeight: FontWeight.w900,
                    ),
                    const Divider(
                      thickness: 4,
                    ),
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
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      child: DataTable(
                          headingRowHeight: 20,
                          dataRowHeight: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          columns: const [
                            DataColumn(label: Text('Campo')),
                            DataColumn(label: Text('Descripción')),
                          ],
                          rows: [
                            _dataRow('Ubicación',
                                e.nombreUbicacion.toString()),
                            _dataRow('Categoria', e.categoria),
                            _dataRow('Producto', e.producto),
                            _dataRow('fecha Vencimiento',
                                formatFecha(e.fechaVencimiento!)),
                            _dataRow('Tipo Producto', e.tipoProducto),
                            _dataRow(
                                'Proveedor', e.nombreEmpresaProveedor),
                            _dataRow(
                                'Total Entradas',
                                e.cantidadEntrada
                                    .toStringAsFixed(2)
                                    .toString()),
                            _dataRow(
                                'Total Salidas',
                                e.cantidadSalida
                                    .toStringAsFixed(2)
                                    .toString()),
                            _dataRow('Existencias',
                                e.stock.toStringAsFixed(2).toString()),
                            _dataRow('Estado Fecha', e.estadoFecha),
                            _dataRow('Estado Stock', e.estadoStock),
                            _dataRow('Precio Entrada',
                                'S/.${e.precioUnd.toStringAsFixed(2)}'),
                            _dataRow(
                                'Und. Medida Entrada', e.unidMedida),
                            _dataRow(
                                'Marca Producto', e.marcaProducto),
                            _dataRow('Precio und. Salida Grupos',
                                'S/.${e.precioUnidadSalidaGrupo.toStringAsFixed(2)}'),
                            _dataRow('Und. Medida Salida Grupos',
                                e.unidMedidaSalida),
                            DataRow(cells: [
                              //CODUMENTO Receta
                              const DataCell(H3Text(
                                text: 'Uso Receta  PDF',
                                fontWeight: FontWeight.bold,
                              )),
                              DataCell(
                                  //H3Text(text: e.documentUsoPreparacionReceta)
                                  TextButton.icon(
                                      onPressed: () {
                                        if (e
                                            .documentUsoPreparacionReceta
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
                                      label: e
                                              .documentUsoPreparacionReceta
                                              .isNotEmpty
                                          ? const H3Text(text: '')
                                          : const H3Text(text: 'N/A'))),
                            ]),
                            _dataRow('GENERAL', ''),
                            // _dataRow('id Vista', widget.e.id.toString()),
                            // _dataRow('id_Ubicación',
                            //     widget.e.idUbicaion.toString()),
                            // _dataRow('id_Categoria', widget.e.idCategoria),
                            // _dataRow('id_Producto', widget.e.idProducto),
                            // _dataRow('Id_Proveedor', widget.e.idProveedor),
                            _dataRow('created:',
                                formatFechaHoraNow(e.fechaCreacion)),
                            _dataRow('updated: ',
                                formatFechaHoraNow(e.fechaModificacion)),
                            // _dataRow('collectionId',
                            //     widget.e.collectionId.toString()),
                            // _dataRow('collectionName',
                            //     widget.e.collectionName.toString()),
                          ]),
                    ),
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
