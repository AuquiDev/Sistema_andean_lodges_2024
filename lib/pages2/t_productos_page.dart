// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, use_build_context_synchronously

import 'package:ausangate_op/pages/tabla_paginada.dart';
import 'package:ausangate_op/pages2/t_productos_editing_page.dart';
import 'package:ausangate_op/pages2/t_ubicaciones_page.dart';
import 'package:ausangate_op/provider/provider_t_categoria_almacen.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/utils/buton_style.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:ausangate_op/widgets/responsive_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/utils/custom_text.dart';

class ProductosPage extends StatelessWidget {
  const ProductosPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final listaTproductos =
        Provider.of<TProductosAppProvider>(context).listProductos;
    return ProductosPageData(listaTproductos: listaTproductos);
  }
}

class ProductosPageData extends StatefulWidget {
  const ProductosPageData({super.key, required this.listaTproductos});
  final List<TProductosAppModel> listaTproductos;

  @override
  State<ProductosPageData> createState() => _ProductosPageDataState();
}

class _ProductosPageDataState extends State<ProductosPageData> {
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

  //FILTRAR UBICACION logica del Buscador en botones
  late List<TProductosAppModel> filterTUbicaicones;

  //Le tenemos que pasar como parametro el id de ubiciones
  _filterTUbicaicones(String searchText) {
    filterTUbicaicones = widget.listaTproductos
        .where((e) => e.idUbicacion.contains(searchText))
        .toList();
  }

  //FILTRAMOS lal ogica del buscador de producto en base a lista filtrada de ubicacion
  late TextEditingController _searchTextEditingController;
  late List<TProductosAppModel> filterTProductos;
  _filterTProductos(String seachText) {
    setState(() {
      filterTProductos = filterTUbicaicones
          .where((e) =>
              e.id.toLowerCase().contains(seachText.toLowerCase()) ||
              e.idProveedor.toLowerCase().contains(seachText.toLowerCase()) ||
              e.idCategoria.toLowerCase().contains(seachText.toLowerCase()))
          .toList();
    });
  }
  //EXiste un problema al moficiar datos de la lista y es que no se redibujan debido
  //a los metodos de busqueda, por eso se impleemnta esta metodo que invoca e lfiltrado para moficar la lista.

  void updateStateProducto() {
    print('Actualizar Página al eliminar elemento');
    setState(() {
      // Generar un nuevo conjunto de datos sin el elemento eliminado
      filterTUbicaicones = widget.listaTproductos;
      //  filterTProductos = filterTUbicaicones;
      // _searchTextEditingController.text = ''; // Limpiar el campo de búsqueda
      _filterTProductos('');
      // _filterTUbicaicones('');
    });
  }

  @override
  void initState() {
    filterTUbicaicones = widget.listaTproductos;
    _searchTextEditingController = TextEditingController();
    filterTProductos = filterTUbicaicones;

    // _filterTUbicaicones('43j14odbsg59lgy');
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

  bool isVisible = true;
  //TEXTO nombre de ubicacion segun el boton se asigna el valor al titulo de ubicacion
  String title = 'Lista General';
  String currentCategory = 'Categoria General';

  @override
  Widget build(BuildContext context) {
    //LISTA UBICACIONES ALMACÉN
    final listaUbicaciones = Provider.of<TUbicacionAlmacenProvider>(context)
        .listUbicacion
      ..sort((a, b) => a.nombreUbicacion.compareTo(b.nombreUbicacion));

    //FILTRAR por CATEGORIA
    Map<String, List<TProductosAppModel>> categoriasFilter = {};
    filterTProductos.forEach((e) {
      if (!categoriasFilter.containsKey(e.idCategoria)) {
        categoriasFilter[e.idCategoria] = [];
      }
      categoriasFilter[e.idCategoria]!.add(e);
    });
    //ORDENAMIENTO categoria
    List<dynamic> sortedKeyCetegory = categoriasFilter.keys.toList()..sort();

    final listcategory = Provider.of<TCategoriaProvider>(context).listcategory;
    return GestureDetector(
      onTap: () {
        // Cierra el teclado cuando tocas en cualquier lugar de la pantalla
        FocusScope.of(context).unfocus();
      },
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
                  title: ResponsiveTitleAppBar(
                    title: 'Gestión de Inventario',
                    subtitle:
                        '$title | $currentCategory [${filterTProductos.length} regs.]',
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: OutlinedButton.icon(
                        style: buttonStyle(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditPageProductosApp()));
                        },
                        icon: const Icon(
                          Icons.add_home_sharp,
                          size: 20,
                          color: Colors.black,
                        ),
                        label: const H2Text(
                          text: 'Nuevo',
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          final dataProvider =
                              Provider.of<TProductosAppProvider>(context,
                                  listen: false);
                          await dataProvider.actualizarDatosDesdeServidor();
                          _filterTUbicaicones('');
                          _filterTProductos('');
                          await redibujarTabla();
                        },
                        icon: const Icon(Icons.refresh))
                  ],
                  bottom: PreferredSize(
                      preferredSize: const Size(double.infinity, 40),
                      child: ButtonBar(
                        buttonPadding: const EdgeInsets.all(0),
                        children: [
                          // LISTA DE UBICACION
                          ScrollWeb(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      TextButton(
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.add_circle_sharp,
                                              size: 20,
                                              color: Colors.teal,
                                            ),
                                            H2Text(
                                              text: 'Ubicación',
                                              fontSize: 10,
                                            )
                                          ],
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TPageUbicaciones()));
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: TextButton(
                                        style: buttonStyle2(),
                                        onPressed: () async {
                                          _filterTUbicaicones('');
                                          _filterTProductos('');
                                          title = 'Lista General';
                                          currentCategory = 'Categoría General';
                                          //Redibujar la tabla
                                          await redibujarTabla();
                                        },
                                        child: const H2Text(
                                          text: 'General',
                                          fontSize: 12,
                                          color: Colors.black87,
                                        )),
                                  ),
                                  ...List.generate(listaUbicaciones.length,
                                      (index) {
                                    final e = listaUbicaciones[index];
                                    return Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      // width: 90,
                                      child: ElevatedButton.icon(
                                          style: buttonStyle2(),
                                          onPressed: () async {
                                            _filterTUbicaicones(
                                                e.id.toString());
                                            _filterTProductos('');
                                            title = e.nombreUbicacion;
                                            currentCategory =
                                                'Categoría General';
                                            //Redibujar la tabla
                                            await redibujarTabla();
                                          },
                                          icon: const Icon(
                                            Icons.fmd_good_sharp,
                                            size: 15,
                                            color: Color(0xFFC0342A),
                                          ),
                                          label: H2Text(
                                            text: e.nombreUbicacion,
                                            fontSize: 12,
                                            color: Colors.black87,
                                          )),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollWeb(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.add_circle_sharp,
                              size: 20,
                              color: Colors.deepOrange,
                            ),
                            H2Text(
                              text: 'Categoría',
                              fontSize: 10,
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TPageUbicaciones()));
                        },
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      ElevatedButton(
                          style: buttonStyle2(),
                          onPressed: () async {
                            _filterTProductos('');
                            await redibujarTabla();
                            currentCategory = 'Categoría General';
                          },
                          child: const H2Text(
                            text: 'General',
                            fontSize: 12,
                          )),
                      ...List.generate(sortedKeyCetegory.length, (index) {
                        final e = sortedKeyCetegory[index];
                        //SUBLISTA
                        final subList = categoriasFilter[e];
                        String obtenerCategoria(String idCategoria) {
                          for (var data in listcategory) {
                            if (data.id == idCategoria) {
                              return data.categoria;
                            }
                          }
                          return 'null';
                        }

                        String category = obtenerCategoria(e);
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: ElevatedButton(
                              style: buttonStyle2(),
                              onPressed: () async {
                                currentCategory = category;
                                if (e != '') {
                                  // Verifica si e no es null antes de filtrar por categoría
                                  _filterTProductos(e);
                                  print('HOLA $e');
                                } else if (subList.isNotEmpty) {
                                  // Verifica si subList no es null y no está vacío
                                  _filterTProductos(subList[0]
                                      .id); // Aquí, elige el índice correcto de subList
                                  print(
                                      'PRINT ${subList[0].id} ${subList[0].nombreProducto}');
                                }

                                await redibujarTabla();
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  H2Text(
                                    text: category,
                                    fontSize: 11,
                                    textAlign: TextAlign.center,
                                  ),
                                  H2Text(
                                      text: '${subList!.length} regs.',
                                      fontSize: 10),
                                ],
                              )),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              isVisible
                  ? Expanded(
                      child: AlmacenGestionPage(
                      listaTproductos: filterTProductos,
                      updateStateProducto: updateStateProducto,
                      title: title,
                      currentCategory: currentCategory,
                      scrollController: _scrollController,
                      showAppBar: showAppBar,
                    ))
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          )),
    );
  }

  Future<void> redibujarTabla() async {
    setState(() {
      isVisible = false;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      isVisible = true;
    });
  }
}
