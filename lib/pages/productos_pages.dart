// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_t_ubicacion_almacen.dart';
import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/pages/pdf_export_catalogo.producto.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/provider/provider_v_inventario_general_productos.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:ausangate_op/widgets/custom_card_productos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CatalogoProductos extends StatelessWidget {
  const CatalogoProductos({super.key});

  @override
  Widget build(BuildContext context) {
    final listUbicacion = Provider.of<TUbicacionAlmacenProvider>(context)
        .listUbicacion
      ..sort((a, b) => a.nombreUbicacion.compareTo(b.nombreUbicacion));

    //INVENTARIO General
    final productoslist =
        Provider.of<ViewInventarioGeneralProductosProvider>(context)
            .listInventario;
    final listAlertExist =
        Provider.of<ViewInventarioALERTAEXISTENCIASproductosProvider>(context)
            .listAlertaExistencias;
    final listOrdenCompra =
        Provider.of<ViewInventarioORDENCOMPRAFVSTOCKproductosProvider>(context)
            .listOrdenCompra;

    return InventarioProductosView(
      listUbicacion: listUbicacion,
      productoslist: productoslist,
      listAlertExist: listAlertExist,
      listOrdenCompra: listOrdenCompra,
      //
    );
  }
}

// ignore: must_be_immutable
class InventarioProductosView extends StatefulWidget {
  const InventarioProductosView({
    super.key,
    required this.listUbicacion,
    required this.productoslist,
    required this.listAlertExist,
    required this.listOrdenCompra,
  });
  final List<TUbicacionAlmacenModel> listUbicacion;
  final List<ViewInventarioGeneralProductosModel> productoslist;
  final List<ViewInventarioGeneralProductosModel> listAlertExist;
  final List<ViewInventarioGeneralProductosModel> listOrdenCompra;

  @override
  State<InventarioProductosView> createState() =>
      _InventarioProductosViewState();
}

class _InventarioProductosViewState extends State<InventarioProductosView> {
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

  List<ViewInventarioGeneralProductosModel> _selectedList = [];
  //LISTAUBICACION
  List<ViewInventarioGeneralProductosModel> obtenerLisUbicacion(
      String idUbicacion) {
    _selectedList =
        widget.productoslist.where((e) => e.idUbicaion == idUbicacion).toList();
    // print('Filtrado ${ubicacionFiltrada.length}');
    print('Selected List ${_selectedList.length}');
    return _selectedList;
  }

  //BUSCADOR
  //Creamos las variables
  late TextEditingController _searchTextEditingController;
  late List<ViewInventarioGeneralProductosModel> filterListaCompraProductos;

  //Metodo de filtrado.
  _filterProductos(String seachtext) {
    setState(() {
      filterListaCompraProductos = _selectedList
          .where((e) =>
              e.producto.toLowerCase().contains(seachtext.toLowerCase()) ||
              e.nombreEmpresaProveedor
                  .toLowerCase()
                  .contains(seachtext.toLowerCase()) ||
              e.nombreUbicacion
                  .toLowerCase()
                  .contains(seachtext.toLowerCase()) ||
              e.categoria.toLowerCase().contains(seachtext.toLowerCase()) ||
              e.marcaProducto.toLowerCase().contains(seachtext.toLowerCase()) ||
              e.estadoFecha.toLowerCase().contains(seachtext.toLowerCase()) ||
              e.estadoStock.toLowerCase().contains(seachtext.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    _selectedList = widget.productoslist;
    //Inicialicemos EL Buscador
    _searchTextEditingController = TextEditingController();
    filterListaCompraProductos = _selectedList;
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  //TITLE SELECT UBICACION
  String title = 'Lista General';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: showAppBar
            ? AppBar(
                elevation: 0,
                surfaceTintColor: Colors.white,
                toolbarHeight: 80,
                title: FittedBox(
                  child: H2Text(
                    text:
                        'Catálogo de Almacén : $title', //Movimientos de Inventario
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                centerTitle: false,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          style: _buttonStyle(),
                          onPressed: () {
                            _selectedList = widget.listAlertExist;
                            title =
                                '${'Alerta ¡Próximos Vencimientos!'.toUpperCase()}:\nProductos a vencer en los próximos 2 meses.';
                            //Ponemos por un bug, se actulzia al seleccionar Ubicacion, alert, compra
                            _filterProductos(_searchTextEditingController.text);
                          },
                          label: const H2Text(
                            text: ' Alertas ',
                            fontSize: 12,
                            color: Colors.greenAccent,
                          ),
                          icon: const Icon(
                            Icons.add_alert_rounded,
                            size: 20,
                            color: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton.icon(
                          style: _buttonStyle(),
                          onPressed: () {
                            _selectedList = widget.listOrdenCompra;
                            title =
                                '${'Alerta de Compras'.toUpperCase()}:\nProductos Vencidos o Agotados.';
                            _filterProductos(_searchTextEditingController.text);
                          },
                          label: const H2Text(
                            text: 'Compras',
                            fontSize: 12,
                            color: Colors.greenAccent,
                          ),
                          icon: const Icon(
                            Icons.playlist_add_check_circle_sharp,
                            size: 20,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
                bottom: PreferredSize(
                    preferredSize: const Size(double.infinity, 30),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        ScrollWeb(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  style: _buttonStyle2(),
                                  onPressed: () {
                                    _selectedList = widget.productoslist;
                                    title = 'Lista General';
                                    //Ponemos por un bug, se actulzia al seleccionar Ubicacion, alert, compra
                                    _filterProductos(
                                        _searchTextEditingController.text);
                                  },
                                  icon: const Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  label: const H2Text(
                                    text: 'Lista General',
                                    fontSize: 12,
                                    color: Colors.white,
                                    maxLines: 2,
                                  ),
                                ),
                                //UBICACION LISTA
                                ...List.generate(widget.listUbicacion.length,
                                    (index) {
                                  final e = widget.listUbicacion[index];
                                  return Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: ElevatedButton.icon(
                                      style: _buttonStyle2(),
                                      onPressed: () {
                                        // _selectedList = widget.productoslist;
                                        obtenerLisUbicacion(e.id!);
                                        title = e.nombreUbicacion;
                                        //Ponemos por un bug, se actulzia al seleccionar Ubicacion, alert, compra
                                        _filterProductos(
                                            _searchTextEditingController.text);
                                      },
                                      icon: const Icon(
                                        Icons.location_on,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      label: H2Text(
                                        text: e.nombreUbicacion,
                                        fontSize: 12,
                                        color: Colors.white,
                                        maxLines: 2,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
              )
            : null,
        body: Column(
          children: [
            showAppBar ? _selectedUbicacionName() : const SizedBox(),
            SafeArea(
              bottom: false,
              child: Card(
                surfaceTintColor: Colors.transparent,
                elevation: 10,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _searchTextEditingController.clear();
                            _filterProductos(_searchTextEditingController.text);
                          });
                        },
                        icon: _searchTextEditingController.text.isEmpty
                            ? const Icon(Icons.search)
                            : const Icon(Icons.cleaning_services_rounded,
                                size: 20),
                        tooltip: 'Buscar Producto',
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintText: "Buscar producto",
                      hintStyle: const TextStyle(
                          color: Colors.black26, fontWeight: FontWeight.w500),
                      enabled: true,
                      border: _outlineButton(),
                      focusedBorder: _outlineButton(),
                      enabledBorder: _outlineButton(),
                      errorBorder: _outlineButton(),
                    ),
                    onChanged: (value) {
                      _filterProductos(value);
                    },
                    controller: _searchTextEditingController,
                  ),
                ),
              ),
            ),
            !showAppBar ? _selectedUbicacionName() : const SizedBox(),
            // ListTempralTableState(inventario: filterListaCompraProductos)
            Expanded(
              child: Inventario(
                scrollController: _scrollController,
                showAppBar: showAppBar,
                title:title,
                productoslist: filterListaCompraProductos, //_selectedList,
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _selectedUbicacionName() {
    return Column(
      children: [
        H2Text(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        H2Text(
          text: '${_selectedList.length} regs. encontrados.',
          fontSize: 11,
          fontWeight: FontWeight.w300,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ],
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

  ButtonStyle _buttonStyle2() {
    return const ButtonStyle(
      maximumSize: MaterialStatePropertyAll(Size(150, 80)),
      // minimumSize: MaterialStatePropertyAll(Size(80, 40)),
      padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10, right: 10)),
      elevation: MaterialStatePropertyAll(10),
      visualDensity: VisualDensity.compact,
      backgroundColor: MaterialStatePropertyAll(Colors.black26),
      overlayColor: MaterialStatePropertyAll(Colors.white),
    );
  }

  OutlineInputBorder _outlineButton() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}

//FILTRAR CATEGORIA
class Inventario extends StatelessWidget {
  const Inventario({
    super.key,
    required ScrollController scrollController,
    required this.showAppBar,
    required this.productoslist,
    required this.title,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final bool showAppBar;
  final List<ViewInventarioGeneralProductosModel>
      productoslist; // ESTA LISTA OBTIENE EL DATO SELECIONADO POR UBICACION SEGUN EL USUARIO
  final String title;
  @override
  Widget build(BuildContext context) {
    //FILTRAR por CATEGORIA
    Map<String, List<ViewInventarioGeneralProductosModel>> categoriasFilter =
        {};
    // ignore: avoid_function_literals_in_foreach_calls
    productoslist.forEach((e) {
      if (!categoriasFilter.containsKey(e.categoria)) {
        categoriasFilter[e.categoria] = [];
      }
      categoriasFilter[e.categoria]!.add(e);
    });
    //ORDENAMIENTO categoria
    List<dynamic> sortedKey = categoriasFilter.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PdfExportCatalogoProductos(
          sortedKey: sortedKey, categoriasFilter: categoriasFilter,title: title,
        ),
        Expanded(
          child: ScrollWeb(
            child: ListView.builder(
                shrinkWrap: true,
                cacheExtent: 500, // Ajusta según tus necesidades
                controller: _scrollController,
                itemCount: sortedKey.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = sortedKey[index];
                  final productosPorCategoria = categoriasFilter[category];
                  //ORDENAMOS LA LISTA
                  productosPorCategoria!
                      .sort((a, b) => a.producto.compareTo(b.producto));

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            H2Text(
                                text: category,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.red),
                            const SizedBox(
                              width: 30,
                            ),
                            H2Text(
                                text: '${productosPorCategoria.length} regs.',
                                fontSize: 13,
                                color: Colors.red)
                          ],
                        ),
                      ),
                      const Divider(),
                      // ignore: unnecessary_null_comparison
                      if (productosPorCategoria !=
                          null) // Verificamos si esa ctegoria es nula y si no es la generamos.
                        LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          // Calcular el número de columnas en función del ancho disponible
                          int crossAxisCount =
                              (constraints.maxWidth / 200).floor();
                          // Puedes ajustar el valor 100 según tus necesidades
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: productosPorCategoria.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount),
                              itemBuilder: (BuildContext context, int index) {
                                final e = productosPorCategoria[index];
                                print('GridView.builder $index');
                                return CustomCardProducto(e: e);
                              });
                        })
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }
}
