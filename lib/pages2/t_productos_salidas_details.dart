
// ignore_for_file: deprecated_member_use

import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetallesPage extends StatelessWidget {
  const DetallesPage({
    super.key,
    required this.e,
    required this.categoria,
    required this.ubicacion, 
    required this.proveedor,
     required ScrollController scrollController,
    required this.showAppBar,
  }) : _scrollController = scrollController;

  final TProductosAppModel e;
  final String categoria;
  final String ubicacion;
  final String proveedor;
  final ScrollController _scrollController;
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
         showAppBar ?  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H3Text(
                  text:
                      'Descripción (restriciones, detalles de grupo, recomendaciones):'
                          .toUpperCase(),
                  maxLines: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF06685E),
                ),
                H3Text(
                  text: e.descripcionUbicDetll,
                  maxLines: 10,
                ),
              ],
            ),
          ):const SizedBox(),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
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
                  _dataRow('Categoría', categoria),
                  // _dataRow('Ubicación', obtenerUbicacion(e.idUbicacion)),
                  // _dataRow('Proveedor',obtenerProveedor(e.idProveedor)),
                  _dataRow('Nombre', e.nombreProducto),
                  _dataRow('Marca', e.marcaProducto),
                  // _dataRow('Existencia', stock),
                  _dataRow('', ''),
                  _dataRow('und. Medida de Entreda', e.unidMedida),
                  _dataRow(
                      'Precio Entrada', 'S/.${e.precioUnd.toStringAsFixed(2)}'),
                  _dataRow('und. Medida Salida', e.unidMedidaSalida),
                  _dataRow('Precio Salida',
                      'S/.${e.precioUnidadSalidaGrupo.toStringAsFixed(2)}'),

                  _dataRow('Tipo', e.tipoProducto),
                   _dataRow('Proveedor', proveedor),
                  _dataRow(
                      'Fecha Vencimiento', formatFecha(e.fechaVencimiento)),
                  _dataRow('Estado', e.estado == true ? 'Visible' : 'Oculto'),
                  DataRow(cells: [
                    //CODUMENTO Receta
                    const DataCell(H3Text(
                      text: 'Uso Receta  PDF',
                      fontWeight: FontWeight.bold,
                    )),
                    DataCell(TextButton.icon(
                        onPressed: () {
                          if (e.documentUsoPreparacionReceta != null &&  e.documentUsoPreparacionReceta!.isNotEmpty) {
                            _launchURL(
                                'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.documentUsoPreparacionReceta}');
                          } else {
                            _messageDialog(context);
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: e.documentUsoPreparacionReceta != null && e.documentUsoPreparacionReceta!.isNotEmpty
                            ? const H3Text(text: '')
                            : const H3Text(text: 'N/A'))),
                  ]),
                  _dataRow('', ''),
                  _dataRow('Creación', formatFechaHora(e.created!)),
                  _dataRow('ultima Modificación', formatFechaHora(e.updated!)),
                ]),
          ),
        ],
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
