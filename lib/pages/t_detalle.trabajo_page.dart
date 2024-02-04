// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/models/model_t_salidas.dart';
import 'package:ausangate_op/pages2/t_detalle.trabajo_editing_page.dart';
import 'package:ausangate_op/provider/provider_t_det.itinerario.dart';
import 'package:ausangate_op/provider/provider_t_det.restricciones.dart';
import 'package:ausangate_op/provider/provider_t_det.tipo_gasto.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/provider/provider_t_detcand_paxguia.dart';
import 'package:ausangate_op/provider/provider_t_salidas.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class GrupoDetalleTrabajoPage extends StatefulWidget {
  const GrupoDetalleTrabajoPage({super.key});



  @override
  State<GrupoDetalleTrabajoPage> createState() =>
      _GrupoDetalleTrabajoPageState();
}

class _GrupoDetalleTrabajoPageState extends State<GrupoDetalleTrabajoPage> {
  @override
  Widget build(BuildContext context) {
    final listaGrupos = Provider.of<TDetalleTrabajoProvider>(context)
        .listaDetallTrabajo
      ..sort((a, b) => a.fechaFin.compareTo(b.fechaFin));
    return GruposLIstPages(
        listaGrupos: listaGrupos);
  }
}

class GruposLIstPages extends StatefulWidget {
  const GruposLIstPages({
    super.key, required this.listaGrupos,
  });

  final List<TDetalleTrabajoModel> listaGrupos;

  @override
  State<GruposLIstPages> createState() => _GruposLIstPagesState();
}

class _GruposLIstPagesState extends State<GruposLIstPages> {
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
  
  late TextEditingController _searchControllerGastos;
  late List<TDetalleTrabajoModel> filterLista;

  _filterProductos(String searchtext) {
    setState(() {
      filterLista = widget.listaGrupos
          .where((e) =>
              e.codigoGrupo.toLowerCase().contains(searchtext.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    _searchControllerGastos = TextEditingController();
    filterLista = widget.listaGrupos;
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchControllerGastos.dispose();

      _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: showAppBar
              ? AppBar(
                  // toolbarHeight: 40,
                  leading: const Icon(
                    Icons.circle,
                    color: Colors.transparent,
                  ),
                  leadingWidth: 0,
                  elevation: 0,
                  centerTitle: false,
                  surfaceTintColor: Colors.white,
                  title: const H2Text(
                    text: 'Gestión de Grupos',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 10)),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.deepOrange)),
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: const H2Text(
                          text: 'Nuevo',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GruposEditingPage()));
                        },
                      ),
                    )
                  ],
                )
              : null,
          body: Column(
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  width: 350,
                  constraints: const BoxConstraints(maxWidth: 350),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  height: 50,
                  decoration: BoxDecoration(boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 6,
                      spreadRadius: 3,
                      color: Colors.black12,
                    ),
                  ], borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _searchControllerGastos,
                    onTap: () {
                      _filterProductos(_searchControllerGastos.text);
                    },
                    onChanged: (value) {
                      _filterProductos(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: InkWell(
                          onTap: () {
                            _searchControllerGastos.clear();
                          },
                          child: const Icon(Icons.search)),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintText: "Buscar grupo",
                      hintStyle: const TextStyle(
                          color: Colors.black26, fontWeight: FontWeight.w500),
                      enabled: true,
                      border: _outlineButton(),
                      focusedBorder: _outlineButton(),
                      enabledBorder: _outlineButton(),
                      errorBorder: _outlineButton(),
                    ),
                  ),
                ),
              ),
              showAppBar
                  ? AlertGruposEnRuta(widget: widget)
                  : const SizedBox(),
                  
              FechaFilterListGrupos(widget: widget, filterLista: filterLista ,scrollController: _scrollController, showAppBar: showAppBar,)
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineButton() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}

class AlertGruposEnRuta extends StatelessWidget {
  const AlertGruposEnRuta({
    super.key,
    required this.widget,

  });

  final GruposLIstPages widget;

  @override
  Widget build(BuildContext context) {
    return ScrollWeb(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Row(
          children: [
            const Card(
              surfaceTintColor: Colors.red,
              color: Colors.red,
              elevation: 10,
              child: SizedBox(
                width: 170,
                        height: 90,
                child: Center(
                  child: H2Text(
                    text: 'Grupo\nen Ruta',
                    maxLines: 2,
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.black87,
            ),
            ...List.generate(widget.listaGrupos.length, (index) {
              DateTime hoy = DateTime.now();
              DateTime inicio = widget.listaGrupos[index].fechaInicio;
              DateTime fin = widget.listaGrupos[index].fechaFin;
              final e = widget.listaGrupos[index];
              // Extraer solo la fecha (ignorando la hora exacta)
              DateTime hoySinHora = DateTime(hoy.year, hoy.month, hoy.day);
              DateTime inicioSinHora = DateTime(inicio.year, inicio.month, inicio.day);
              DateTime finSinHora = DateTime(fin.year, fin.month, fin.day);
              //Para que la condicional funcione no se debe considerar la hora.
              if ((hoySinHora.isAfter(inicioSinHora) || hoySinHora.isAtSameMomentAs(inicioSinHora)) &&  (hoySinHora.isBefore(finSinHora) || hoySinHora.isAtSameMomentAs(finSinHora))) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GruposEditingPage(
                                  e: e,
                                )));
                  },
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 2,
                        top: 10,
                        child: Icon(
                          Icons.notification_add,
                          color: Color(0xFFC0170B),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            color: e.fechaFin.day == DateTime.now().day
                                ? Colors.red.withOpacity(.2)
                                : Colors.white,
                            border: Border.all(
                                style: BorderStyle.solid, color: Colors.black26)),
                        width: 170,
                        height: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            H2Text(
                              text: e.fechaFin.day == DateTime.now().day
                                  ? 'Retorna Hoy!'
                                  : 'hoy es ${formatFecha(DateTime.now())}',
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                            H2Text(
                              text: e.codigoGrupo,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: e.fechaFin.day == DateTime.now().day
                                  ? Colors.red
                                  : Colors.black,
                            ),
                            const Divider(),
                            FechasIntOutGrupos(e: e),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }
}

class FechaFilterListGrupos extends StatelessWidget {
  const FechaFilterListGrupos({
    super.key,
    required this.widget,
    required this.filterLista,
     required ScrollController scrollController,
    required this.showAppBar,
  }): _scrollController = scrollController;

   final ScrollController _scrollController;
  final bool showAppBar;
  final GruposLIstPages widget;
  final List<TDetalleTrabajoModel> filterLista;

  @override
  Widget build(BuildContext context) {
    Map<dynamic, List<TDetalleTrabajoModel>> fechaFilter = {};
    filterLista.forEach((e) {
      String keyFecha =
          '${e.fechaInicio.year}-${e.fechaInicio.month.toString().padLeft(2, '0')}';
      if (!fechaFilter.containsKey(keyFecha)) {
        fechaFilter[keyFecha] = [];
      }
      fechaFilter[keyFecha]!.add(e);
    });
    List<dynamic> sortedKey = fechaFilter.keys.toList()..sort();

    return Expanded(
      child: ScrollWeb(
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: sortedKey.length, 
          itemBuilder: (context, index) {
            final fechaKey = sortedKey.reversed.toList()[index]; //index
            final gastosPorFecha = fechaFilter[fechaKey]; //subLista
            DateTime fechaDateTime = DateTime.parse(fechaKey + '-01');
            return Column(
              children: [
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      H2Text(
                        text: fechaFiltrada(fechaDateTime),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        '${gastosPorFecha!.length} regs.',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                if (gastosPorFecha.isNotEmpty)
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    // Calcular el número de columnas en función del ancho disponible
                    int crossAxisCount = (constraints.maxWidth / 200).floor();
                    // Puedes ajustar el valor 100 según tus necesidades
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 1, //espacio ancho
                          mainAxisSpacing: 1, //espacio alto
                          childAspectRatio: 1, //Ver mas reducido al alto
                          crossAxisCount: crossAxisCount),
                      itemCount: gastosPorFecha.length,
                      itemBuilder: (BuildContext context, index) {
                        final e = gastosPorFecha[index];
                        return CardCustomDetalleTrabajo(e: e);
                      },
                    );
                  })
              ],
            );
          },
        ),
      ),
    );
  }
}

class CardCustomDetalleTrabajo extends StatelessWidget {
  const CardCustomDetalleTrabajo({
    super.key,
    required this.e,
  });

  final TDetalleTrabajoModel e;

  @override
  Widget build(BuildContext context) {
    final listaTProducto =
        Provider.of<TSalidasAppProvider>(context, listen: false).listSalidas;
    final listItineriario =
        Provider.of<TItinerarioProvider>(context).listItinerario;
    final listTipoGasto =
        Provider.of<TTipoGastoProvider>(context).listTipogasto;
    final listCandPaxguia =
        Provider.of<TCantidadPaxGuiaProvider>(context).listapaxguias;
    final listRestriciones =
        Provider.of<TRestriccionesProvider>(context).listaRestricciones;

    //Obtener si un grupo tiene registros asociados y eleimanr si no
    List<TSalidasAppModel> obtenerCodigoGrupo(String idTrabajo) {
      List<TSalidasAppModel> filtrarCodigoGrupo =
          listaTProducto.where((a) => a.idTrabajo == e.id).toList();
      return filtrarCodigoGrupo;
    }

    //Obtener nombre Itinerario
    String obtenerNameItinerario(String text) {
      for (var data in listItineriario) {
        if (data.id == e.idItinerariodiasnoches /*text*/) {
          return data.diasNoches;
        }
      }
      return '***';
    }

    String obtenerCantdPaxGuia(String text) {
      for (var data in listCandPaxguia) {
        if (data.id == e.idCantidadPaxguia /*text*/) {
          return '${data.pax} y ${data.guia}';
        }
      }
      return '***';
    }

    String obtenerRestriccion(String text) {
      for (var data in listRestriciones) {
        if (data.id == e.idRestriccionAlimentos /*text*/) {
          return data.nombreRestriccion;
        }
      }
      return '***';
    }

    String obteneTipoGasto(String text) {
      for (var data in listTipoGasto) {
        if (data.id == e.idTipogasto /*text*/) {
          return data.nombreGasto;
        }
      }
      return '***';
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      return Stack(
        children: [
          Positioned(
            left: width * .42,
            bottom: height * .15,
            child: H2Text(
              text: '${obtenerCodigoGrupo(e.id!).length} regs.',
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: width,
            height: height * .72,
            child: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const H2Text(
                    text: 'Codígo de grupo',
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                  H2Text(
                    text: e.codigoGrupo,
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                  H2Text(
                    text: obtenerNameItinerario(e.idItinerariodiasnoches),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  H2Text(
                    text: obtenerCantdPaxGuia(e.idCantidadPaxguia),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                  H2Text(
                    text: obtenerRestriccion(e.idRestriccionAlimentos),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                  H2Text(
                    text: obteneTipoGasto(e.idTipogasto),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _detailsGrupoPage(context, e,
                  diasnoches: obtenerNameItinerario(e.idItinerariodiasnoches),
                  paxguia: obtenerCantdPaxGuia(e.idCantidadPaxguia),
                  restricion: obtenerRestriccion(e.idRestriccionAlimentos),
                  tipogasto: obteneTipoGasto(e.idTipogasto),
                  resgitros: obtenerCodigoGrupo(e.id!).length.toString());
            },
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid, color: Colors.black26)),
              padding: const EdgeInsets.all(6),
              child: FechasIntOutGrupos(e: e),
            ),
          ),
          IconButton(
              onPressed: () {
                if (obtenerCodigoGrupo(e.id!).isEmpty) {
                  _mostrarConfrimacionDelete(context);
                } else {
                  showSialogEdicion(context,
                      'Esta acción conlleva riesgos. Antes de eliminar un Grupo de trabajo, asegúrate de que no haya registros asignados a esta ubicación.\n\n(${obtenerCodigoGrupo(e.id!).length} registros encontrados)');
                }
              },
              icon: Icon(
                Icons.delete,
                size: 15,
                color: Colors.red.withOpacity(.8),
              )),
          Positioned(
            right: 2,
            top: 0,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GruposEditingPage(
                                e: e,
                              )));
                },
                icon: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.black26,
                )),
          )
        ],
      );
    });
  }

  void _mostrarConfrimacionDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content:
              const Text("¿Está seguro de que desea eliminar este elemento?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<TDetalleTrabajoProvider>()
                    .deleteTdetalleTrabajoProvider(e.id!);
                _eliminarElemento(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _eliminarElemento(BuildContext context) {
    // Mostrar SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Elemento eliminado correctamente"),
      ),
    );

    Navigator.of(context).pop();
  }

  void showSialogEdicion(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Alerta de acción No Permitida!'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _detailsGrupoPage(BuildContext context, TDetalleTrabajoModel e,
      {String? diasnoches,
      String? paxguia,
      String? restricion,
      String? tipogasto,
      String? resgitros}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Grupo con el código ${e.codigoGrupo}'),
          // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
          content: Text('Programado para iniciar el día' +
              ' ${formatFecha(e.fechaInicio)}' +
              ' y con fecha de finalización el día (${formatFecha(e.fechaInicio)}).\n\n' +
              'Este programa, que abarca $diasnoches (días/noches), está diseñado para acomodar a $paxguia.\n\n' +
              'El grupo presenta restricciones alimenticias, específicamente, $restricion.\n\n' +
              'Tomar en consideración:\n' +
              e.descripcion +
              '\n\nTipo de Gasto: $tipogasto' +
              '\n\nRegistros asociados a este grupo : $resgitros registros encontrados' +
              '\n\nRevisar Historial de "Salidas de Productos".'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}

class FechasIntOutGrupos extends StatelessWidget {
  const FechasIntOutGrupos({
    super.key,
    required this.e,
  });

  final TDetalleTrabajoModel e;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const H2Text(
                text: 'Entrada',
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
              H2Text(
                text: formatFecha(e.fechaInicio),
                fontSize: 10,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const H2Text(
                text: 'Retorno',
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
              H2Text(
                text: formatFecha(e.fechaFin),
                fontSize: 10,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
