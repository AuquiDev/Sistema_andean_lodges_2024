// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/models/model_t_entradas.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/models/model_t_proveedor.dart';
import 'package:ausangate_op/models/model_t_ubicacion_almacen.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
// import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/provider/provider_t_entradas.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/provider/provider_t_proveedorapp.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/utils/custom_colores.dart';
import 'package:ausangate_op/utils/formatear_numero.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/format_fecha.dart';

class MovimientosPageEntrada extends StatelessWidget {
  const MovimientosPageEntrada(
      {super.key,
     });

  @override
  Widget build(BuildContext context) {
    final listaTproductos =
        Provider.of<TEntradasAppProvider>(context).listaEntradas;
    return MovimientosPageData(listEntradas: listaTproductos);
  }
}

class MovimientosPageData extends StatefulWidget {
  const MovimientosPageData(
      {super.key,
      required this.listEntradas});

  final List<TEntradasModel> listEntradas;

  @override
  State<MovimientosPageData> createState() => _MovimientosPageDataState();
}

class _MovimientosPageDataState extends State<MovimientosPageData> {
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
  late List<TEntradasModel> filterTidEmpleado;

  //Le tenemos que pasar como parametro el id de ubiciones
  _filterTEmpleados(String searchText) {
    filterTidEmpleado = widget.listEntradas
        .where((e) => e.idEmpleado.contains(searchText))
        .toList();
  }

  //FILTRAMOS lal ogica del buscador de producto en base a lista filtrada de ubicacion
  late TextEditingController _searchTextEditingController;
  late List<TEntradasModel> filterTProductos;
  _filterTEntradas(String seachText) {
    setState(() {
      filterTProductos = filterTidEmpleado
          .where((e) =>
              e.idProveedor.toLowerCase().contains(seachText.toLowerCase()) ||
              e.idProducto.toLowerCase().contains(seachText.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    
    filterTidEmpleado = widget.listEntradas;
    _searchTextEditingController = TextEditingController();
    filterTProductos = filterTidEmpleado;
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

  //TEXTO nombre de ubicacion segun el boton se asigna el valor al titulo de ubicacion
  String tituloEmpleado = 'Lista General';

  @override
  Widget build(BuildContext context) {
    //LISTA UBICACIONES ALMACÉN
    final ubicacionProvider = Provider.of<TEmpleadoProvider>(context);
    List<TEmpleadoModel> listaempleados = ubicacionProvider.listaEmpleados
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Cierra el teclado cuando tocas en cualquier lugar de la pantalla
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: showAppBar
                ? AppBar(
                   leading: const Icon(Icons.circle, color: Colors.transparent,),
                  leadingWidth: 0,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    centerTitle: false,
                    title: const H2Text(
                      text: 'Historial de Entradas',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                    bottom: PreferredSize(
                        preferredSize: const Size(double.infinity, 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: H2Text(
                                text: 'Filtrar usuario',
                                color: Color(0x67342E2E),
                                fontSize: 10,
                              ),
                            ),
                            ButtonBar(
                              buttonPadding: const EdgeInsets.all(0),
                              children: [
                                // LISTA DE USUARIOS
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
                                      ...List.generate(listaempleados.length,
                                          (index) {
                                        final e = listaempleados[index];
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
                                                          Colors.deepOrange),
                                                  overlayColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.white),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  padding:
                                                      MaterialStatePropertyAll(
                                                          EdgeInsets.all(5))),
                                              onPressed: () {
                                                _filterTEmpleados(
                                                    e.id.toString());
                                                _filterTEntradas('');
                                                tituloEmpleado = e.nombre;
                                              },
                                              icon: const Icon(
                                                Icons.emoji_people_rounded,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                              label: H2Text(
                                                text: e.nombre,
                                                fontSize: 10,
                                                maxLines: 2,
                                                color: Colors.white,
                                              )),
                                        );
                                      }),
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
                          hintText: 'Copie y pegue el Idproducto o Idproveedor',
                          labelText: 'Filtrar por Idproducto o Idproveedor',
                         prefixIcon: IconButton(onPressed: (){
                            _searchTextEditingController.clear();
                            _filterTEntradas('');
                          }, icon:_searchTextEditingController.text.isEmpty ? const Icon(Icons.search) :  const Icon(Icons.close) ),
                        )),
                  ),
                ),
                H2Text(
                    text: tituloEmpleado,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5B5353)),
                ListMovimientosAPP(
                    scrollController: _scrollController,
                    listaTproductos: filterTProductos),
              ],
            )),
      ),
    );
  }
}

class ListMovimientosAPP extends StatelessWidget {
  const ListMovimientosAPP({
    super.key,
    required ScrollController scrollController,
    required this.listaTproductos,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<TEntradasModel> listaTproductos;

  @override
  Widget build(BuildContext context) {
    //FILTRADO Por fecha de creacion. agrupoar por mes y año
    Map<dynamic, List<TEntradasModel>> fechaFilter = {};

    listaTproductos.forEach((e) {
      String keyFecha =
          '${e.created!.year}-${e.created!.month.toString().padLeft(2, '0')}';

      if (!fechaFilter.containsKey(keyFecha)) {
        fechaFilter[keyFecha] = [];
      }
      fechaFilter[keyFecha]!.add(e);
    });

    // ORDEN ASCENDENTE: Convertir el Map a una Lista Ordenada por la clave (fecha)
    List<dynamic> sortedKeys = fechaFilter.keys.toList()
      ..sort(
        (a, b) => a.compareTo(b),
      );
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20, bottom: 180),
        controller: _scrollController,
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
                      color: Colors.deepOrange,
                    ),
                    Text(
                      '${entradaFcreacion.length} regs.',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrange),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.deepOrange,
              ),
              if (entradaFcreacion.isNotEmpty)
                ListView.builder(
                  padding: const EdgeInsets.only(left: 30),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entradaFcreacion.length,
                  itemBuilder: (BuildContext context, int index) {
                    final e = entradaFcreacion.reversed.toList()[index];
                    return CardCustomMovimientoApp(e: e);
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class CardCustomMovimientoApp extends StatelessWidget {
  const CardCustomMovimientoApp({
    super.key,
    required this.e,
  });

  final TEntradasModel e;

  @override
  Widget build(BuildContext context) {
    TProductosAppModel obtenerProducto(String idProducto) {
      final listaProducto =
          Provider.of<TProductosAppProvider>(context).listProductos;
      for (var data in listaProducto) {
        if (data.id == e.idProducto) {
          return data;
        }
      }
      // Puedes devolver un objeto predeterminado o lanzar una excepción
      // En este caso, estoy lanzando una excepción para indicar que el producto no fue encontrado
      return TProductosAppModel(
        idProveedor: '', 
        nombreProducto: 'Producto eliminado', 
        marcaProducto: '', 
        unidMedida: '', 
        precioUnd: 0, 
        unidMedidaSalida: '', 
        precioUnidadSalidaGrupo: 0, 
        descripcionUbicDetll: '', 
        tipoProducto: '', fechaVencimiento:DateTime.now() , estado: false, id: '', idCategoria: '', idUbicacion: '');
    }

    final p = obtenerProducto(e.idProducto);

    TUbicacionAlmacenModel obtenerUbicacion(String idUbicacion) {
      final listaUbicacion =
          Provider.of<TUbicacionAlmacenProvider>(context).listUbicacion;
      for (var data in listaUbicacion) {
        if (data.id == p.idUbicacion) {
          return data;
        }
      }
      // Puedes devolver un objeto predeterminado o lanzar una excepción
      // En este caso, estoy lanzando una excepción para indicar que el producto no fue encontrado
      return TUbicacionAlmacenModel(nombreUbicacion: '', descripcionUbicacion: '');
    }

    final u = obtenerUbicacion(p.idUbicacion);

    TProveedorModel obtenerProveedor(String idProveedor) {
      final listaProveedor =  Provider.of<TProveedorProvider>(context).listaProveedor;
      for (var data in listaProveedor) {
        if (data.id == p.idProveedor) {
          return data;
        }
      }
      return TProveedorModel(
        nombreContactoProveedor: '', 
        telefonoProveedor: '', 
        nombreEmpresaProveedor: '', 
        categoriaProvision: '', 
        razonSocial: '', 
        rucProveedor: '', 
        ciudadProveedor: '', 
        direccionProveedor: '', 
        detalleAtencionOtros: '', 
        correoProveedor: '', 
        numeroCuentaProveedor: '', 
        urlGoogleMaps: '', imagenGps: '');
    }

    final v = obtenerProveedor(e.idProveedor);

    return Card(
      shadowColor: Colors.black87,
      surfaceTintColor: const Color(0xFF000000),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(right: 10),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H2Text(
                  text:
                      '${p.nombreProducto} * ${p.unidMedida} * ${p.marcaProducto}',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                H2Text(
                  text: 'Almacén : ${u.nombreUbicacion}',
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                ),
                H2Text(
                  text: 'Proveedor : ${v.nombreEmpresaProveedor} * ${v.ciudadProveedor}',
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Column(
                        children: [
                          const H2Text(
                            text: 'Cantd. entrada',
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                          ),
                          H2Text(
                            text: formatearNumero(e.cantidadEntrada),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: CustomColors.accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const H2Text(
                            text: 'Precio entrada',
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                          ),
                          H2Text(
                            text: 'S/.${e.precioEntrada}',
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: CustomColors.accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const H2Text(
                            text: 'Costo total.',
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                          ),
                          H2Text(
                            text: e.costoTotal == 0
                                ? (e.cantidadEntrada * e.precioEntrada)
                                    .toStringAsFixed(2)
                                    .toString()
                                : 'S/.${e.costoTotal}',
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: CustomColors.accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  H2Text(
                    text: e.descripcionEntrada,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const H2Text(
                            text: 'IDProducto : ',
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                         TextButton.icon(
                          style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.all(0))
                          ),
                          onPressed: (){
                           _showContextMenu(context, e.idProducto, 'IdProducto', Colors.purple);
                         }, 
                          label:H2Text(
                            text: e.idProducto,
                            fontWeight: FontWeight.w400,
                            fontSize: 9,
                          ),
                          icon: const Icon(
                            Icons.copy,
                            size: 13,
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          const H2Text(
                            text: 'IDProveedor : ',
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                          TextButton.icon(
                             style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.all(0))
                          ),
                            onPressed: (){
                             _showContextMenu(context, e.idProveedor, 'IDProveedor', Colors.pink);
                          }, 
                         label: H2Text(
                            text: e.idProveedor,
                            fontWeight: FontWeight.w400,
                            fontSize: 9,
                          ),
                         icon:  const Icon(
                            Icons.copy,
                            size: 13,
                          ))
                        ],
                      ),
                     
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          H2Text(
                            text: (e.created!.day == DateTime.now().day)
                                ? 'Creado hoy'
                                : 'Creado',
                            fontSize: 9,
                            fontWeight: FontWeight.w300,
                            color: (e.created!.day == DateTime.now().day)
                                ? const Color(0xFF07CC17)
                                : Colors.black,
                          ),
                          H2Text(
                            text: formatFechaHora(e.created!),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      (e.created != e.updated)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const H2Text(
                                  text: 'Editado',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w300,
                                ),
                                H2Text(
                                  text: formatFechaHora(e.updated!),
                                  fontSize: 9,
                                  color: (e.created != e.updated)
                                      ? const Color(0xFF0373D0)
                                      : Colors.black,
                                  fontWeight: FontWeight.w800,
                                  maxLines: 3,
                                ),
                              ],
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, String text, String title, Color color) {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final RenderBox button = context.findRenderObject() as RenderBox;
  final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

  showMenu(
    color: color,
    context: context,
    position: RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy + button.size.height,
      buttonPosition.dx + button.size.width,
      buttonPosition.dy + button.size.height * 2,
    ),
    items: [
      PopupMenuItem(
        value: 'copy $title',
        child: H2Text(text:'Copiar $title', color: Colors.white,fontSize: 12,),
      ),
    ],
  ).then((value) {
    if (value == 'copy $title') {
      // Copiar el texto al portapapeles
      Clipboard.setData(ClipboardData(text: text));
    }
  });
}

}
