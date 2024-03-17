
import 'package:ausangate_op/models/model_t_entradas.dart';
import 'package:ausangate_op/models/model_t_salidas.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorialRotacionStock extends StatelessWidget {
  const HistorialRotacionStock({
    Key? key,
    required this.entradas,
    required this.salidas,
  }) : super(key: key);

  final List<TEntradasModel> entradas;
  final List<TSalidasAppModel> salidas;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(children: [
            const H2Text(
              text: 'Historial de Entradas:',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            ...List.generate(entradas.length, (index) {
              final en = entradas[index];
              Color color = index % 2 == 0
                  ? const Color(0x8EE2E1E1)
                  : const Color(0xFFFFFFFF);
              return _customListTileEntradas(color, en);
            }),
          ]),
        ),
        const SizedBox(width: 35),
        Expanded(
          child: Column(children: [
            const H2Text(
              text: 'Historial de Salidas:',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            ...List.generate(salidas.length, (index) {
              final en = salidas[index];
              final listaGrupoAPi =
                  Provider.of<TDetalleTrabajoProvider>(context)
                      .listaDetallTrabajo;
              String obtenerDetalleTrabajo(String idTrabajo) {
                for (var data in listaGrupoAPi) {
                  if (data.id == idTrabajo) {
                    return data.codigoGrupo;
                  }
                }
                return '---';
              }

              final codigo = obtenerDetalleTrabajo(en.idTrabajo);

              Color color = index % 2 == 0
                  ? const Color(0x8EE2E1E1)
                  : const Color(0xFFFFFFFF);

              return _customListTileSalidas(color, en, codigo);
            }),
          ]),
        ),
      ],
    );
  }

  Container _customListTileSalidas(
      Color color, TSalidasAppModel en, String codigo) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      color: color,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.all(5),
        // subtitle:,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2Text(
              text: formatFecha(en.created!),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            Table(
              border: TableBorder.all(width: 2, color: Colors.black26),
              children: [
                TableRow(children: [
                  _content(color, en.cantidadSalida.toString(), 'Cantidad'),
                  _content(color, codigo, 'Código Grupo')
                ]),
              ],
            ),
            H2Text(
              text: en.descripcionSalida,
              fontSize: 10,
              maxLines: 50,
            ),
          ],
        ),
      ),
    );
  }

  Container _customListTileEntradas(Color color, TEntradasModel en) {
    return Container(
      color: color,
      constraints: const BoxConstraints(maxWidth: 500),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.all(5),
        subtitle: Table(
          border: TableBorder.all(width: 2, color: Colors.black26),
          children: [
            TableRow(children: [
              _content(color, en.cantidadEntrada.toString(), 'Cantidad'),
              _content(color, en.precioEntrada.toString(), 'Precio'),
              _content(color, en.costoTotal.toString(), 'Total'),
            ]),
          ],
        ),
        title: H2Text(
          text: formatFecha(en.created!),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container _content(Color color, String value, String text) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: H2Text(
                text: value,
                fontSize: 14,
              ),
            ),
            FittedBox(
              child: H2Text(
                text: text,
                fontSize: 10,
                maxLines: 30,
              ),
            ),
          ],
        ));
  }
}
