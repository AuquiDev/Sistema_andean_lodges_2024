// ignore_for_file: deprecated_member_use, avoid_print

import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/pages2/t_productos_entradas_page.dart';
import 'package:ausangate_op/pages2/t_productos_salidas_details.dart';
import 'package:ausangate_op/pages2/t_productos_salidas_page.dart';
import 'package:ausangate_op/provider/provider_t_categoria_almacen.dart';
import 'package:ausangate_op/provider/provider_t_proveedorapp.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/provider/provider_v_inventario_general_productos.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/widgets/custom_app_bar_entra_salid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class DetailsPageProducto extends StatefulWidget {
  const DetailsPageProducto({
    super.key,
    required this.e,
    required this.stockList,
  });
  final TProductosAppModel e;
  final List<dynamic> stockList;

  @override
  State<DetailsPageProducto> createState() => _DetailsPageProductoState();
}

class _DetailsPageProductoState extends State<DetailsPageProducto> {
  final ScrollController _scrollController = ScrollController();
  bool showAppBar = true;
  
 void _onScroll() {
  try {
    setState(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        // Scroll Abajo
        showAppBar = true;
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        // Scroll Arriba
        showAppBar = false;
      }
    });
  } catch (e, stackTrace) {
    // Maneja la excepción de forma adecuada, por ejemplo, imprimiendo información de depuración.
    print("Error en _onScroll: $e\n$stackTrace");
  }
}
 

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String obtenerCategiria(String idCategoria) {
      final listaCategoria =
          Provider.of<TCategoriaProvider>(context).listcategory;
      for (var data in listaCategoria) {
        if (widget.e.idCategoria == data.id) {
          return data.categoria;
        }
      }
      return widget.e.idCategoria;
    }

    String obtenerUbicacion(String idUbicacion) {
      final listaCategoria =
          Provider.of<TUbicacionAlmacenProvider>(context).listUbicacion;
      for (var data in listaCategoria) {
        if (widget.e.idUbicacion == data.id) {
          return data.nombreUbicacion;
        }
      }
      return '-';
    }

    String obtenerProveedor(String idProveedor) {
      final listaCategoria =
          Provider.of<TProveedorProvider>(context).listaProveedor;
      for (var data in listaCategoria) {
        if (widget.e.idProveedor == data.id) {
          return data.nombreEmpresaProveedor;
        }
      }
      return 'sin proveedor';
    }
    //Se puso este paso adicional. para obtener nuevvamente el stock actualizado.
    //ADICONAL ACTULIZACION REFRESH NESESARIO. 
     List<dynamic> obtenerStock(String idProducto) {
      final inventarioGeneral =
          Provider.of<ViewInventarioGeneralProductosProvider>(context)
              .listInventario;
      for (var data in inventarioGeneral) {
        if (data.idProducto == widget.e.id) {
          return [data.stock, data.cantidadEntrada, data.cantidadSalida];
        }
      }
      return [0.0, 0.0, 0.0];
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: showAppBar? 90 : null,
            title:showAppBar? Column(
              children: [
                H2Text(
                  text: widget.e.nombreProducto,
                  fontWeight: FontWeight.w800,
                ),
                H2Text(
                  text: obtenerCategiria(widget.e.idCategoria),
                  fontWeight: FontWeight.w200,
                  fontSize: 11,
                ),
              ],
            ):const SizedBox(),
            bottom: PreferredSize(
              preferredSize:  Size(double.infinity,showAppBar? 150 : 0),
              child: Column(
                children: [
                 showAppBar? CustomAppBarPRoductos(
                    producto: widget.e,
                    categoria: obtenerCategiria(widget.e.idCategoria),
                    ubicacion: obtenerUbicacion(widget.e.idUbicacion),
                    precio:
                        widget.e.precioUnidadSalidaGrupo.toStringAsFixed(2),
                    undMedida: widget.e.unidMedidaSalida,
                    stockList: obtenerStock(widget.e.id)//widget.stockList,
                  ):const SizedBox(),
                  const TabBar(tabs: [
                    Tab(text: 'Producto'),
                    Tab(text: 'Entradas'),
                    Tab(text: 'Salidas'),
                  ]),
                ],
              ),
            )),
        body: GestureDetector(
          onDoubleTap: () {
            setState(() {
               showAppBar = true;
            });
          },
          child: TabBarView(
            children: [
              DetallesPage(
                e: widget.e,
                categoria: obtenerCategiria(widget.e.idCategoria),
                ubicacion: obtenerUbicacion(widget.e.idUbicacion),
                proveedor: obtenerProveedor(widget.e.idProveedor),
                 scrollController: _scrollController,showAppBar: showAppBar,
              ),
               ProductosEntradas(
                producto: widget.e,
                categoria: obtenerCategiria(widget.e.idCategoria),
                ubicacion: obtenerUbicacion(widget.e.idUbicacion),
                proveedor: obtenerProveedor(widget.e.idProveedor),
                stockList:  obtenerStock(widget.e.id),//widget.stockList,
                scrollController: _scrollController,showAppBar: showAppBar,
              ),
              ProductosSalidas(
                producto: widget.e,
                categoria: obtenerCategiria(widget.e.idCategoria),
                ubicacion: obtenerUbicacion(widget.e.idUbicacion),
                proveedor: obtenerProveedor(widget.e.idProveedor),
                stockList:  obtenerStock(widget.e.id),//widget.stockList,
                scrollController: _scrollController,showAppBar: showAppBar,
              ),
            ],
          ),
        ),
      ),
    );
    
  }

 
}
