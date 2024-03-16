// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:ausangate_op/models/model_t_asistencia.dart';
import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/pages/t_asistencia_editing.dart';
import 'package:ausangate_op/provider/provider_t_asistencia.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsAsistencia extends StatefulWidget {
  const DetailsAsistencia({
    super.key,
    required this.e,
  });
  final TAsistenciaModel e;

  @override
  State<DetailsAsistencia> createState() => _DetailsAsistenciaState();
}

class _DetailsAsistenciaState extends State<DetailsAsistencia> {
  @override
  Widget build(BuildContext context) {
    final lisDetalleTrabajo =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
    TDetalleTrabajoModel obtenerDetalleTrabajo(String idTrabajo) {
      for (var data in lisDetalleTrabajo) {
        if (data.id == widget.e.idTrabajo) {
          return data;
        }
      }
      return TDetalleTrabajoModel(
          codigoGrupo: '',
          idRestriccionAlimentos: '',
          idCantidadPaxguia: '',
          idItinerariodiasnoches: '',
          idTipogasto: '',
          fechaInicio: DateTime.now(),
          fechaFin: DateTime.now(),
          descripcion: '',
          costoAsociados: 0);
    }

    final v = obtenerDetalleTrabajo(widget.e.idTrabajo);

    final isSavingSerer = Provider.of<TAsistenciaProvider>(context).isSyncing;
    bool isavingProvider =  isSavingSerer;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: isavingProvider
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     
                      H2Text(
                        text:
                            '${widget.e.nombrePersonal} | ${widget.e.actividadRol}',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        maxLines: 2,
                      ),
                       H2Text(
                        text: 'Grupo:  ${v.codigoGrupo}',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: ListTile(
                          title: Column(
                            children: [
                              Image.asset(
                                'assets/img/andeanlodges.png',
                                width: 150,
                              ),
                             const H2Text(text: 'Detalles de la Asistencia'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: OutlinedButton(
                                      style: const ButtonStyle(
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: null,
                                      child: FittedBox(
                                        child: H2Text(
                                          text:
                                              'HORA ENTRADA\n${formatFechaHoraNow(widget.e.horaEntrada)}',
                                          fontSize: 12,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(),
                                  Flexible(
                                    flex: 1,
                                    child: OutlinedButton(
                                      style: const ButtonStyle(
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: null,
                                      child: FittedBox(
                                        child: H2Text(
                                          text:
                                              'HORA SALIDA\n${widget.e.horaSalida!.year != 1998 ? formatFechaHoraNow(widget.e.horaSalida!) : "No registrado"}',
                                          fontSize: 12,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              H2Text(
                                text:
                                    'DETALLES:\n  ${widget.e.detalles.isNotEmpty ? widget.e.detalles : 'no se ha registrado detalles de asistencia.'}',
                                fontSize: 12,
                                maxLines: 100,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          bool confirmDelete = await _confirmDelete(context);
                          if (confirmDelete) {
                            Navigator.pop(context);
                          } else {
                            print('No Elimiando');
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: const H2Text(
                          text: '¿Desea eliminar este registro?',
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      FormularioAsistencia(e: widget.e)
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {

    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Desea eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await context
                        .read<TAsistenciaProvider>()
                        .deleteTAsistenciaApp(
                          widget.e.id!,
                        );
                Navigator.of(context).pop(true);
                snackDelete(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    return result;
  }

  void snackDelete(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: H2Text(
          text:
              '✅ Registro eliminado exitosamente. Vuelve a la página anterior para visualizar los cambios.',
          maxLines: 3,
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class Editing extends StatelessWidget {
  const Editing({
    super.key,
    required this.e,
  });

  final TAsistenciaModel e;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const H2Text(text: 'Editar Asistencia'),
        ),
        body: Column(
          children: [
            FormularioAsistencia(e: e),
          ],
        ));
  }
}
