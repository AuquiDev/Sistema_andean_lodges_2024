// ignore_for_file: unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/models/model_t_entradas.dart';
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/models/model_t_proveedor.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_entradas.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';
import 'package:ausangate_op/widgets/card_custom_formfield_shadow.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EntradasForm extends StatefulWidget {
  const EntradasForm({
    super.key,
    required this.producto,
    required this.listaEmpleados,
    required this.stockList,
    this.e,
    this.empleado,
    this.trabajo,
    required this.listaProveedor,
  });

  final TProductosAppModel producto;
  final List<TEmpleadoModel> listaEmpleados;
  final List<TProveedorModel> listaProveedor;
  final List<dynamic> stockList;
  final TEntradasModel? e;
  final String? empleado;
  final String? trabajo;

  @override
  State<EntradasForm> createState() => _EntradasFormState();
}

class _EntradasFormState extends State<EntradasForm> {
  final TextEditingController _idProductoController = TextEditingController();
  final TextEditingController _idEmpleadoController = TextEditingController();
  final TextEditingController _idProveedorController = TextEditingController();
  final TextEditingController _cantidadEntradasController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _costoTotalController = TextEditingController();
  final TextEditingController _fechaVencimientoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  

  final _formKey = GlobalKey<FormState>();

  String proveedor = '';
  String codigogrupo = '';

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
      _fechaVencimientoController.text = (widget.e!.fechaVencimientoEntrada).toString();

      title = 'Editar Registro';
      proveedor = widget.empleado!;
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
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 100,
            title: Column(
              children: [
                H2Text(
                  text:
                      '${widget.producto.nombreProducto} * ${widget.producto.marcaProducto} - ${widget.producto.unidMedida}',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const H2Text(
                  text: 'Entradas de producto',
                  fontSize: 10,
                  fontWeight: FontWeight.w200,
                ),
                const SizedBox(height: 10,),
                H2Text(
                  text: title.toUpperCase(),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.deepOrange,
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
                  //IDPRODUCTO 
                  //IDEMPLEADO 
                  CardCustomFom(
                    label: 'Proveedor : $proveedor',
                    child: TextFormField(
                      controller: _idProveedorController,
                      readOnly: true, // Deshabilita la edición directa del texto
                      showCursor: true, // Muestra el cursor al tocar el campo
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'Id Proveedor',
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
                            constraints: BoxConstraints.loose(Size.fromHeight(
                                MediaQuery.of(context).size.height * .75)),
                            scrollControlDisabledMaxHeightRatio:
                                BorderSide.strokeAlignOutside,
                            useSafeArea: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        itemCount: widget.listaProveedor.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(
                                          thickness: 0,
                                          height: 0,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final e =
                                              widget.listaProveedor[index];
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
                                                  '${e.nombreEmpresaProveedor} ${e.ciudadProveedor}',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                            subtitle: H2Text(
                                              text: e.categoriaProvision,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w200,
                                            ),
                                            onTap: () {
                                              _idProveedorController.text = e.id!;
                                              setState(() {
                                                proveedor =
                                                    '${e.nombreEmpresaProveedor} ~*~ ${e.ciudadProveedor}\n${e.categoriaProvision}';
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

                  CardCustomFom(
                    label: 'Cantidad de Entrada',
                    child: TextFormField(
                      controller: _cantidadEntradasController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText:
                              '...(${widget.producto.unidMedida})',
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

                  CardCustomFom(
                    label: 'Precio de Entrada',
                    child: TextFormField(
                      controller: _precioController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText:
                              '...(S/. ${widget.producto.precioUnd})',
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
                   CardCustomFom(
                    label: 'Fecha de vencimiento.',
                    child: TextFormField(
                      // enabled: false,
                      readOnly:
                          true, // Deshabilita la edición directa del texto
                      showCursor: true, // Muestra el cursor al tocar el campo
                      controller: _fechaVencimientoController,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'Fecha Vencimiento',
                          prefixIcon: const Icon(Icons.calendar_month_outlined,
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
                  CardCustomFom(
                    label:
                        'Descripción:\n(Restricciones, Detalles de uso, Recomendaciones, observaciones, etc.)',
                    child: TextFormField(
                      controller: _descripcionController,
                      maxLength: 250,
                      maxLines: 4,
                      decoration: decorationTextField(
                          hintText: 'opcional',
                          labelText: 'Descripción de entrada',
                          prefixIcon: const Icon(Icons.panorama_fisheye,
                              color: Colors.black45)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.deepOrange)),
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
                      child: SizedBox(
                          height: 60,
                          child: Center(
                              child: salidasLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const H2Text(
                                      text: 'Guardar',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ))),
                    ),
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
        content:
            H2Text(text: '🚨 Por favor, completa todos los campos obligatorios.',
            maxLines: 3,
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,),
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
                  id: widget.e!.id,//IDENTRADA 
                  idProducto: _idProductoController.text,
                  idEmpleado: idusuario,//_idEmpleadoController.text, //Usuario que inicio sesion
                  idProveedor: _idProveedorController.text,
                  cantidadEntrada: convertirTextoADouble(_cantidadEntradasController.text),
                  precioEntrada: convertirTextoADouble(_precioController.text),
                  costoTotal: (convertirTextoADouble(_cantidadEntradasController.text) * convertirTextoADouble(_precioController.text)) ,
                  descripcionEntrada: _descripcionController.text,
                  fechaVencimientoENtrada:DateTime.parse( _fechaVencimientoController.text)
                );
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
            var cantidad = convertirTextoADouble(_cantidadEntradasController.text);
            var precio = convertirTextoADouble(_precioController.text);
          _costoTotalController.text = (cantidad * precio).toString();

           await context.read<TEntradasAppProvider>().postEntradasProvider(
                  id: '',
                  idProducto: _idProductoController.text,
                  idEmpleado: idusuario,//_idEmpleadoController.text, //Usuario que inicio sesion
                  idProveedor: _idProveedorController.text,
                  cantidadEntrada: convertirTextoADouble(_cantidadEntradasController.text),
                  precioEntrada: convertirTextoADouble(_precioController.text),
                  costoTotal: convertirTextoADouble(_costoTotalController.text),
                  descripcionEntrada: _descripcionController.text,
                  fechaVencimientoENtrada:DateTime.parse( _fechaVencimientoController.text)
                );
          snackBarButon('✅ Registro guardado correctamente.');
          _clearn();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
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
