// ignore_for_file: unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/models/model_t_salidas.dart';
import 'package:ausangate_op/provider/provider_t_salidas.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SalidasForm extends StatefulWidget {
  const SalidasForm({
    super.key,
    required this.producto,
    required this.listDetallTrabajo,
    required this.listaEmpleados,
    required this.stockList,
    this.e,
    this.empleado,
    this.trabajo,
  });

  final TProductosAppModel producto;
  final List<TDetalleTrabajoModel> listDetallTrabajo;
  final List<TEmpleadoModel> listaEmpleados;
  final List<dynamic> stockList;
  final TSalidasAppModel? e;
  final String? empleado;
  final String? trabajo;

  @override
  State<SalidasForm> createState() => _SalidasFormState();
}

class _SalidasFormState extends State<SalidasForm> {
  final TextEditingController _idProductoController = TextEditingController();
  final TextEditingController _idEmpleadoController = TextEditingController();
  final TextEditingController _idtrabajoController = TextEditingController();
  final TextEditingController _cantidadSalidaController =
      TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String empleado = '';
  String codigogrupo = '';

  var title = 'Crear nueva Salida';

  @override
  void initState() {
    if (widget.e != null) {
      _idProductoController.text = widget.e!.idProducto;
      _idEmpleadoController.text = widget.e!.idEmpleado;
      _idtrabajoController.text = widget.e!.idTrabajo;
      _cantidadSalidaController.text = (widget.e!.cantidadSalida).toString();
      _descripcionController.text = widget.e!.descripcionSalida;
      title = 'Editar Registro';
      empleado = widget.empleado!;
      codigogrupo = widget.trabajo!;
    } else {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final salidasLoading = Provider.of<TSalidasAppProvider>(context).isSyncing;
    return GestureDetector(
      onTap: () {
        // FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 100,
            title: Column(
              children: [
                H2Text(
                  text:
                      '${widget.producto.nombreProducto} * ${widget.producto.marcaProducto} - ${widget.producto.unidMedidaSalida}',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const H2Text(
                  text: 'Salida de producto',
                  fontSize: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                H2Text(
                  text: title.toUpperCase(),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 0),
                    child: H2Text(
                        text: 'Nueva Salida'.toUpperCase(),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _idEmpleadoController,
                            readOnly:
                                true, // Deshabilita la edición directa del texto
                            showCursor:
                                true, // Muestra el cursor al tocar el campo
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'A quien entrega',
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.black45)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo obligatorio';
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              showModalBottomSheet(
                                  constraints: BoxConstraints.loose(
                                      Size.fromHeight(
                                          MediaQuery.of(context).size.height *
                                              .75)),
                                  scrollControlDisabledMaxHeightRatio:
                                      BorderSide.strokeAlignOutside,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      margin: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const DividerCustom(),
                                          const Center(
                                            child: H2Text(
                                              text: 'Seleccione una opción.',
                                              fontWeight: FontWeight.w200,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                              itemCount:
                                                  widget.listaEmpleados.length,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(
                                                thickness: 0,
                                                height: 0,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final e = widget
                                                    .listaEmpleados[index];
                                                return ListTile(
                                                  dense: false,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  leading: const Icon(
                                                    Icons.person,
                                                    color: Colors.green,
                                                    size: 15,
                                                  ),
                                                  title: H2Text(
                                                    text:
                                                        '${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                  ),
                                                  subtitle: H2Text(
                                                    text: e.modalidadLaboral,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                  onTap: () {
                                                    _idEmpleadoController.text =
                                                        e.id!;

                                                    setState(() {
                                                      empleado =
                                                          '${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}';
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _idtrabajoController,
                            readOnly:
                                true, // Deshabilita la edición directa del texto
                            showCursor:
                                true, // Muestra el cursor al tocar el campo
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Codígo de grupo: $codigogrupo',
                                prefixIcon: const Icon(Icons.panorama_fisheye,
                                    color: Colors.black45)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo obligatorio';
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              showModalBottomSheet(
                                  constraints: BoxConstraints.loose(
                                      Size.fromHeight(
                                          MediaQuery.of(context).size.height *
                                              .80)),
                                  scrollControlDisabledMaxHeightRatio:
                                      BorderSide.strokeAlignOutside,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      margin: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const DividerCustom(),
                                          const Center(
                                            child: H2Text(
                                              text:
                                                  'Seleccione el Codígo de Grupo.',
                                              fontWeight: FontWeight.w200,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                              itemCount: widget
                                                  .listDetallTrabajo.length,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(
                                                thickness: 0,
                                                height: 0,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final e = widget
                                                    .listDetallTrabajo[index];
                                                return ListTile(
                                                  dense: false,
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  leading: SizedBox(
                                                    width: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        H2Text(
                                                          text: e.codigoGrupo,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 20,
                                                        ),
                                                        const H2Text(
                                                          text:
                                                              'Codígo de grupo.',
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 9,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  title: const H2Text(
                                                    text:
                                                        'Se borro Detalle Trabajo',
                                                    // "${e.itinerarioDiasNoches} / ${e.programacion} / ${e.restriccionGrupo}",
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 10,
                                                  ),
                                                  subtitle: SizedBox(
                                                    width: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const H2Text(
                                                              text: 'Entrada :',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              fontSize: 9,
                                                            ),
                                                            H2Text(
                                                              text:
                                                                  '   ${formatFecha(e.fechaInicio)}',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 9,
                                                              color:
                                                                  Colors.indigo,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const H2Text(
                                                              text: 'Retorno :',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              fontSize: 9,
                                                            ),
                                                            H2Text(
                                                              text:
                                                                  '   ${formatFecha(e.fechaFin)}',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              color:
                                                                  Colors.indigo,
                                                              fontSize: 9,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    _idtrabajoController.text =
                                                        e.id!;
                                                    codigogrupo = e.codigoGrupo;
                                                    setState(() {});
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _cantidadSalidaController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Cantidad de Salida:',
                                prefixIcon: const Icon(Icons.panorama_fisheye,
                                    color: Colors.black45)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo obligatorio';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _descripcionController,
                            maxLength: 250,
                            maxLines: 1,
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText:
                                    '(Restricciones, Detalles de uso, Recomendaciones, observaciones, etc.)',
                                prefixIcon: const Icon(Icons.panorama_fisheye,
                                    color: Colors.black45)),
                          ),
                        ),
                      ),
                       TextButton(
                    onPressed: salidasLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.e != null) {
                                editarSalida();
                                _formKey.currentState!.save();
                              } else {
                                guardarSalida();
                                _formKey.currentState!.save();
                              }
                            } else {
                              // Mostrar un SnackBar indicando el primer campo con error
                              completeForm();
                            }
                          },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 40,
                        width: 80,
                        child: Center(
                            child: salidasLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : const H2Text(
                                    text: 'Guardar',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ))),
                  ),
                    ],
                  ),
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void completeForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: H2Text(
          text: '🚨 Por favor, completa todos los campos obligatorios.',
          maxLines: 3,
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> editarSalida() async {
    double stock = widget.stockList[0];
    // Verificar si el registro fue creado hace menos de dos días
    final diferenceDias = DateTime.now().difference(widget.e!.created!).inDays;

    if (diferenceDias <= 2) {
      if (stock > 0) {
        if (stock >= convertirTextoADouble(_cantidadSalidaController.text)) {
          if (widget.producto.fechaVencimiento.isAfter(DateTime.now())) {
            _idProductoController.text = widget.producto.id;
            await context.read<TSalidasAppProvider>().updateSalidasProvider(
                  id: widget.e!.id,
                  idProducto: _idProductoController.text,
                  idEmpleado: _idEmpleadoController.text,
                  idTrabajo: _idtrabajoController.text,
                  cantidadSalida:
                      convertirTextoADouble(_cantidadSalidaController.text),
                  descripcionSalida: _descripcionController.text,
                );
            snackBarButon('✅ Registro editado correctamente.');
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          } else {
            showSialogFechaVencimiento(
                'El producto ha alcanzado su fecha de vencimiento.');
          }
        } else {
          showSialogButon(
              'La cantidad de salida es mayor que el stock disponible.');
        }
      } else {
        showSialogButon('El stock de este producto es insuficiente');
      }
    } else {
      showSialogEdicion(
          'El plazo máximo para editar es de dos días después de la creación.');
    }
  }

  Future<void> guardarSalida() async {
    double stock = widget.stockList[0];
    if (stock > 0) {
      if (stock >= convertirTextoADouble(_cantidadSalidaController.text)) {
        if (widget.producto.fechaVencimiento.isAfter(DateTime.now())) {
          _idProductoController.text = widget.producto.id;
          await context.read<TSalidasAppProvider>().postSalidasProvider(
                id: '',
                idProducto: _idProductoController.text,
                idEmpleado: _idEmpleadoController.text,
                idTrabajo: _idtrabajoController.text,
                cantidadSalida:
                    convertirTextoADouble(_cantidadSalidaController.text),
                descripcionSalida: _descripcionController.text,
              );
          snackBarButon('✅ Registro guardado correctamente.');
          _clearn();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          showSialogFechaVencimiento(
              'El producto ha alcanzado su fecha de vencimiento.');
        }
      } else {
        showSialogButon(
            'La cantidad de salida es mayor que el stock disponible.');
      }
    } else {
      showSialogButon('El stock de este producto es insuficiente');
    }
  }

  void _clearn() {
    _idProductoController.clear();
    _idEmpleadoController.clear();
    _idtrabajoController.clear();
    _cantidadSalidaController.clear();
    _descripcionController.clear();
  }

  void snackBarButon(String e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          H2Text(
            text: e,
            maxLines: 3,
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ));
  }

  void showSialogButon(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Stock insuficiente'),
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

  void showSialogFechaVencimiento(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Alerta de Producto Vencido!'),
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

  void showSialogEdicion(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Alerta de Edición No Permitida!'),
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
