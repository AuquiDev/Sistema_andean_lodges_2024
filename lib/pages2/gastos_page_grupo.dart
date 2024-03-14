// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:ausangate_op/pages2/gastos_page_details.dart';
import 'package:ausangate_op/utils/custom_colores.dart';
import 'package:ausangate_op/utils/formatear_numero.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:ausangate_op/models/model_v_gastos_grupo_salidas.dart';
import 'package:ausangate_op/provider/provider_v_gatos_grupo_salidas.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';

class GastosGruposPage extends StatelessWidget {
  const GastosGruposPage(
      {super.key,});


  @override
  Widget build(BuildContext context) {
    final dataProviderGastos =
        Provider.of<ViewGastosGrupoSalidasProvider>(context);
    List<ViewGastosGrupoSalidasModel> listaGatos = dataProviderGastos.listGastos
      ..sort((a, b) => a.fechaFin.compareTo(b.fechaFin));

    return GastosGruposPageSf(
      listaGatos: listaGatos,
    );
  }
}

class GastosGruposPageSf extends StatefulWidget {
  const GastosGruposPageSf(
      {super.key,
      required this.listaGatos});
  final List<ViewGastosGrupoSalidasModel> listaGatos;

  @override
  State<GastosGruposPageSf> createState() => _GastosGruposPageSfState();
}

class _GastosGruposPageSfState extends State<GastosGruposPageSf> {
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

  //GASTOS POR GRUP O
  bool isVisibleSerch = true;
  bool isClear = false;

  late TextEditingController _searchControllerGastos;
  late List<ViewGastosGrupoSalidasModel> filterListGastosSalidas;

  _filterProductos(String searchtext) {
    setState(() {
      filterListGastosSalidas = widget.listaGatos
          .where((e) =>
              e.codigoGrupo.toLowerCase().contains(searchtext.toLowerCase()) ||
              e.grupo.toLowerCase().contains(searchtext.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    _searchControllerGastos = TextEditingController();
    filterListGastosSalidas = widget.listaGatos;
    super.initState();
     _scrollController.addListener(_onScroll);

  }

  @override
  void dispose() {
    _searchControllerGastos.dispose();
    super.dispose();

        _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
            appBar: showAppBar
                ? AppBar(
                    leading: const Icon(
                      Icons.circle,
                      color: Colors.transparent,
                    ),
                    leadingWidth: 0,
                    elevation: 0,
                    centerTitle: false,
                    title: const FittedBox(
                      child: H2Text(
                        text: 'Vista Integral de Grupos y sus Gastos',
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  )
                : null,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  bottom: false,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    height: 50,
                    decoration: BoxDecoration(boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          color: Colors.black26),
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
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _searchControllerGastos.clear();
                              _filterProductos(_searchControllerGastos.text);
                            });
                          },
                          icon: _searchControllerGastos.text.isEmpty
                              ? const Icon(Icons.search)
                              : const Icon(Icons.close, size: 20),
                          tooltip: 'Buscar Grupo',
                        ),
                        filled: true,
                        fillColor: Colors.white,
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
                //GRUPOS EN RUTA
                showAppBar
                    ? AlertaGruposGastos(widget: widget)
                    : _notaAlertas(),
                GastosGrupoLista(
                    filterListGastosSalidas: filterListGastosSalidas,
                    showAppBar: showAppBar, scrollController: _scrollController,)
              ],
            )));
  }

  Center _notaAlertas() {
    return const Center(
      child: H2Text(
        text: 'Solo se mostrarán los grupos con asignaciones de salidas.',
        maxLines: 2,
        fontSize: 9,
        fontWeight: FontWeight.w300,
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

class AlertaGruposGastos extends StatelessWidget {
  const AlertaGruposGastos({
    super.key,
    required this.widget,
  });

  final GastosGruposPageSf widget;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Row(
        children: [
          const H2Text(
            text: 'Grupos\nen ruta',
            maxLines: 2,
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
          const Icon(
            Icons.arrow_forward,
            color: Colors.black87,
          ),
          ...List.generate(widget.listaGatos.length, (index) {
            DateTime hoy = DateTime.now();
            DateTime inicio = widget.listaGatos[index].fechaInicio;
            DateTime fin = widget.listaGatos[index].fechaFin;
            final e = widget.listaGatos[index];
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
                          builder: (context) => GastosDetailsPage(
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
                      height: 90,
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
    );
  }
}

class GastosGrupoLista extends StatelessWidget {
  const GastosGrupoLista({
    super.key,
    required this.filterListGastosSalidas,
    // required this.widget,
     required this.showAppBar,
      required ScrollController scrollController
  }) : _scrollController = scrollController;
  final ScrollController _scrollController;
  final bool showAppBar;

  final List<ViewGastosGrupoSalidasModel> filterListGastosSalidas;
  // final GastosGruposPageSf widget;


  @override
  Widget build(BuildContext context) {
    Map<dynamic, List<ViewGastosGrupoSalidasModel>> fechaFilter = {};

    filterListGastosSalidas.forEach((e) {
      //Combinar una ano y mes para una clave unica y filtrar agrupar por mes.
      //padLeft: le agrega un numero 0 al aizquierda de un mes si el mes es 1 => pafleft sera 01, hasta que tenga dos digitos.
      String keyFecha =
          '${e.fechaInicio.year}-${e.fechaInicio.month.toString().padLeft(2, '0')}';
      if (!fechaFilter.containsKey(keyFecha)) {
        fechaFilter[keyFecha] = [];
      }
      fechaFilter[keyFecha]!.add(e);
    });
    List<dynamic> sortedKey = fechaFilter.keys.toList()..sort();

    return Expanded(
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: sortedKey.length, //fechaFilter.length,
          itemBuilder: (context, index) {
            // final fechaKey =
            //     fechaFilter.keys.elementAt(index); //Obtenemos el indice del mapa
            // final gastosPorFecha =
            //     fechaFilter[fechaKey]; //Lista de Gastos por mes
            final fechaKey = sortedKey.reversed.toList()[index]; //index
            final gastosPorFecha = fechaFilter[fechaKey]; //subLista
            DateTime fechaDateTime = DateTime.parse(fechaKey + '-01');

            gastosPorFecha!
                .sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));

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
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: Colors.blue,
                      ),
                      Text(
                        '${gastosPorFecha.length} regs.',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                if (gastosPorFecha.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 1, //espacio ancho
                        mainAxisSpacing: 1, //espacio alto
                        childAspectRatio: 1.0, //Ver mas reducido al alto
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 4),
                    itemCount: gastosPorFecha.length,
                    itemBuilder: (BuildContext context, index) {
                      final e = gastosPorFecha[index];
                      return CardGastosSalidasCustom(e: e);
                    },
                  )
              ],
            );
          },
        );
      }),
    );
  }
}

class CardGastosSalidasCustom extends StatelessWidget {
  const CardGastosSalidasCustom({super.key, required this.e});
  final ViewGastosGrupoSalidasModel e;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid,
              color: CustomColors.primaryColor,
              width: .3),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GastosDetailsPage(
                              e: e,
                            )));
              },
              child: Column(
                children: [
                  const H2Text(
                    text: 'Código grupo',
                    fontSize: 9,
                    fontWeight: FontWeight.w300,
                    color: CustomColors.accentColor,
                  ),
                  H2Text(
                    text: e.codigoGrupo,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: CustomColors.accentColor,
                  ),
                  H2Text(
                    text: e.categoriaOTipoDeTrabajo,
                    fontSize: 9,
                  ),
                  FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 7),
                      child: H2Text(
                        text: e.grupo,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: CustomColors.accentColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            children: [
                              const H2Text(
                                text: 'Valor total en salidas',
                                fontSize: 9,
                                color: Colors.black38,
                              ),
                              FittedBox(
                                child: H2Text(
                                  text:
                                      'S/. ${e.montoTotalInversion.toStringAsFixed(2)}',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: [
                              const H2Text(
                                text: '#Días',
                                fontSize: 9,
                                color: Colors.black38,
                              ),
                              H2Text(
                                text: formatearNumero(e.cantidadDias),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  FechasIntOutGrupos(e: e),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FechasIntOutGrupos extends StatelessWidget {
  const FechasIntOutGrupos({
    super.key,
    required this.e,
  });

  final ViewGastosGrupoSalidasModel e;

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
                color: CustomColors.accentColor,
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
                color: CustomColors.accentColor,
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
