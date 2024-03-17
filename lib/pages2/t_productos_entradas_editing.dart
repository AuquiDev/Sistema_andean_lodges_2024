// ignore_for_file: unnecessary_null_comparison, avoid_print
import 'package:ausangate_op/models/model_t_entradas.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_entradas.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EntradasForm extends StatefulWidget {
  const EntradasForm({
    super.key,
    required this.producto,
    this.e,
  });

  final TProductosAppModel producto;

  final TEntradasModel? e;

  @override
  State<EntradasForm> createState() => _EntradasFormState();
}

class _EntradasFormState extends State<EntradasForm> {
  final TextEditingController _idProductoController = TextEditingController();
  final TextEditingController _idEmpleadoController = TextEditingController();
  final TextEditingController _idProveedorController = TextEditingController();
  final TextEditingController _cantidadEntradasController =
      TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _costoTotalController = TextEditingController();
  final TextEditingController _fechaVencimientoController =
      TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var title = 'Crear nueva Entrada';

  @override
  void initState() {
    if (widget.e != null) {
      _idProductoController.text = widget.e!.idProducto;
      _idEmpleadoController.text = widget.e!.idEmpleado;
      _idProveedorController.text = widget.e!.idProveedor;
      _cantidadEntradasController.text = (widget.e!.cantidadEntrada).toString();
      _precioController.text = (widget.e!.precioEntrada).toString();
      _costoTotalController.text = (widget.e!.costoTotal).toString();
      _descripcionController.text = widget.e!.descripcionEntrada;
      _costoTotalController.text = (widget.e!.costoTotal).toString();
      _fechaVencimientoController.text =
          (widget.e!.fechaVencimientoEntrada).toString();

      title = 'Editar Registro';
    } else {
      print('Crear nuevo');
    }
    super.initState();
  }

  List<DateTime?> _selectedDates = [];
  @override
  Widget build(BuildContext context) {
    final salidasLoading = Provider.of<TEntradasAppProvider>(context).isSyncing;
    return GestureDetector(
      onTap: () {
        // FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                //IDPRODUCTO
                //IDEMPLEADO
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 0),
                  child: H2Text(
                      text: 'Nueva Entrada'.toUpperCase(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _cantidadEntradasController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: decorationTextField(
                            hintText: 'Cantidad entrada',
                            labelText: 'Cantidad entrada'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obligatorio';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _precioController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: decorationTextField(
                          hintText: 'Precio',
                          labelText: 'Precio',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obligatorio';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: TextFormField(
                        // enabled: false,
                        readOnly:
                            true, // Deshabilita la edición directa del texto
                        showCursor: true, // Muestra el cursor al tocar el campo
                        controller: _fechaVencimientoController,
                        decoration: decorationTextField(
                            hintText: 'Fecha Vencimiento',
                            labelText: 'Fecha Vencimiento',
                            prefixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.black45)),
                        onTap: () {
                          _pickDate(context);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obligatorio';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: _descripcionController,
                        maxLength: 250,
                        maxLines: 1,
                        decoration: decorationTextField(
                          hintText: 'opcional',
                          labelText: 'Descripción de entrada',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: salidasLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                if (widget.e != null) {
                                  editarEntrada();
                                  _formKey.currentState!.save();
                                } else {
                                  guardarEntrada();
                                  _formKey.currentState!.save();
                                }
                              } else {
                                // Mostrar un SnackBar indicando el primer campo con error
                                completeForm();
                              }
                            },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
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

  Future<void> editarEntrada() async {
    // Verificar si el registro fue creado hace menos de dos días
    final diferenceDias = DateTime.now().difference(widget.e!.created!).inDays;
    // var idusuario = context.read<UsuarioProvider>().idUsuario;
    var idusuario = context.read<UsuarioProvider>().usuarioEncontrado!.id;
    if (diferenceDias <= 2) {
      _idProductoController.text = widget.producto.id;
      await context.read<TEntradasAppProvider>().updateEntradasProvider(
          id: widget.e!.id, //IDENTRADA
          idProducto: _idProductoController.text,
          idEmpleado:
              idusuario, //_idEmpleadoController.text, //Usuario que inicio sesion
          idProveedor: _idProveedorController.text,
          cantidadEntrada:
              convertirTextoADouble(_cantidadEntradasController.text),
          precioEntrada: convertirTextoADouble(_precioController.text),
          costoTotal: (convertirTextoADouble(_cantidadEntradasController.text) *
              convertirTextoADouble(_precioController.text)),
          descripcionEntrada: _descripcionController.text,
          fechaVencimientoENtrada:
              DateTime.parse(_fechaVencimientoController.text));
      snackBarButon('✅ Registro editado correctamente.');
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      showSialogEdicion(
          'El plazo máximo para editar es de dos días después de la creación.');
    }
  }

  Future<void> guardarEntrada() async {
    //REEMPLAZAR MAS ADELANTE
    //  var idusuario = context.read<UsuarioProvider>().idUsuario;
    var idusuario = context.read<UsuarioProvider>().usuarioEncontrado!.id;
    _idProductoController.text = widget.producto.id;
    _idProveedorController.text = widget.producto.idProveedor;
    var cantidad = convertirTextoADouble(_cantidadEntradasController.text);
    var precio = convertirTextoADouble(_precioController.text);
    _costoTotalController.text = (cantidad * precio).toString();

    await context.read<TEntradasAppProvider>().postEntradasProvider(
        id: '',
        idProducto: _idProductoController.text,
        idEmpleado:
            idusuario, //_idEmpleadoController.text, //Usuario que inicio sesion
        idProveedor: _idProveedorController.text,
        cantidadEntrada:
            convertirTextoADouble(_cantidadEntradasController.text),
        precioEntrada: convertirTextoADouble(_precioController.text),
        costoTotal: convertirTextoADouble(_costoTotalController.text),
        descripcionEntrada: _descripcionController.text,
        fechaVencimientoENtrada:
            DateTime.parse(_fechaVencimientoController.text));
    snackBarButon('✅ Registro guardado correctamente.');
    _clearn();
    // ignore: use_build_context_synchronously
    // Navigator.pop(context);
  }

  void _clearn() {
    _idProductoController.clear();
    _idEmpleadoController.clear();
    _idProveedorController.clear();
    _cantidadEntradasController.clear();
    _precioController.clear();
    _costoTotalController.clear();
    _descripcionController.clear();
    _fechaVencimientoController.clear();
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

  Future<void> _pickDate(BuildContext context) async {
    final List<DateTime?>? pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.single),
      dialogSize: const Size(375, 400),
      value: _selectedDates,
    );

    if (pickedDates != null && pickedDates.isNotEmpty) {
      setState(() {
        _selectedDates = pickedDates;
        _fechaVencimientoController.text =
            pickedDates[0].toString(); //_formatDate(pickedDates[0]);
      });
    }
  }
}
