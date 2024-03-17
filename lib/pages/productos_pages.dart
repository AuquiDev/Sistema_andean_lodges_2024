// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_t_ubicacion_almacen.dart';
import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/pages/pdf_export_catalogo.producto.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/provider/provider_v_inventario_general_productos.dart';
import 'package:ausangate_op/utils/buton_style.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:ausangate_op/widgets/custom_card_productos.dart';
import 'package:ausangate_op/widgets/responsive_title_appbar.dart';
import 'package:delayed_display/delayed_display.dart';
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
    );
  }
}

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
  //FILTER UBICACION
  List<ViewInventarioGeneralProductosModel> obtenerLisUbicacion(
      String idUbicacion) {
    _selectedList =
        widget.productoslist.where((e) => e.idUbicaion == idUbicacion).toList();
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
  String title = 'General';

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
                title: ResponsiveTitleAppBar(
                  title: 'Inventario de Almacén:',
                  subtitle: '$title [ ${_selectedList.length} regs.]',
                ),
                centerTitle: false,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: buttonStyle2(),
                          onPressed: () {
                            _selectedList = widget.listAlertExist;
                            title =
                                'Productos a vencer en los próximos 2 meses.';
                            //Ponemos por un bug, se actulzia al seleccionar Ubicacion, alert, compra
                            _filterProductos(_searchTextEditingController.text);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_alert_rounded,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                H2Text(
                                  text: ' Alertas ',
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(),
                        ElevatedButton(
                          style: buttonStyle2(),
                          onPressed: () {
                            _selectedList = widget.listOrdenCompra;
                            title = 'Productos Vencidos o Agotados.';
                            _filterProductos(_searchTextEditingController.text);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                H2Text(
                                  text: 'Compras',
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              final dataProvider = Provider.of<
                                      ViewInventarioGeneralProductosProvider>(
                                  context,
                                  listen: false);
                              await dataProvider.actualizarDatosDesdeServidor();
                              _filterProductos(
                                  _searchTextEditingController.text);
                            },
                            icon: const Icon(Icons.refresh))
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
                              children: [
                                ElevatedButton(
                                  style: buttonStyle2(),
                                  onPressed: () {
                                    _selectedList = widget.productoslist;
                                    title = 'General';
                                    //Ponemos por un bug, se actulzia al seleccionar Ubicacion, alert, compra
                                    _filterProductos(
                                        _searchTextEditingController.text);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        H2Text(
                                          text: 'General',
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //UBICACION LISTA
                                ...List.generate(widget.listUbicacion.length,
                                    (index) {
                                  final e = widget.listUbicacion[index];
                                  return ElevatedButton(
                                    style: buttonStyle2(),
                                    onPressed: () {
                                      // _selectedList = widget.productoslist;
                                      obtenerLisUbicacion(e.id!);
                                      title = e.nombreUbicacion;
                                      //Ponemos por un bug, se actulzia al seleccionar Ubicacion, alert, compra
                                      _filterProductos(
                                          _searchTextEditingController.text);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                          H2Text(
                                            text: e.nombreUbicacion,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            maxLines: 2,
                                          ),
                                        ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 350),
              height: 50,
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
                        : const Icon(Icons.cleaning_services_rounded, size: 20),
                    tooltip: 'Buscar Producto',
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF0F0F0),
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
            
            Expanded(
              child: Inventario(
                scrollController: _scrollController,
                showAppBar: showAppBar,
                title: title,
                productoslist: filterListaCompraProductos,
              ),
            )
          ],
        ),
      ),
    );
  }
  OutlineInputBorder _outlineButton() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black26),
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
                padding: const EdgeInsets.only(top: 40),
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
                            vertical: .0, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            H2Text(
                              text: category,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              // color: const Color(0xFF430E21),
                            ),
                            H2Text(
                                text: '${productosPorCategoria.length} regs.',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.indigo)
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
                                return DelayedDisplay(
                                    delay: const Duration(milliseconds: 400),
                                    child: CustomCardProducto(e: e));
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
