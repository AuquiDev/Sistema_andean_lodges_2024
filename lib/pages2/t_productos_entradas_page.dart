import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/models/model_t_entradas.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/models/model_t_proveedor.dart';
import 'package:ausangate_op/pages2/t_productos_entradas_editing.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/provider/provider_t_entradas.dart';
import 'package:ausangate_op/provider/provider_t_proveedorapp.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductosEntradas extends StatefulWidget {
  const ProductosEntradas({
    super.key,
    required this.producto,
    required this.categoria,
    required this.ubicacion,
    required this.proveedor,
    required this.stockList,
    required ScrollController scrollController,
    required this.showAppBar,
  }) : _scrollController = scrollController;

  final TProductosAppModel producto;
  final String categoria;
  final String ubicacion;
  final String proveedor;
  final List<dynamic> stockList;

  final ScrollController _scrollController;
  final bool showAppBar;

  @override
  State<ProductosEntradas> createState() => _ProductosEntradasState();
}

class _ProductosEntradasState extends State<ProductosEntradas> {
  @override
  Widget build(BuildContext context) {
    List<TEntradasModel> obtenerEntradas(String idProducto) {
      final listaEntradas =
          Provider.of<TEntradasAppProvider>(context).listaEntradas;
      //Filtrar salidas
      List<TEntradasModel> entradasFiltradas = listaEntradas
          .where((e) => e.idProducto == widget.producto.id)
          .toList();
      return entradasFiltradas
        ..sort((a, b) => a.created!.compareTo(b.created!));
    }

    final listaEmpleados = Provider.of<TEmpleadoProvider>(context)
        .listaEmpleados
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
    final listaProveedor = Provider.of<TProveedorProvider>(context)
        .listaProveedor
      ..sort((a, b) =>
          a.nombreEmpresaProveedor.compareTo(b.nombreEmpresaProveedor));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          obtenerEntradas(widget.producto.id).isEmpty
              ? const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: H2Text(
                          text: 'No se encontraron salidas para este producto.',
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    controller: widget._scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: obtenerEntradas(widget.producto.id).length,
                    itemBuilder: (context, index) {
                      final e = obtenerEntradas(widget.producto
                              .id) //Lista ENtradas Filtradas ppor producto
                          .reversed
                          .toList()[index];
                      return CardCustomEntradasApp(
                        e: e,
                        listaProveedor: listaProveedor,
                        listaEmpleados: listaEmpleados,
                        producto: widget.producto,
                        stockList: widget.stockList,
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.deepOrange),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EntradasForm(
                          producto: widget.producto,
                          // listaEmpleados: listaEmpleados,
                          // stockList: widget.stockList,
                          // listaProveedor: listaProveedor,
                        )));
          },
          child: const H2Text(
            text: 'Añadir nuevo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.white,
          )),
    );
  }
}

class CardCustomEntradasApp extends StatelessWidget {
  const CardCustomEntradasApp({
    super.key,
    required this.e,
    required this.listaProveedor,
    required this.listaEmpleados,
    required this.producto,
    required this.stockList,
  });

  final TEntradasModel e;
  final List<TProveedorModel> listaProveedor;
  final List<TEmpleadoModel> listaEmpleados;
  final TProductosAppModel producto;
  final List<dynamic> stockList;
  @override
  Widget build(BuildContext context) {
    String obtenerEmpleado(String idEmpleado) {
      for (var data in listaEmpleados) {
        if (data.id == e.idEmpleado) {
          return '${data.nombre} ${data.apellidoPaterno} ${data.apellidoMaterno}';
        }
      }
      return 'null';
    }

    String obtenerProveedor(String idTrabajo) {
      final listaProveedor =
          Provider.of<TProveedorProvider>(context).listaProveedor;
      for (var data in listaProveedor) {
        if (data.id == e.idProveedor) {
          return 'EMPRESA : ${data.nombreEmpresaProveedor}\nCIUDAD : ${data.ciudadProveedor}\nCORREO: ${data.correoProveedor}';
        }
      }
      return 'null';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: const Color(0xFFF1EEF1),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.all(0),
        leading: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {
                    // var idusuario = context.read<UsuarioProvider>().idUsuario;
                     var idusuario = context.read<UsuarioProvider>().usuarioEncontrado!.id;

                    if (idusuario == e.idEmpleado) {
                      //SOLO EL USUARIO QUE CREO PUEDO EDITAR
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EntradasForm(
                                  e: e,
                                  producto: producto,
                                  )));
                    } else {
                      showSialogButon(context,
                          'Solo el creador de este registro tiene permisos para editarlo.');
                    }
                  },
                  child: _cardButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF047A7E),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    // var idusuario = context.read<UsuarioProvider>().idUsuario;
                     var idusuario = context.read<UsuarioProvider>().usuarioEncontrado!.id;
                    if (idusuario == e.idEmpleado) {
                      //ELIMINAR SI Y SILO SI la fecha esta en un plaso de dos dias despues de al creacion
                      final diferenceDias =
                          DateTime.now().difference(e.created!).inDays;
                      if (diferenceDias <= 2) {
                        _mostrarDialogoConfirmacion(context); //ELIMINAR
                      } else {
                        showSialogEdicion(context,
                            'El plazo máximo para eliminar un registro es de dos días después de la creación.');
                      }
                    } else {
                      showSialogButon(context,
                          'Solo el creador de este registro tiene permisos para eliminarlo.');
                    }
                  },
                  child: _cardButton(
                      icon:
                          const Icon(Icons.delete, color: Color(0xFFAB3D35)))),
            ],
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2Text(
                    text:
                        '${producto.nombreProducto} * ${producto.unidMedidaSalida} * ${producto.marcaProducto}',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H2Text(
                        text: 'Created : ${formatFechaHora(e.created!)}',
                        fontSize: 8,
                        fontWeight: FontWeight.w200,
                      ),
                      H2Text(
                        text: 'updated : ${formatFechaHora(e.updated!)}',
                        fontSize: 8,
                        fontWeight: FontWeight.w200,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  H2Text(
                    text: 'Creador por:  ${obtenerEmpleado(e.idEmpleado)}',
                    fontSize: 9,
                    fontWeight: FontWeight.w200,
                  ),
                  H2Text(
                    text: 'Editado por:  ${obtenerEmpleado(e.idEmpleado)}',
                    fontSize: 9,
                    fontWeight: FontWeight.w200,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(100, 38),
                          // maximumSize: const Size(110, 38),
                          padding: const EdgeInsets.all(3),
                          side: const BorderSide(
                            color: Color(0xFF0A7E95),
                            width: 1,
                          )),
                      onPressed: null,
                      child: Column(
                        children: [
                          const H2Text(
                            text: '# Entradas',
                            fontSize: 9,
                            fontWeight: FontWeight.w200,
                          ),
                          H2Text(
                            text: '${e.cantidadEntrada}',
                            fontSize: 17,
                            color: const Color(0xFF0A7E95),
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                    const H2Text(
                      text: 'Proveedor',
                      fontSize: 9,
                      fontWeight: FontWeight.w200,
                    ),
                    H2Text(
                      text: obtenerProveedor(e.idProveedor),
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF251267),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
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
              onPressed: () {
                context.read<TEntradasAppProvider>().deleteTEntradasApp(e.id!);
                _eliminarElemento(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void showSialogEdicion(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Alerta de Acción No Permitida!'),
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

  void _eliminarElemento(BuildContext context) {
    // Mostrar SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Elemento eliminado correctamente"),
      ),
    );

    Navigator.of(context).pop();
  }

  void showSialogButon(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Acceso Denegado'),
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
