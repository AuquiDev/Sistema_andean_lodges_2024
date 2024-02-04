import 'package:ausangate_op/pages2/historial_salidas_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ausangate_op/models/model_v_gastos_grupo_salidas.dart';
import 'package:ausangate_op/models/model_v_historial_salidas_productos.dart';

import 'package:ausangate_op/provider/provider_v_historial_salidas_productos.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';

class GastosDetailsPage extends StatelessWidget {
  const GastosDetailsPage({
    super.key,
    required this.e,
  });
  final ViewGastosGrupoSalidasModel e;

  @override
  Widget build(BuildContext context) {
    final dataHistorialSalidas = 
        Provider.of<ViewHistorialSalidasProductosProvider>(context);
    List<ViewHistorialSalidasProductosModel> listaHistorial =
        dataHistorialSalidas.listHistorialSalidas;
    return DefaultTabController(
      length: 2,
      child: Center(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 30,
            centerTitle: false,
            title: H2Text(
              text: 'Detalles de grupo ${e.codigoGrupo}'.toUpperCase(),
              fontWeight: FontWeight.w900,
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Tabla Gastos'), // Nombre de la primera pestaña
                Tab(text: 'Historial Salidas'), // Nombre de la segunda pestaña
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TablaGastosWidget(
                e: e,
              ),
              HistorialSalidasWidget(
                listaHistorial: listaHistorial,
                codigoGrupo: e.codigoGrupo,
                idCodigoGrupo: e.idCodigoGrupo,
                montoTotalInversion: e.montoTotalInversion
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TablaGastosWidget extends StatelessWidget {
  const TablaGastosWidget({
    super.key,
    required this.e,
  });
  final ViewGastosGrupoSalidasModel e;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  text: e.descripcion,
                  maxLines: 10,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: DataTable(
                headingRowHeight: 20,
                // ignore: deprecated_member_use
                dataRowHeight: 35,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                columns: const [
                  DataColumn(label: Text('Campo')),
                  DataColumn(label: Text('Descripción')),
                ],
                rows: [
                  _dataRow('Fecha Inicio', formatFecha(e.fechaInicio).toString()),
                  _dataRow('Fecha Fin', formatFecha(e.fechaFin)),
                  _dataRow('Cantidad de Dias', e.cantidadDias.toString()),
                  _dataRow('Tipo de Trabajo', e.categoriaOTipoDeTrabajo),
                  _dataRow('Codígo de Grupo', e.codigoGrupo),
                  _dataRow('Grupo', e.grupo),
                  _dataRow('Monto Inversión',
                      'S/.${e.montoTotalInversion.toStringAsFixed(2)}'),
                  _dataRow('GENERAL', ''),
                  _dataRow('id', e.id.toString()),
                  _dataRow('fecha de Creación', formatFecha(e.fcreated)),
                  _dataRow('fecha de Modificación', formatFecha(e.fupdated)),
                  _dataRow('collectionId', e.collectionId.toString()),
                ]),
          ),
        ],
      ),
    );
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
