// ignore_for_file: deprecated_member_use, avoid_print, unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_entradas.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/models/model_t_proveedor.dart';
import 'package:ausangate_op/models/model_t_salidas.dart';
import 'package:ausangate_op/provider/provider_t_entradas.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/provider/provider_t_proveedorapp.dart';
import 'package:ausangate_op/provider/provider_t_salidas.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:ausangate_op/widgets/productos_carrusel.dart';
import 'package:ausangate_op/widgets/productos_details.dart';
import 'package:ausangate_op/widgets/productos_historial.dart';
import 'package:ausangate_op/widgets/productos_proveedor.dart';
import 'package:flutter/material.dart';
import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:provider/provider.dart';

class DetailsProductos extends StatefulWidget {
  const DetailsProductos({super.key, required this.e});
  final ViewInventarioGeneralProductosModel e;

  @override
  State<DetailsProductos> createState() => _DetailsProductosState();
}

class _DetailsProductosState extends State<DetailsProductos> {
  int selectedPage = 1;
  // Índice de la imagen actual
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final listaTproductos =
        Provider.of<TProductosAppProvider>(context).listProductos;
    TProductosAppModel obtenerImage(String idProducto) {
      // Encuentra el producto con el idProducto dado
      var producto = listaTproductos.firstWhere(
        (producto) => producto.id == idProducto,
      );
      // Retorna la lista de imágenes si se encontró el producto, de lo contrario, retorna null
      return producto;
    }

    TProductosAppModel producto = obtenerImage(widget.e.idProducto);

    //FILTRAR HISTORIAL DE ENTRADAS
    final listaEntradas =
        Provider.of<TEntradasAppProvider>(context).listaEntradas;
    List<TEntradasModel> obtenerEntras(String idProducto) {
      // Encuentra el producto con el idProducto dado
      return listaEntradas
          .where(
            (e) => e.idProducto == idProducto,
          )
          .toList();
    }

    List<TEntradasModel> entradas = obtenerEntras(widget.e.idProducto);
    //FILTRAR HISTORIAL DE ENTRADAS
    final listaSalida = Provider.of<TSalidasAppProvider>(context).listSalidas;
    List<TSalidasAppModel> obtenersalidas(String idProducto) {
      // Encuentra el producto con el idProducto dado
      return listaSalida
          .where(
            (e) => e.idProducto == idProducto,
          )
          .toList();
    }

    List<TSalidasAppModel> salidas = obtenersalidas(widget.e.idProducto);

    //FILTRAR PROVEEDOR :
    final listProveedor =
        Provider.of<TProveedorProvider>(context).listaProveedor;
    TProveedorModel obtenerProveedor(String idProveedor) {
      var proveedor = listProveedor.firstWhere(
        (r) => r.id == idProveedor,
        orElse: () => TProveedorModel(
          nombreContactoProveedor: 'null',
          telefonoProveedor: 'null',
          nombreEmpresaProveedor: 'null',
          categoriaProvision: 'null',
          razonSocial: 'null',
          rucProveedor: 'null',
          ciudadProveedor: 'null',
          direccionProveedor: 'null',
          detalleAtencionOtros: 'null',
          correoProveedor: 'null',
          numeroCuentaProveedor: 'null',
          urlGoogleMaps: 'null',
          imagenGps: 'null',
        ),
      );
      return proveedor;
    }

    final proveedor = obtenerProveedor(widget.e.idProveedor);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton.filled(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black26)),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          color: Colors.white,
        ),
      ),
      body: ScrollWeb(
        child: ListView(
          children: [
            Stack(
              children: [
                (producto.imagen!.isNotEmpty && producto.imagen != [])
                    ? ImageViewCarousel(e: producto)
                    : Image.asset(
                        'assets/img/andeanlodges.png',
                        height: 300,
                      ),
                BarStatus(widget: widget)
              ],
            ),
            DeatilsCardCustom(e: widget.e),
            ProveedorCard(
              e: proveedor,
            ),
            HistorialRotacionStock(entradas: entradas, salidas: salidas)
          ],
        ),
      ),
    );
  }
}
