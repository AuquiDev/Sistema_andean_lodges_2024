import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/models/model_t_salidas.dart';
import 'package:ausangate_op/pages2/t_productos_salidas_editing_page.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/provider/provider_t_salidas.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProductosSalidas extends StatefulWidget {
  const ProductosSalidas({
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
  State<ProductosSalidas> createState() => _ProductosSalidasState();
}

class _ProductosSalidasState extends State<ProductosSalidas> {
  //FUNCION PARA BLOQUEAR el giro de pantalla y mantenerla en Vertical.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Bloquear la rotación de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo retrato
    ]);
  }

  @override
  Widget build(BuildContext context) {
    List<TSalidasAppModel> obtenerSalidas(String idProducto) {
      final listaSalidas =
          Provider.of<TSalidasAppProvider>(context).listSalidas;
      //Filtrar salidas
      List<TSalidasAppModel> salidasFiltradas = listaSalidas
          .where((e) => e.idProducto == widget.producto.id)
          .toList();

      return salidasFiltradas;
      // ..sort((a, b) => a.created!.compareTo(b.created!));
    }

    final listDetallTrabajo = Provider.of<TDetalleTrabajoProvider>(context)
        .listaDetallTrabajo
      ..sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));
    final listaEmpleados = Provider.of<TEmpleadoProvider>(context)
        .listaEmpleados
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OutlinedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.indigo),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalidasForm(
                                  producto: widget.producto,
                                  listDetallTrabajo: listDetallTrabajo,
                                  listaEmpleados: listaEmpleados,
                                  stockList: widget.stockList,
                                )));
                  },
                  child: const H2Text(
                    text: 'Añadir nuevo',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  )),
              obtenerSalidas(widget.producto.id).isEmpty
                  ? const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: H2Text(
                              text:
                                  'No se encontraron salidas para este producto.',
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
                        itemCount: obtenerSalidas(widget.producto.id).length,
                        itemBuilder: (context, index) {
                          final e = obtenerSalidas(widget.producto.id)
                              .reversed
                              .toList()[index];
                          return CardCustomProductoApp(
                            e: e,
                            listDetallTrabajo: listDetallTrabajo,
                            listaEmpleados: listaEmpleados,
                            producto: widget.producto,
                            stockList: widget.stockList,
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardCustomProductoApp extends StatelessWidget {
  const CardCustomProductoApp({
    super.key,
    required this.e,
    required this.listDetallTrabajo,
    required this.listaEmpleados,
    required this.producto,
    required this.stockList,
  });

  final TSalidasAppModel e;
  final List<TDetalleTrabajoModel> listDetallTrabajo;
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

    String obtenertrabajo(String idTrabajo) {
      for (var data in listDetallTrabajo) {
        if (data.id == e.idTrabajo) {
          return 'GRUPO : ${data.codigoGrupo}'; // : ${data.itinerarioDiasNoches}\nPROGRAMA: ${data.programacion}';
        }
      }
      return 'null';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: const Color(0x117C7B7B),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalidasForm(
                                e: e,
                                producto: producto,
                                listDetallTrabajo: listDetallTrabajo,
                                listaEmpleados: listaEmpleados,
                                stockList: stockList,
                                empleado: obtenerEmpleado(e.idEmpleado),
                                trabajo: obtenertrabajo(e.idTrabajo))));
                  },
                  child: _cardButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF047A7E),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    //ELIMINAR SI Y SILO SI la fecha esta en un plaso de dos dias despues de al creacion
                    final diferenceDias =
                        DateTime.now().difference(e.created!).inDays;
                    if (diferenceDias <= 2) {
                      _mostrarDialogoConfirmacion(context); //ELIMINAR
                    } else {
                      showSialogEdicion(context,
                          'El plazo máximo para eliminar un registro es de dos días después de la creación.');
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
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // H2Text(
                      //   text: 'Created : ${formatFechaHora(e.created!)}',
                      //   fontSize: 9,
                      // ),
                      // H2Text(
                      //   text: 'updated : ${formatFechaHora(e.updated!)}',
                      //   fontSize: 9,
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  H2Text(
                    text: 'Entregado a:  ${obtenerEmpleado(e.idEmpleado)}',
                    fontSize: 10,
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
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          )),
                      onPressed: null,
                      child: Column(
                        children: [
                          const H2Text(
                            text: '# Salidas',
                            fontSize: 9,
                          ),
                          H2Text(
                            text: '${e.cantidadSalida}',
                            fontSize: 17,
                            color: const Color(0xFF0A7E95),
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                    H2Text(
                      text: obtenertrabajo(e.idTrabajo),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
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
                context.read<TSalidasAppProvider>().deleteTSalidasApp(e.id);
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
}
