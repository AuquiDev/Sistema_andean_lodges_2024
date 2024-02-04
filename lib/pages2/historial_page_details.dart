import 'package:ausangate_op/models/model_v_historial_salidas_productos.dart';
import 'package:flutter/material.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/widgets/imagen_path_productos.dart';


class HistorialPageDetails extends StatelessWidget {
  const HistorialPageDetails({
    super.key,required this.e,
  });
  final ViewHistorialSalidasProductosModel e;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: H2Text(text:e.producto, fontSize: 16,maxLines: 2,fontWeight: FontWeight.w900,),
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H3Text(
                  text:
                      'Descripción Salida (Uso, Preparación, recomendaciones):'
                          .toUpperCase(),
                  maxLines: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF06685E),
                ),
               Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*.5,
                  child: H3Text(
                    text: e.descripcionSalida.isNotEmpty ? e.descripcionSalida : 'N/A',
                    maxLines: 10,
                  ),
                ),
                ImageDetailsHistorialSalidas(
                        e: e,
                        size: 70,
                      ),
                ],
               )
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
                 
                  _dataRow('Fecha V. Producto', formatFecha(e.fechaVencimeintoProducto)),
                  _dataRow('Tipo Producto', e.tipoProducto),
                  _dataRow('Unid. Medida Salida', e.unidMedidaSalida),
                  _dataRow('Cantidad Salida', e.cantidadSalida.toString()),
                  _dataRow('Precio Uind. Salida','S/.${e.precioUnidadSalidaGrupo}'),
                  _dataRow('Monto Total','S/.${e.montoTotalSalida}'),
                  _dataRow('Almacén Salida', e.nombreUbicacion),
                  _dataRow('Fecha Registro Salida', formatFecha(e.fechaRegistroSalida)),
                  _dataRow('Entregado a..', e.nombreEmpleado),
                  _dataRow('Cargo i/o Puesto', e.cargoPuesto),
                  _dataRow('Codigo Grupo', e.codigoGrupo),
                 
                  _dataRow('Itinerario Grupo', e.grupo),
                  _dataRow('Fecha Entrada Grupo', formatFecha(e.fechaInicio)),
                  _dataRow('Fecha Retorno Grupo', formatFecha(e.fechaFin)),
                  _dataRow('Categoría Tipo Trabajo', e.categoriaOTipoDeTrabajo),
                  _dataRow('GENERAL', ''),
                   _dataRow('Id Registro', e.id.toString()),
                  _dataRow('Id Producto', e.idProducto),
                   _dataRow('id_codigoGrupo', e.idCodigoGrupo),
                  _dataRow('F. Creación Registro', formatFecha(e.fcreated)),
                   _dataRow('F. modificación Registro', formatFecha(e.fcreated)),
                 
                ]),
          ),
        ],
            ),
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
