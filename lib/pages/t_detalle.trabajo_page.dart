// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/models/model_t_salidas.dart';
import 'package:ausangate_op/pages/t_detalle.trabajo_details_page.dart';
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
    return GruposLIstPages(listaGrupos: listaGrupos);
  }
}

class GruposLIstPages extends StatefulWidget {
  const GruposLIstPages({
    super.key,
    required this.listaGrupos,
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
                  centerTitle: false,
                  surfaceTintColor: Colors.white,
                  title: const FittedBox(
                    child: H2Text(
                      text: 'Operaciones de Grupos y Logística',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        style: _buttonStyle(),
                        icon: const Icon(
                          Icons.add_circle_sharp,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: const H2Text(
                          text: 'Nuevo',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SafeArea(
                  bottom: false,
                  child: Card(
                    surfaceTintColor: Colors.transparent,
                    elevation: 10,
                    child: Container(
                      width: 350,
                      constraints: const BoxConstraints(maxWidth: 350),
                      height: 50,
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
                          enabled: true,
                          border: _outlineButton(),
                          focusedBorder: _outlineButton(),
                          enabledBorder: _outlineButton(),
                          errorBorder: _outlineButton(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              showAppBar ? AlertGruposEnRuta(widget: widget) : const SizedBox(),
              FechaFilterListGrupos(
                widget: widget,
                filterLista: filterLista,
                scrollController: _scrollController,
                showAppBar: showAppBar,
              )
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

  ButtonStyle _buttonStyle() {
    return const ButtonStyle(
      maximumSize: MaterialStatePropertyAll(Size(150, 80)),
      padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10, right: 10)),
      elevation: MaterialStatePropertyAll(10),
      visualDensity: VisualDensity.compact,
      backgroundColor: MaterialStatePropertyAll(Colors.red),
      overlayColor: MaterialStatePropertyAll(Colors.white),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const H2Text(
          text: 'Grupos en Ruta',
          fontSize: 13,
          color: Colors.black,
        ),
        ScrollWeb(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Row(
              children: [
                ...List.generate(widget.listaGrupos.length, (index) {
                  DateTime hoy = DateTime.now();
                  DateTime inicio = widget.listaGrupos[index].fechaInicio;
                  DateTime fin = widget.listaGrupos[index].fechaFin;
                  final e = widget.listaGrupos[index];
                  // Extraer solo la fecha (ignorando la hora exacta)
                  DateTime hoySinHora = DateTime(hoy.year, hoy.month, hoy.day);
                  DateTime inicioSinHora =
                      DateTime(inicio.year, inicio.month, inicio.day);
                  DateTime finSinHora = DateTime(fin.year, fin.month, fin.day);
                  //Para que la condicional funcione no se debe considerar la hora.
                  if ((hoySinHora.isAfter(inicioSinHora) ||
                          hoySinHora.isAtSameMomentAs(inicioSinHora)) &&
                      (hoySinHora.isBefore(finSinHora) ||
                          hoySinHora.isAtSameMomentAs(finSinHora))) {
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
                              color: Colors.red,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: e.fechaFin.day == DateTime.now().day
                                    ? Colors.red.withOpacity(.2)
                                    : const Color(0xFFDAEFA5),
                                ),
                            width: 200,
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: e.fechaFin.day == DateTime.now().day
                                      ? Colors.red
                                      : Colors.black,
                                ),
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
        ),
      ],
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
  }) : _scrollController = scrollController;

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
            final gastosPorFecha = fechaFilter[fechaKey]!..sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio)); //subLista
            DateTime fechaDateTime = DateTime.parse(fechaKey + '-01');
            return Column(
              children: [
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
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '(${gastosPorFecha!.length} regs.)',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const Divider(),
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
                        final e = gastosPorFecha.reversed.toList()[index];
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

    List<String> obtenerCantdPaxGuia(String text) {
      for (var data in listCandPaxguia) {
        if (data.id == e.idCantidadPaxguia /*text*/) {
          return [data.pax, data.guia];
        }
      }
      return [0.toString(),0.toString()];
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
          Container(
            width: width,
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Card(
              surfaceTintColor: Colors.black,
              color: Colors.black,
              elevation: 10,
            ),
          ),
          SizedBox(
            width: width,
            height: height * .72,
            child: Card(
              surfaceTintColor: Colors.transparent,
              elevation: 10,
              child: Column(
                children: [
                  FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        H2Text(
                          text: e.codigoGrupo,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                        H2Text(
                          text: obtenerNameItinerario(e.idItinerariodiasnoches),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                        H2Text(
                          text:   obtenerCantdPaxGuia(e.idCantidadPaxguia)[0] + ' Pax  |  ' +  obtenerCantdPaxGuia(e.idCantidadPaxguia)[1] + ' Guia',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                  ),
                  FechasIntOutGrupos(e: e)
                ],
              ),
            ),
          ),

          Positioned(
            right: 7,
            left: 7,
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.outlined(
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
                      color: Colors.green,
                    )),
                IconButton.outlined(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailsPagGrupos(
                            e: e,
                            diasnoches:
                                obtenerNameItinerario(e.idItinerariodiasnoches),
                            paxguia: obtenerCantdPaxGuia(e.idCantidadPaxguia),
                            restricion:
                                obtenerRestriccion(e.idRestriccionAlimentos),
                            tipogasto: obteneTipoGasto(e.idTipogasto),
                            resgitros:
                                obtenerCodigoGrupo(e.id!).length.toString());
                      }));
                    },
                    icon: const Icon(
                      Icons.visibility_rounded,
                      color: Colors.white,
                    )),
                IconButton.outlined(
                    onPressed: () {
                      if (obtenerCodigoGrupo(e.id!).isEmpty) {
                        _mostrarConfrimacionDelete(context);
                      } else {
                        showSialogEdicion(context,
                            'Esta acción conlleva riesgos. Antes de eliminar un Grupo de trabajo, asegúrate de que no haya registros asignados a esta ubicación.\n\n(${obtenerCodigoGrupo(e.id!).length} registros encontrados)');
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
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

