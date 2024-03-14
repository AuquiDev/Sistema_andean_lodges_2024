// ignore_for_file: unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_asistencia.dart';
import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/pages3/t_asistencia_details.dart';
import 'package:ausangate_op/pages3/t_pdf_export_asistencias.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
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


    
    return Flexible(
        flex: 1,
        child: GestureDetector(
          onTap: () {
            // Cierra el teclado cuando tocas en cualquier lugar de la pantalla
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              showAppBar
                  ? Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: H2Text(
                                text: 'Filtrar por Codígo de Grupo',
                                color: Color(0x67342E2E),
                                fontSize: 10,
                              ),
                            ),
                            ButtonBar(
                              buttonPadding: const EdgeInsets.all(0),
                              children: [
                                // LISTA DE USUARIOS
                                ScrollWeb(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: ElevatedButton(
                                              style: buttonStyle(),
                                              onPressed: () {
                                                _filterTEmpleados('');
                                                _filterTEntradas('');
                                                tituloEmpleado = 'Lista General';
                                              },
                                              child: const H2Text(
                                                text: 'Lista\nGeneral',
                                                fontSize: 10,
                                                maxLines: 2,
                                              )),
                                        ),
                                        ...List.generate(
                                            listaDetallTrabajo.length, (index) {
                                          final e = listaDetallTrabajo.reversed
                                              .toList()[index];
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            width: 90,
                                            child: ElevatedButton(
                                                style: _buttonstyle1(),
                                                onPressed: () {
                                                  _filterTEmpleados(
                                                      e.id.toString());
                                                  _filterTEntradas('');
                                                  tituloEmpleado = e.codigoGrupo;
                                                },
                                                child: FittedBox(
                                                  child: H2Text(
                                                    text: e.codigoGrupo,
                                                    fontSize: 15,
                                                    maxLines: 2,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 280,
                    constraints: const BoxConstraints(maxWidth: 350),
                    height: 50,
                    margin: const EdgeInsets.only(
                        top: 5, left: 10, right: 10, bottom: 5),
                    decoration: BoxDecoration(boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, .3),
                        blurRadius: 2,
                        color: Color(0xFFB0B0B0),
                      ),
                    ], borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                        controller: _searchTextEditingController,
                        onChanged: (value) {
                          _filterTEntradas(value);
                        },
                        decoration: decorationTextField(
                          hintText: 'Escribe algo...',
                          labelText: 'Filtrar por nombre o rol',
                          prefixIcon: IconButton(
                              onPressed: () {
                                _searchTextEditingController.clear();
                                _filterTEntradas('');
                              },
                              icon: _searchTextEditingController.text.isEmpty
                                  ? const Icon(Icons.search)
                                  : const Icon(Icons.close)),
                        )),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  // PDFExportAsistencia(
                  //     listaTproductos: filterTProductos,
                  //     tituloEmpleado: tituloEmpleado),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H2Text(
                      text: tituloEmpleado,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF5B5353)),
                  H2Text(
                      text: ' ( ${filterTProductos.length} regs.)',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF5B5353)),
                ],
              ),
              ListTAsistencias(
                listaTproductos: filterTProductos,
                scrollController: _scrollController,
                showAppBar: showAppBar,
              )
            ],
          ),
        ));
  }

  ButtonStyle buttonStyle() {
    return const ButtonStyle(
      elevation: MaterialStatePropertyAll(3),
      visualDensity: VisualDensity.compact,
      overlayColor: MaterialStatePropertyAll(Colors.yellow),
    );
  }

  ButtonStyle _buttonstyle1() {
    return const ButtonStyle(
        elevation: MaterialStatePropertyAll(2),
        backgroundColor: MaterialStatePropertyAll(
          Color(0xFF069D54),
        ),
        overlayColor: MaterialStatePropertyAll(Colors.white),
        visualDensity: VisualDensity.compact,
        padding: MaterialStatePropertyAll(EdgeInsets.all(5)));
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
          '${e.created!.year}-${e.created!.month.toString().padLeft(2, '0')}';

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
      
    return Expanded(
      child: ScrollWeb(
        child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 20, bottom: 180),
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final fechaKey = sortedKeys.reversed.toList()[index];
              final entradaFcreacion = fechaFilter[fechaKey];
              //ORDENAR LA SUBLISTA
              entradaFcreacion!.sort((a, b) => a.created!.compareTo(b.created!));
        
              DateTime fechaDateTime = DateTime.parse('$fechaKey-01');
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        H2Text(
                          text: fechaFiltrada(fechaDateTime),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0xFF069D54),
                        ),
                        Text(
                          '${entradaFcreacion.length} regs.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF069D54),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color(0xFF069D54),
                  ),
                  if (entradaFcreacion.isNotEmpty)
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, left: 5,right: 5),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entradaFcreacion.length,
                      itemBuilder: (BuildContext context, int index) {
                        final e = entradaFcreacion.reversed.toList()[index];
                        return Card(
                      surfaceTintColor: Colors.white,
                      elevation: 10,
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
                            leading: IconButton.outlined(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Editing(e: e),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          
                          ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: H2Text(
                                      text: e.nombrePersonal,
                                      fontSize: 14,
                                    )),
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFD5E8BF),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: H2Text(
                                          text: e.actividadRol.toString(),
                                          fontSize: 12,
                                          color: const Color(0xFF4E2A06),
                                        ))),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H2Text(
                                  text:
                                      'H. Entr.:  ${formatFechaHoraNow(e.horaEntrada)}',
                                  fontSize: 10,
                                ),
                                H2Text(
                                  text:
                                      'H. Sal. :  ${e.horaSalida!.year != 1998 ? formatFechaHoraNow(e.horaSalida!) : "No registrado"}',
                                  fontSize: 10,
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: (e.id!.isNotEmpty && e.id! != null)
                                  ? const Color(0xFF2BB12F)
                                  : Colors.black26,
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
