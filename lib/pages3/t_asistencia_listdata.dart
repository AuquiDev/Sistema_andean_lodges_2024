// ignore_for_file: unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_asistencia.dart';
import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/pages3/t_asistencia_details.dart';
import 'package:ausangate_op/provider/provider_t_asistencia.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/utils/buton_style.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ListAsistencia extends StatefulWidget {
  const ListAsistencia({
    super.key,
    required this.listAsitencia,
  });
  final List<TAsistenciaModel> listAsitencia;
  @override
  State<ListAsistencia> createState() => _ListAsistenciaState();
}

class _ListAsistenciaState extends State<ListAsistencia> {
  final ScrollController _scrollController = ScrollController();
  bool showAppBar = true;

  void _onScroll() {
    //devulve el valor del scrollDirection.
    setState(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        //Scroll Abajo
        showAppBar = true;
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //Scroll Arriba
        showAppBar = false;
      }
    });
  }

  //FILTRAR NombreAsistencia logica del Buscador en botones
  late List<TAsistenciaModel> filterTidEmpleado;

  //Le tenemos que pasar como parametro el id de trabajo, para filtrado por grupo
  _filterTEmpleados(String searchText) {
    filterTidEmpleado = widget.listAsitencia
        .where((e) => e.idTrabajo.contains(searchText))
        .toList();
  }

  //FILTRAMOS lal ogica del buscador de producto en base a lista filtrada de ubicacion
  late TextEditingController _searchTextEditingController;
  late List<TAsistenciaModel> filterTProductos;
  _filterTEntradas(String seachText) {
    setState(() {
      filterTProductos = filterTidEmpleado
          .where((e) =>
              e.nombrePersonal
                  .toLowerCase()
                  .contains(seachText.toLowerCase()) ||
              e.actividadRol.toLowerCase().contains(seachText.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    filterTidEmpleado = widget.listAsitencia;
    _searchTextEditingController = TextEditingController();
    filterTProductos = filterTidEmpleado;
    super.initState();
    //Scroll controller
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

  //TEXTO nombre de ubicacion segun el boton se asigna el valor al titulo de ubicacion
  String tituloEmpleado = 'Lista General';

  @override
  Widget build(BuildContext context) {
    //LISTA GRUPOS ALMACÉN
    final listatrabajoApi =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;

    List<TDetalleTrabajoModel> listaDetallTrabajo = listatrabajoApi;

    listaDetallTrabajo.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));

    final isavingProvider = Provider.of<TAsistenciaProvider>(context).isSyncing;
    return Flexible(
        flex: 1,
        child: Center(
          child: Column(
            children: [
              showAppBar
                  ? DelayedDisplay(
                      slidingBeginOffset: const Offset(0.0, -0.35),
                      delay: const Duration(milliseconds: 400),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top:8.0),
                                  child: H1Text(
                                      text:
                                          'Gestión y Registro de Asistencias',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      textAlign: TextAlign.center,),
                                ),
                                H2Text(
                                  text: tituloEmpleado,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    H2Text(
                                      text: '${filterTProductos.length}',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.cyan,
                                    ),
                                    const H2Text(
                                      text: ' [ registros ]',
                                      fontSize: 10,
                                      // color: Colors.cyan,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listaDetallTrabajo.length,
                              itemBuilder: (BuildContext context, int index) {
                                final e = listaDetallTrabajo.reversed
                                    .toList()[index];
                                return ElevatedButton(
                                    style: buttonStyle2(),
                                    onPressed: () {
                                      _filterTEmpleados(e.id.toString());
                                      _filterTEntradas('');
                                      tituloEmpleado = e.codigoGrupo;
                                    },
                                    child: FittedBox(
                                      child: H2Text(
                                        text: e.codigoGrupo,
                                        fontSize: 14,
                                        // maxLines: 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              isavingProvider
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.black,
                    ))
                  : Flexible(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  style: buttonStyle2(),
                                  onPressed: () {
                                    _filterTEmpleados('');
                                    _filterTEntradas('');
                                    tituloEmpleado = 'Lista General';
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: H2Text(
                                      text: 'General',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              // PDFExportAsistencia(
                              //     listaTproductos: filterTProductos,
                              //     tituloEmpleado: tituloEmpleado),
                              Container(
                                height: 60, 
                                constraints:
                                    const BoxConstraints(maxWidth: 320),
                                child: Card(
                                  child: TextField(
                                      controller: _searchTextEditingController,
                                      onChanged: (value) {
                                        _filterTEntradas(value);
                                      },
                                      decoration: decorationTextField(
                                        hintText: 'Escribe el nombre',
                                        labelText: 'nombre de personal',
                                        prefixIcon: IconButton(
                                            onPressed: () {
                                              _searchTextEditingController
                                                  .clear();
                                              _filterTEntradas('');
                                            },
                                            icon: _searchTextEditingController
                                                    .text.isEmpty
                                                ? const Icon(Icons.search)
                                                : const Icon(Icons.close)),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          ListTAsistencias(
                            listaTproductos: filterTProductos,
                            scrollController: _scrollController,
                            showAppBar: showAppBar,
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ));
  }


}

class ListTAsistencias extends StatelessWidget {
  const ListTAsistencias({
    super.key,
    required this.listaTproductos,
    required ScrollController scrollController,
    required this.showAppBar,
  }) : _scrollController = scrollController;
  final List<TAsistenciaModel> listaTproductos;
  final ScrollController _scrollController;
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    //FILTRADO Por fecha de creacion. agrupoar por mes y año
    Map<dynamic, List<TAsistenciaModel>> fechaFilter = {};

    for (var e in listaTproductos) {
      String keyFecha =
          '${e.horaEntrada.year}-${e.horaEntrada.month.toString().padLeft(2, '0')}';

      if (!fechaFilter.containsKey(keyFecha)) {
        fechaFilter[keyFecha] = [];
      }
      fechaFilter[keyFecha]!.add(e);
    }

    // ORDEN ASCENDENTE: Convertir el Map a una Lista Ordenada por la clave (fecha)
    List<dynamic> sortedKeys = fechaFilter.keys.toList()
      ..sort(
        (a, b) => a.compareTo(b),
      );
    final listaGrupoAPi =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
   
    List<TDetalleTrabajoModel> listaGrupos =listaGrupoAPi;
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 20, bottom: 180),
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final fechaKey = sortedKeys.reversed.toList()[index];
              final entradaFcreacion = fechaFilter[fechaKey];
              //ORDENAR LA SUBLISTA
              entradaFcreacion!
                  .sort((a, b) => a.horaEntrada.compareTo(b.horaEntrada));

              DateTime fechaDateTime = DateTime.parse('$fechaKey-01');
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        H2Text(
                            text: fechaFiltrada(fechaDateTime),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: const Color(0xFF5B5353)),
                        Text(
                          '${entradaFcreacion.length} regs.',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5B5353)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF5B5353)),
                  if (entradaFcreacion.isNotEmpty)
                    ListView.builder(
                      padding: const EdgeInsets.only(
                          bottom: 100, left: 10, right: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entradaFcreacion.length,
                      itemBuilder: (BuildContext context, int index) {
                        final e = entradaFcreacion.reversed.toList()[index];
                        String obtenerDetalleTrabajo(String idTrabajo) {
                          for (var data in listaGrupos) {
                            if (data.id == idTrabajo) {
                              return data.codigoGrupo;
                            }
                          }
                          return '---';
                        }

                        final codigo = obtenerDetalleTrabajo(e.idTrabajo);
                        //Color intercalado
                        Color color = index % 2 == 0
                            ? const Color(0x3CE2E1E1)
                            : const Color(0xFFFFFFFF);
                        return Container(
                          color: color,
                          child: DelayedDisplay(
                            delay: const Duration(milliseconds: 500),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsAsistencia(
                                      e: e,
                                    ),
                                  ),
                                );
                              },
                              leading: const CircleAvatar(
                                backgroundColor: Colors.brown,
                                backgroundImage:
                                    AssetImage('assets/img/qr_logo.png'),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  H2Text(
                                    text:
                                        formatFechaPDfdiaMesAno(e.horaEntrada),
                                    fontSize: 10,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            H2Text(
                                              text: e.nombrePersonal,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            H2Text(
                                              text: e.actividadRol,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: 30,
                                        child: FittedBox(
                                          child: H2Text(
                                            text: codigo,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: (e.id!.isNotEmpty &&
                                                    e.id! != null)
                                                ? const Color(0xFF1B781E)
                                                : Colors.red,
                                          ),
                                        ),
                                      ),
                                      OutlinedButton(
                                        style: buttonStyle2(),
                                        onPressed: null,
                                        child: FittedBox(
                                          child: H2Text(
                                            text:
                                                'ENTRADA\n${formatFechaPDfhora(e.horaEntrada)}',
                                            fontSize: 10,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ),
                                      OutlinedButton(
                                        style: buttonStyle2(),
                                        onPressed: null,
                                        child: FittedBox(
                                          child: H2Text(
                                            text:
                                                'SALIDA\n${e.horaSalida!.year != 1998 ? formatFechaPDfhora(e.horaSalida!) : "----"}',
                                            fontSize: 10,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              );
            }),
      ),
    );
  }
}
