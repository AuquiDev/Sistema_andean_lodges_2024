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
import 'package:ausangate_op/utils/buton_style.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class ListaReporteIncidencias extends StatelessWidget {
  const ListaReporteIncidencias({super.key});

  @override
  Widget build(BuildContext context) {
    //Lista de Reporte PAx
    final listaReportePaxAPI =
        Provider.of<TReporteIncidenciasProvider>(context).listaIncidencias;
   

    List<TReporteIncidenciasModel> listareporte =
         listaReportePaxAPI;

    final dataServer = Provider.of<TDetalleTrabajoProvider>(context);
   
       bool isSaving = dataServer.isSyncing;

    return  !isSaving ? ListReportePax(
      listAsitencia: listareporte,
    ): const Center(child: CircularProgressIndicator(),);
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
              e.idEmpleados.toLowerCase().contains(seachText.toLowerCase()) ||
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
    final dataServer = Provider.of<TDetalleTrabajoProvider>(context);
    
    final listatrabajoApi = dataServer.listaDetallTrabajo;


    List<TDetalleTrabajoModel> listaDetallTrabajo =  listatrabajoApi;

    listaDetallTrabajo.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));
    //PARA EL DORWdown boton
    final userServer = Provider.of<TEmpleadoProvider>(context).listaEmpleados;
   

    TEmpleadoModel? selectedEmpleado;
    List<TEmpleadoModel> listEmpleados =  userServer;
    listEmpleados.sort((a, b) => a.nombre.compareTo(b.nombre));
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        // Cierra el teclado cuando tocas en cualquier lugar de la pantalla
        FocusScope.of(context).unfocus();
      },
      child: Center(
        child: Column(
          children: [
            showAppBar
                ? DelayedDisplay(
                    slidingBeginOffset: const Offset(0.0, -0.35),
                    delay: const Duration(milliseconds: 400),
                    child: Container(
                      // constraints: const BoxConstraints(maxWidth: 600),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: H1Text(
                                              text:
                                                  'Informe de Incidencias en Operación',
                                              fontWeight: FontWeight.bold,
                                              textAlign: TextAlign.center,
                                              color: Color(0xFF033C05)),
                                        ),
                                        H2Text(
                                          text: tituloEmpleado,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            H2Text(
                                              text:
                                                  '${filterTProductos.length}',
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
                                  RippleAnimation(
                                      color: const Color(0x22DDC1EC),
                                      delay: const Duration(milliseconds: 900),
                                      repeat: true,
                                      ripplesCount: 3,
                                      minRadius: 20,
                                      child: WidgetCircularAnimator(
                                        size: 65,
                                        innerColor: const Color(0x7CE91E62),
                                        outerColor: const Color(0x79FF4080),
                                        outerAnimation: Curves.elasticInOut,
                                        child: GestureDetector(
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const EditReportPageIncidencias()));
                                            },
                                            child: const Center(
                                              child: H2Text(
                                                text: 'Nuevo',
                                                color: Color(0xFFC73063),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: ScrollWeb(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listaDetallTrabajo.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final e = listaDetallTrabajo.reversed
                                        .toList()[index];
                                    return OutlinedButton(
                                        style: buttonStyle2(),
                                        onPressed: () {
                                          _filterTEmpleados(e.id.toString());
                                          _filterTEntradas('');
                                          tituloEmpleado = e.codigoGrupo;
                                        },
                                        child: FittedBox(
                                          child: H2Text(
                                            text: e.codigoGrupo,
                                            fontSize: 13,
                                            maxLines: 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Flexible(
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                            style: buttonStyle2(),
                            onPressed: () {
                              _filterTEmpleados('');
                              _filterTEntradas('');
                              tituloEmpleado = 'Lista General';
                            },
                            child: const H2Text(
                              text: 'General',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            )),
                        PdfExportReporteIncidencias(
                            listaTproductos: filterTProductos,
                            tituloEmpleado: tituloEmpleado),
                        Expanded(
                          child: Card(
                            child: DropdownButtonFormField<TEmpleadoModel>(
                              items: listEmpleados.map((TEmpleadoModel empleado) {
                                return DropdownMenuItem<TEmpleadoModel>(
                                  value: empleado,
                                  child: Text(empleado.nombre),
                                );
                              }).toList(),
                              value: selectedEmpleado,
                                // controller: _searchTextEditingController,
                                onChanged: (value) {
                                 setState(() {
                                  selectedEmpleado = value;
                                  _filterTEntradas(value?.id.toString() ?? ''); // Filtra por ID si se selecciona un empleado
                                });
                                },
                                decoration: decorationTextField(
                                  hintText: 'Selecciona un empleado',
                                  labelText: 'Empleado',
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
                      ],
                    ),
                  ),
                  ListTAsistencias(
                    listaTproductos: filterTProductos,
                    scrollController: _scrollController,
                    showAppBar: showAppBar,
                  ),
                ],
              ),
            ),
          ],
        ),
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
      child: ScrollWeb(
        child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * .1, horizontal: 5),
            itemCount: sortedKeys.length,
            separatorBuilder: (BuildContext context, int index) {
              return Image.asset(
                'assets/img/andeanlodges.png',
                height: 40,
                color: const Color(0xFF6F1551),
              );
            },
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            H2Text(
                                text: fechaFiltrada(fechaDateTime),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: const Color(0xFF6F1551)),
                            H2Text(
                                text: '${entradaFcreacion.length} regs.',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6F1551)),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  if (entradaFcreacion.isNotEmpty)
                    LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      // Calcular el número de columnas en función del ancho disponible
                      int crossAxisCount = (constraints.maxWidth / 170).floor();
                      // Puedes ajustar el valor 100 según tus necesidades
                      return GridView.builder(
                        padding: const EdgeInsets.only(
                          bottom: 80,
                        ),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0.5,
                            childAspectRatio: 1),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: entradaFcreacion.length,
                        itemBuilder: (BuildContext context, int index) {
                          final e = entradaFcreacion.reversed.toList()[index];
        
                          String obtenerDetalleTrabajo(String idTrabajo) {
                            for (var data in listaGrupos) {
                              if (data.id == e.idTrabajo) {
                                return data.codigoGrupo;
                              }
                            }
                            return '';
                          }
        
                          final codigo = obtenerDetalleTrabajo(e.idTrabajo);
        
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
        
                          String validarRespuestas() {
                             final List<String?> preguntas = [
                              e.pregunta1,
                              e.pregunta2,
                              e.pregunta3,
                              e.pregunta4,
                              e.pregunta5,
                              e.pregunta6,
                              e.pregunta7,
                            ];
        
                            int preguntasLlenas = 0;
        
                            // Contar la cantidad de preguntas no vacías
                            for (String? pregunta in preguntas) {
                              if (pregunta != null && pregunta.isNotEmpty) {
                                preguntasLlenas++;
                              }
                            }
        
                            if (preguntasLlenas == 7) {
                               return ('[ 7 -7 ] resp.');
                            } else {
                              return ('[ $preguntasLlenas - 7 ] resp.');
                            }
                          }
        
                          String respuestas = validarRespuestas();
        
                          return DelayedDisplay(
                            delay: const Duration(seconds: 1),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF3E524F)
                                              .withOpacity(.5),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(1))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          H2Text(
                                              text: codigo,
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: (e.id!.isNotEmpty &&
                                                      e.id! != null)
                                                  ? Colors.black
                                                  : Colors.red),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const H2Text(
                                                  text: 'USER : ',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF3E524F)),
                                              Flexible(
                                                child: H2Text(
                                                  text: guia,
                                                  fontSize: 13,
                                                  maxLines: 2,
                                                  color: const Color(0xFF343525),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: const Color(0xFF3E524F)
                                                .withOpacity(.2),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.check_circle_outline_rounded,
                                                  color: Color(0xFF3E524F)),
                                              Flexible(
                                                child: H2Text(
                                                  text: respuestas,
                                                  fontSize: 13,
                                                  maxLines: 2,
                                                  color: const Color(0xFF343525),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: const Color(0xFF3E524F)
                                                .withOpacity(.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                //Solo se puede editar si el registro es reciente dentro de 10 min.
                                if (DateTime.now().difference(e.created!) <
                                    const Duration(minutes: 2))
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton.outlined(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditReportPageIncidencias(e: e),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                ],
              );
            }),
      ),
    );
  }
}
