// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, use_build_context_synchronously


import 'package:ausangate_op/pages2/t_productos_details_page.dart';
import 'package:ausangate_op/pages2/t_productos_editing_page.dart';
import 'package:ausangate_op/pages2/t_ubicaciones_page.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/provider/provider_v_inventario_general_productos.dart';
import 'package:ausangate_op/utils/formatear_numero.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/format_fecha.dart';

class ProductosPage extends StatelessWidget {
  const ProductosPage(
      {super.key,
      required this.showAppBar,
      required ScrollController scrollController})
      : _scrollController = scrollController;
  final ScrollController _scrollController;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
   
    
    final listaTproductos = Provider.of<TProductosAppProvider>(context).listProductos;
    // final listSQlproducto = Provider.of<DBProductoAppProvider>(context).listsql;
    // final listData = ;

    return ProductosPageData(
        showAppBar: showAppBar,
        scrollController: _scrollController,
        listaTproductos:listaTproductos);
  }
}

class ProductosPageData extends StatefulWidget {
  const ProductosPageData(
      {super.key,
      required this.showAppBar,
      required ScrollController scrollController,
      required this.listaTproductos})
      : _scrollController = scrollController;
  final ScrollController _scrollController;
  final bool showAppBar;
  final List<TProductosAppModel> listaTproductos;

  @override
  State<ProductosPageData> createState() => _ProductosPageDataState();
}

class _ProductosPageDataState extends State<ProductosPageData> {
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
              e.nombreProducto
                  .toLowerCase()
                  .contains(seachText.toLowerCase()) ||
              e.unidMedida.toLowerCase().contains(seachText.toLowerCase()) ||
              e.marcaProducto.toLowerCase().contains(seachText.toLowerCase()) ||
              e.tipoProducto.toLowerCase().contains(seachText.toLowerCase()))
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
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
  }

  //TEXTO nombre de ubicacion segun el boton se asigna el valor al titulo de ubicacion
  String tituloUbicacion = 'Lista General';

  @override
  Widget build(BuildContext context) {
    //LISTA UBICACIONES ALMACÉN
    final listaUbicaciones = Provider.of<TUbicacionAlmacenProvider>(context).listUbicacion
    ..sort((a, b) => a.nombreUbicacion.compareTo(b.nombreUbicacion));

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Cierra el teclado cuando tocas en cualquier lugar de la pantalla
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: widget.showAppBar
                ? AppBar(
                  leading: const Icon(Icons.circle, color: Colors.transparent,),
                  leadingWidth: 0,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    centerTitle: false,
                    title: const H2Text(
                      text: 'Gestión de Inventario Productos',
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      maxLines: 2,
                    ),
                    actions: [
                      TextButton.icon(
                        style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 10))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditPageProductosApp()));
                        },
                        icon: const Icon(
                          Icons.add_circle_outlined,
                          size: 20,
                        ),
                        label: const Text('Nuevo '),
                      ),
                    ],
                    bottom: PreferredSize(
                        preferredSize: const Size(double.infinity, 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: H2Text(
                                text: 'Filtrar por Ubicación de Almacén',
                                color: Color(0x67342E2E),
                                fontSize: 10,
                              ),
                            ),
                            ButtonBar(
                              buttonPadding: const EdgeInsets.all(0),
                              children: [
                                // LISTA DE UBICACION
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: ElevatedButton(
                                            style: const ButtonStyle(
                                              elevation:
                                                  MaterialStatePropertyAll(3),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              overlayColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.red),
                                            ),
                                            onPressed: () {
                                              _filterTUbicaicones('');
                                              _filterTProductos('');
                                              tituloUbicacion = 'Lista General';
                                            },
                                            child: const H2Text(
                                              text: 'Lista\nGeneral',
                                              fontSize: 10,
                                              maxLines: 2,
                                            )),
                                      ),
                                      ...List.generate(listaUbicaciones.length,
                                          (index) {
                                        final e = listaUbicaciones[index];
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          width: 90,
                                          child: ElevatedButton.icon(
                                              style: const ButtonStyle(
                                                  elevation:
                                                      MaterialStatePropertyAll(
                                                          2),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Color(0xFFCAF7D2)),
                                                  overlayColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.red),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  padding:
                                                      MaterialStatePropertyAll(
                                                          EdgeInsets.all(5))),
                                              onPressed: () {
                                                _filterTUbicaicones(
                                                    e.id.toString());
                                                _filterTProductos('');
                                                tituloUbicacion =
                                                    e.nombreUbicacion;
                                              },
                                              icon: const Icon(
                                                Icons.fmd_good_sharp,
                                                size: 15,
                                                color: Color(0xFFC0342A),
                                              ),
                                              label: H2Text(
                                                text: e.nombreUbicacion,
                                                fontSize: 10,
                                                maxLines: 2,
                                              )),
                                        );
                                      }),
                                      TextButton.icon(
                                        style: const ButtonStyle(
                                            visualDensity:
                                                VisualDensity.compact,
                                            padding: MaterialStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                    vertical: 15))),
                                        icon: const Icon(
                                          Icons.add_location_alt,
                                          size: 15,
                                        ),
                                        label: const H2Text(
                                          text: 'Crear nuevo...',
                                          fontSize: 9,
                                          maxLines: 2,
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
                                ),
                              ],
                            ),
                          ],
                        )),
                  )
                : null,
            body: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Container(
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
                          _filterTProductos(value);
                        },
                        decoration: decorationTextField(
                          hintText: 'Buscar..',
                          labelText: 'Buscar producto',
                          prefixIcon: const Icon(Icons.search),
                        )),
                  ),
                ),
                H2Text(
                    text: tituloUbicacion,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5B5353)),
                ListPRoductosAPP(
                    scrollController: widget._scrollController,
                    listaTproductos: filterTProductos, 
                    updateStateProducto: updateStateProducto,
                    ),
              ],
            )),
      ),
    );
  }
}


class ListPRoductosAPP extends StatelessWidget {
  const ListPRoductosAPP({
    super.key,
    required ScrollController scrollController,
    required this.listaTproductos, required this.updateStateProducto,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<TProductosAppModel> listaTproductos;
  final VoidCallback updateStateProducto;
  

  @override
  Widget build(BuildContext context) {
    //FILTRADO Por fecha de Vencimiento. agrupoar por mes y año
    Map<dynamic, List<TProductosAppModel>> fechaFilter = {};

    listaTproductos.forEach((e) {
      String keyFecha =
          '${e.fechaVencimiento.year}-${e.fechaVencimiento.month.toString().padLeft(2, '0')}';

      if (!fechaFilter.containsKey(keyFecha)) {
        fechaFilter[keyFecha] = [];
      }
      fechaFilter[keyFecha]!.add(e);
    });

    // ORDEN ASCENDENTE: Convertir el Map a una Lista Ordenada por la clave (fecha)
    List<dynamic> sortedKeys = fechaFilter.keys.toList()..sort();
    //Creamos una lista (sortedKeys) que contiene las claves (fechas)
    //5del mapa, y luego la ordenamos utilizando el método sort().
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20,bottom: 180),
        controller: _scrollController,
        itemCount: sortedKeys.length, //fechaFilter.length,
        itemBuilder: (context, index) {
          // final fechaKey = fechaFilter.keys.elementAt(index);
          // final productoPorfechaV = fechaFilter[fechaKey];
          // DateTime fechaDateTime = DateTime.parse('$fechaKey-01');
          final fechaKey = sortedKeys[index];
          final productoPorfechaV = fechaFilter[fechaKey];
          //ORDENAR LA SUBLISTA
          productoPorfechaV!
              .sort((a, b) => a.fechaVencimiento.compareTo(b.fechaVencimiento));

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
                      text: 'Vence en ${fechaFiltrada(fechaDateTime)}',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      maxLines: 5,
                      color: const Color(0xFF086B74),
                    ),
                    Text(
                      '${productoPorfechaV.length} regs.',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF086B74),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if (productoPorfechaV.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productoPorfechaV.length,
                  itemBuilder: (BuildContext context, int index) {
                    final e = productoPorfechaV[index];
                    return Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          width: 35,
                          child: H2Text(
                            text: formatFechaDiaMes(e.fechaVencimiento),
                            fontSize: 9,
                            color: e.fechaVencimiento.isBefore(DateTime.now())
                                ? Colors.red
                                : Colors.black,
                            fontWeight: FontWeight.w300,
                            maxLines: 3,
                          ),
                        ),
                        Expanded(child: CardCustomProductoApp(e: e, updateStateProducto: updateStateProducto,)),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    indent: 0,
                    endIndent: 0,
                    thickness: 0,
                    height: 0,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class CardCustomProductoApp extends StatelessWidget {
  const CardCustomProductoApp({
    super.key,
    required this.e, required this.updateStateProducto,
  });

  final TProductosAppModel e;
  final VoidCallback updateStateProducto;

  @override
  Widget build(BuildContext context) {
    //FILTRAR STOCK

    List<dynamic> obtenerStock(String idProducto) {
      
      final inventarioGeneral =
          Provider.of<ViewInventarioGeneralProductosProvider>(context)
              .listInventario;
      for (var data in inventarioGeneral) {
        if (data.idProducto == e.id) {
          return [data.stock, data.cantidadEntrada, data.cantidadSalida];
        }
      }
      return [0.0,0.0,0.0];
    }

    var stock = obtenerStock(e.id)[0];
    // var totalcantidad = obtenerStock(e.id)[1];
    // var totalSalida = obtenerStock(e.id)[2];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE4E8EA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.only(right: 10),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsPageProducto(
                      e: e,
                      stockList: obtenerStock(e.id))));//NAVIGATOR ROUTE
        },
        leading: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPageProductosApp(e: e)));
                  },
                  child: _cardButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF047A7E),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    _mostrarDialogoConfirmacion(context);
                  },
                  child: _cardButton(
                      icon:
                          const Icon(Icons.delete, color: Color(0xFFAB3D35)))),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: H2Text(
                    text: e.nombreProducto,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                 Column(
                   children: [
                     const H2Text(
                      text: 'Fecha vencimiento:',
                      fontSize: 9,
                      fontWeight: FontWeight.w200,
                                     ),
                     H2Text(
                      text: formatFecha(e.fechaVencimiento),
                      fontSize: 9,
                      fontWeight: FontWeight.w200,
                                     ),
                   ],
                 ),
              ],
            ),
            H2Text(
              text: '${e.marcaProducto} * ${e.unidMedida}',
              fontSize: 11,
              fontWeight: FontWeight.w200,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  const H2Text(
                    text: 'Precio compra',
                    fontWeight: FontWeight.w200,
                    fontSize: 8,
                  ),
                  H2Text(
                    text: 'S/.${e.precioUnd}',
                    fontWeight: FontWeight.w200,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  const H2Text(
                    text: 'Precio Salida',
                    fontWeight: FontWeight.w200,
                    fontSize: 8,
                  ),
                  H2Text(
                    text: 'S/.${e.precioUnidadSalidaGrupo}',
                    fontWeight: FontWeight.w200,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const H2Text(
                    text: 'Stock',// en\n${e.unidMedida}',
                    fontWeight: FontWeight.w500,
                    fontSize: 8,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                  H2Text(
                    text: formatearNumero(stock),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: double.parse(stock.toString()) > 0
                        ? Colors.black38
                        : Colors.red,
                  ),
                ],
              ),
            ),
             const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black26,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Card _cardButton({Icon? icon}) {
    return Card(
      elevation: 5,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(0),
      child: SizedBox(height: double.infinity, width: 45, child: icon),
    );
  }

  void _mostrarDialogoConfirmacion(BuildContext context) {
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
              onPressed: () async {
               //Modo OFFLINE 
              //  final isOffline = Provider.of<UsuarioProvider>(context, listen: false).isOffline;
              //  if (isOffline) {
              //   await context.read<DBProductoAppProvider>().deleteData(e.idsql!);
              //  } else {
                await  context.read<TProductosAppProvider>().deleteTProductosApp(e.id);
              //  }
                updateStateProducto.call();
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
}
