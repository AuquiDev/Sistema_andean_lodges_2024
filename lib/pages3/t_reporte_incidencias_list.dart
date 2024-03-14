// ignore_for_file: unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/models/model_t_reporte_incidencias.dart';
import 'package:ausangate_op/pages3/t_pdf_export_reporte.incidencias.dart';
import 'package:ausangate_op/pages3/t_reporte_incidencias_page.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/provider/provider_t_reporte_incidencias.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ListaReporteIncidencias extends StatelessWidget {
  const ListaReporteIncidencias({super.key});

  @override
  Widget build(BuildContext context) {
     //Lista de Reporte PAx
     final listaReportePaxAPI =Provider.of<TReporteIncidenciasProvider>(context).listaIncidencias;


    List<TReporteIncidenciasModel> listareporte = listaReportePaxAPI;
    return ListReportePax(listAsitencia: listareporte,);
  }
}

class ListReportePax extends StatefulWidget {
  const ListReportePax({
    super.key,
    required this.listAsitencia,
  });
  final List<TReporteIncidenciasModel> listAsitencia;
  @override
  State<ListReportePax> createState() => _ListReportePaxState();
}

class _ListReportePaxState extends State<ListReportePax> {
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
  late List<TReporteIncidenciasModel> filterTidEmpleado;

  //Le tenemos que pasar como parametro el id de trabajo, para filtrado por grupo
  _filterTEmpleados(String searchText) {
    filterTidEmpleado = widget.listAsitencia
        .where((e) => e.idTrabajo.contains(searchText))
        .toList();
  }

  //FILTRAMOS lal ogica del buscador de producto en base a lista filtrada de ubicacion
  late TextEditingController _searchTextEditingController;
  late List<TReporteIncidenciasModel> filterTProductos;
  _filterTEntradas(String seachText) {
    setState(() {
      filterTProductos = filterTidEmpleado
          .where((e) =>
              e.idEmpleados
                  .toLowerCase()
                  .contains(seachText.toLowerCase()) ||
              e.pregunta1.toLowerCase().contains(seachText.toLowerCase()))
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


    List<TDetalleTrabajoModel> listaDetallTrabajo =listatrabajoApi;

    listaDetallTrabajo.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));

   
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 130,
          toolbarHeight: 70,
          leading:  ElevatedButton(
                            style: _botonStyle(),
                            onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> const EditReportPageIncidencias()));
                            },child:  _labelText(label: 'Nueva\nEncuesta')),
          title: showAppBar
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
                                    ...List.generate(listaDetallTrabajo.length,
                                        (index) {
                                      final e = listaDetallTrabajo.reversed
                                          .toList()[index];
                                      return Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        width: 90,
                                        child: ElevatedButton(
                                            style: _buttonstyle1(),
                                            onPressed: () {
                                              _filterTEmpleados(e.id.toString());
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
        ),
        body: GestureDetector(
          onTap: () {
            // Cierra el teclado cuando tocas en cualquier lugar de la pantalla
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: Column(
              children: [
                
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
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
                                        icon: _searchTextEditingController
                                                .text.isEmpty
                                            ? const Icon(Icons.search)
                                            : const Icon(Icons.close)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          // PdfExportReporteIncidencias(
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
                    ],
                  ),
                ),
                ListTAsistencias(
                  listaTproductos: filterTProductos,
                  scrollController: _scrollController,
                  showAppBar: showAppBar,
                )
              ],
            ),
          ),
        ));
  }
  H2Text _labelText({String? label}) {
    return H2Text(
      text: label!,
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      maxLines: 2,
    );
  }
      ButtonStyle _botonStyle() {
    return const ButtonStyle(
        elevation: MaterialStatePropertyAll(2),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 6)),
        backgroundColor: MaterialStatePropertyAll(Colors.deepOrange),
        iconColor: MaterialStatePropertyAll(Colors.white),
        iconSize: MaterialStatePropertyAll(20));
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
  final List<TReporteIncidenciasModel> listaTproductos;
  final ScrollController _scrollController;
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    //FILTRADO Por fecha de creacion. agrupoar por mes y año
    Map<dynamic, List<TReporteIncidenciasModel>> fechaFilter = {};

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


    final listaGrupoAPi =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;

    List<TDetalleTrabajoModel> listaGrupos = listaGrupoAPi;

    final listaUsuarioAPI =
        Provider.of<TEmpleadoProvider>(context).listaEmpleados;
   

    List<TEmpleadoModel> listaUsuarios = listaUsuarioAPI;

    return Expanded(
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
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    // Calcular el número de columnas en función del ancho disponible
                    int crossAxisCount = (constraints.maxWidth / 200).floor();
                    // Puedes ajustar el valor 100 según tus necesidades
                    return ScrollWeb(
                      child: GridView.builder(
                        padding:
                            const EdgeInsets.only(bottom: 100, left: 5, right: 5),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                            childAspectRatio: 1),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: entradaFcreacion.length,
                        itemBuilder: (BuildContext context, int index) {
                          final e = entradaFcreacion.reversed.toList()[index];
                      
                          TDetalleTrabajoModel obtenerDetalleTrabajo(
                              String idTrabajo) {
                            for (var data in listaGrupos) {
                              if (data.id == e.idTrabajo) {
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
                      
                          final v = obtenerDetalleTrabajo(e.idTrabajo);
                      
                          //METODO OBTENER EL CODIGOP DE GRUP{O}
                          String obtenerGuia(String idEmpleados) {
                            for (var data in listaUsuarios) {
                              if (data.id == idEmpleados) {
                                return '${data.nombre} ${data.apellidoPaterno} ${data.apellidoMaterno}';
                              }
                            }
                            return '';
                          }
                      
                          final guia = obtenerGuia(e.idEmpleados);
                      
                          return Card(
                            surfaceTintColor:
                                const Color.fromARGB(255, 250, 246, 246),
                            elevation: 10,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF5F3113),
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.people_alt,
                                            size: 30,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: FittedBox(
                                              child: H2Text(
                                                text: v.codigoGrupo,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: (e.id!.isNotEmpty &&
                                                        e.id! != null)
                                                    ? const Color(0xFF89310B)
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                      
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const H2Text(
                                            text: 'Usuario  : ',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: H2Text(
                                              text: guia,
                                              fontSize: 12,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     const H2Text(
                                      //       text: 'Guia: ',
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //     Expanded(
                                      //       flex: 2,
                                      //       child: H2Text(
                                      //         text: guia,
                                      //         fontSize: 12,
                                      //         maxLines: 2,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                      
                                      //Solo se puede editar si el registro es reciente dentro de 10 min.
                                      if (DateTime.now().difference(e.created!) <
                                          const Duration(minutes: 1))
                                        Row(
                                          children: [
                                            IconButton.outlined(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditReportPageIncidencias(
                                                            e: e),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            const Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: H2Text(
                                                  text:
                                                      'Tiempo de edición durante 20 min. desde su creación',
                                                  fontSize: 9,
                                                  maxLines: 4,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
              ],
            );
          }),
    );
  }
}
