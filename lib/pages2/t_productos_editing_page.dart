// ignore_for_file: unused_field, avoid_print, must_be_immutable

import 'dart:async';

import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/models/model_t_ubicacion_almacen.dart';
import 'package:ausangate_op/provider/provider_t_categoria_almacen.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/provider/provider_t_proveedorapp.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/parse_bool.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:ausangate_op/widgets/card_custom_formfield_shadow.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:provider/provider.dart';

class EditPageProductosApp extends StatefulWidget {
  const EditPageProductosApp({
    super.key,
    this.e,
  });
  final TProductosAppModel? e;
  @override
  State<EditPageProductosApp> createState() => _EditPageProductosAppState();
}

class _EditPageProductosAppState extends State<EditPageProductosApp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idUbicacionController = TextEditingController();
  final TextEditingController _idProveedorController = TextEditingController();
  final TextEditingController _idCategoriaController = TextEditingController();
  final TextEditingController _nombreProductoController =
      TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _unDeMedController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _undMedidaSalidaController =
      TextEditingController();
  final TextEditingController _precioUndSalidaController =
      TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _fechaVencimientoController =
      TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();

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
  void dispose() {
    // Restaurar las preferencias de orientación cuando la página se destruye
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  List<DateTime?> _selectedDates = [];
  var title = 'Crear nuevo';
  bool valueEstadoProducto = true; //SwithAdaptative check
  @override
  void initState() {
    if (widget.e != null) {
      _idUbicacionController.text = widget.e!.idUbicacion;
      _idProveedorController.text = widget.e!.idProveedor;
      _idCategoriaController.text = widget.e!.idCategoria;
      _nombreProductoController.text = widget.e!.nombreProducto;
      _marcaController.text = widget.e!.marcaProducto;
      _unDeMedController.text = widget.e!.unidMedida;
      _precioController.text = widget.e!.precioUnd.toString();
      _undMedidaSalidaController.text = widget.e!.unidMedidaSalida;
      _precioUndSalidaController.text =
          widget.e!.precioUnidadSalidaGrupo.toString();
      _descripcionController.text = widget.e!.descripcionUbicDetll;
      _tipoController.text = widget.e!.tipoProducto;
      _fechaVencimientoController.text = widget.e!.fechaVencimiento.toString();
      _estadoController.text = widget.e!.estado.toString();
      // _imagenController.text = widget.e!.imagen;
      title = 'Editar Registro';
    } else {
      _estadoController.text = valueEstadoProducto.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSavingSerer = Provider.of<TProductosAppProvider>(context).isSyncing;
    // bool isavingProvider = isOffline ? isSavinSQL : isSavingSerer;
    bool isavingProvider = isSavingSerer;

    //Se USA en el Boton Guardar

    return GestureDetector(
      onTap: () {
        // Cierra el teclado cuando tocas en cualquier lugar de la pantalla
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.white,
          title: H2Text(
            text: title,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ScrollWeb(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: Column(
                      children: [
                        TextFieldIdUbiacion(
                          idUbicacionController: _idUbicacionController,
                        ),
                        TextFiledIdCategoria(
                            idCategoriaController: _idCategoriaController),
                        TextFieldIdProveedor(
                            idProveedorController: _idProveedorController),
                        CardCustomFom(
                          label: 'Nombre del producto.',
                          child: TextFormField(
                            controller: _nombreProductoController,
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Producto',
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
                          label: 'Marca del producto.',
                          child: TextFormField(
                            controller: _marcaController,
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Marca',
                                prefixIcon: const Icon(Icons.panorama_fisheye,
                                    color: Colors.black45)),
                            validator: (value) {
                              return null;

                              // if (value!.isEmpty) {
                              //   return 'Campo obligatorio';
                              // } else {
                              //   return null;
                              // }
                            },
                          ),
                        ),
                        TextFieldTipoProducto(tipoController: _tipoController),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: H2Text(
                              text:
                                  'Cuando un producto ingresa al inventario, se registra con un precio de compra y una unidad de medida específica. Al salir del inventario, el producto se distribuye con un precio de distribución distinto y en unidades más pequeñas, ajustándose a las necesidades operativas. Por favor, proporcione esa información en los campos correspondientes.',
                              fontSize: 10,
                              maxLines: 4,
                              textAlign: TextAlign.justify,
                              fontWeight: FontWeight.w300),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 8),
                              child: H2Text(
                                  text: 'Detalles de Entrada'.toUpperCase(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: CardCustomFom(
                                    label: 'Unidad medida de Entrada.',
                                    child: TextFormField(
                                      controller: _unDeMedController,
                                      decoration: decorationTextField(
                                          hintText: 'campo obligatorio',
                                          labelText: 'Unidad medida',
                                          prefixIcon: const Icon(
                                              Icons.panorama_fisheye,
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
                                const VerticalDivider(),
                                Flexible(
                                  flex: 1,
                                  child: CardCustomFom(
                                    label: 'Precio Entrada (compra)',
                                    child: TextFormField(
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      controller: _precioController,
                                      decoration: decorationTextField(
                                          hintText: 'campo obligatorio',
                                          labelText: 'S/. Precio',
                                          prefixIcon: const Icon(Icons.numbers,
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
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 0),
                              child: H2Text(
                                  text: 'Detalles de Salida'.toUpperCase(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: CardCustomFom(
                                    label: 'Unidad medida de Salida.',
                                    child: TextFormField(
                                      controller: _undMedidaSalidaController,
                                      decoration: decorationTextField(
                                          hintText: 'campo obligatorio',
                                          labelText: 'Unidad medida',
                                          prefixIcon: const Icon(
                                              Icons.panorama_fisheye,
                                              color: Colors.black45)),
                                      validator: (value) {
                                        return null;

                                        // if (value!.isEmpty) {
                                        //   return 'Campo obligatorio';
                                        // } else {
                                        //   return null;
                                        // }
                                      },
                                    ),
                                  ),
                                ),
                                const VerticalDivider(),
                                Flexible(
                                  flex: 1,
                                  child: CardCustomFom(
                                    label: 'Precio Salida',
                                    child: TextFormField(
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      controller: _precioUndSalidaController,
                                      decoration: decorationTextField(
                                          hintText: 'campo obligatorio',
                                          labelText: 'S/. Precio',
                                          prefixIcon: const Icon(Icons.numbers,
                                              color: Colors.black45)),
                                      validator: (value) {
                                        return null;

                                        // if (value!.isEmpty) {
                                        //   return 'Campo obligatorio';
                                        // } else {
                                        //   return null;
                                        // }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        CardCustomFom(
                          label: 'Fecha de vencimiento.',
                          child: TextFormField(
                            // enabled: false,
                            readOnly:
                                true, // Deshabilita la edición directa del texto
                            showCursor:
                                true, // Muestra el cursor al tocar el campo
                            controller: _fechaVencimientoController,
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Fecha Vencimiento',
                                prefixIcon: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.black45)),
                            onTap: () {
                              _pickDate(context);
                              print(_fechaVencimientoController.text);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo obligatorio';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              _pickDate(context);
                              print(value);
                            },
                          ),
                        ),
                        CardCustomFom(
                          label:
                              '(uso, preparación, observaciones,recomendaciones, otros...).',
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.top,
                            maxLength: 250,
                            maxLines: 4,
                            controller: _descripcionController,
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Descripción',
                                prefixIcon: const Icon(Icons.panorama_fisheye,
                                    color: Colors.black45)),
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const H2Text(
                                  text: 'Mostrar, Ocultar producto.',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                              Switch.adaptive(
                                value: parseBool(_estadoController.text),
                                onChanged: (value) {
                                  setState(() {
                                    _estadoController.text = value.toString();
                                  });
                                  print(_estadoController.text);
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50.0),
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xFF697BE1))),
                            onPressed: isavingProvider
                                ? null
                                : () async {
                                    print('push buton');
                                    if (_formKey.currentState!.validate()) {
                                      if (widget.e != null) {
                                        editarDatos();
                                        refreshListData();
                                        _formKey.currentState!.save();
                                      } else {
                                        enviarDatos();
                                        refreshListData();
                                        _formKey.currentState!.save();
                                      }
                                    } else {
                                      // Mostrar un SnackBar indicando el primer campo con error
                                      completeForm();
                                    }
                                    //Actualizar al Tabla 
                                     
                                  },
                            child: SizedBox(
                                height: 60,
                                child: Center(
                                    child: isavingProvider
                                        ? const CircularProgressIndicator()
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

  void refreshListData() async {
    final dataProvider =
        Provider.of<TProductosAppProvider>(context, listen: false);
    await dataProvider.actualizarDatosDesdeServidor();
  }

  Future<void> editarDatos() async {
    await context.read<TProductosAppProvider>().updateProductosProvider(
          id: widget.e!.id,
          idCategoria: _idCategoriaController.text,
          idUbicacion: _idUbicacionController.text,
          idProveedor: _idProveedorController.text,
          // imagen: imagen,
          nombreProducto: _nombreProductoController.text,
          marcaProducto: _marcaController.text,
          unidMedida: _unDeMedController.text,
          precioUnd: convertirTextoADouble(_precioController.text),
          unidMedidaSalida: _undMedidaSalidaController.text,
          precioUnidadSalidaGrupo: _precioUndSalidaController.text.isNotEmpty
              ? convertirTextoADouble(_precioUndSalidaController.text)
              : (0.0),
          descripcionUbicDetll: _descripcionController.text,
          tipoProducto: _tipoController.text,
          fechaVencimiento: DateTime.parse(_fechaVencimientoController.text),
          estado: parseBool(_estadoController.text), //_estadoController.text
          // documentUsoPreparacionReceta: documentUsoPreparacionReceta
        );
    print('NOMBRE: ${_nombreProductoController.text}');
    print(
        'Fecha: ${formatFecha(DateTime.parse(_fechaVencimientoController.text))}');
    snackBarButon('✅ Registro editado correctamente.');
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> enviarDatos() async {
    await context.read<TProductosAppProvider>().postProductosProvider(
          //  id: id,
          idCategoria: _idCategoriaController.text,
          idUbicacion: _idUbicacionController.text,
          idProveedor: _idProveedorController.text,
          // imagen: imagen,
          nombreProducto: _nombreProductoController.text,
          marcaProducto: _marcaController.text,
          unidMedida: _unDeMedController.text,
          precioUnd: convertirTextoADouble(_precioController.text),
          unidMedidaSalida: _undMedidaSalidaController.text,
          precioUnidadSalidaGrupo: _precioUndSalidaController.text.isNotEmpty
              ? convertirTextoADouble(_precioUndSalidaController.text)
              : (0.0),
          descripcionUbicDetll: _descripcionController.text,
          tipoProducto: _tipoController.text,
          fechaVencimiento: DateTime.parse(_fechaVencimientoController.text),
          estado: parseBool(_estadoController.text), //
          // documentUsoPreparacionReceta: documentUsoPreparacionReceta
        );
    print('ESTADO: ${_estadoController.text}');
    snackBarButon('✅ Se ha añadido un nuevo registro.');
    _cleanAll();
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

  void _cleanAll() {
    _idCategoriaController.clear();
    _idUbicacionController.clear();
    _idProveedorController.clear();
    _nombreProductoController.clear();
    _marcaController.clear();
    _unDeMedController.clear();
    _precioController.clear();
    _undMedidaSalidaController.clear();
    _precioUndSalidaController.clear();
    _descripcionController.clear();
    _tipoController.clear();
    _fechaVencimientoController.clear();
    // _estadoController.clear();
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
        print('posicion 01 ${pickedDates[0]}');
        print('TextController ${_fechaVencimientoController.text}');
      });
    }
  }
}

class TextFieldTipoProducto extends StatelessWidget {
  const TextFieldTipoProducto({
    super.key,
    required TextEditingController tipoController,
  }) : _tipoController = tipoController;

  final TextEditingController _tipoController;

  @override
  Widget build(BuildContext context) {
    List<String> tipo = ['perecible', 'no perecible'];
    return CardCustomFom(
      label: 'Tipo de producto.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _tipoController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'Tipo',
            prefixIcon:
                const Icon(Icons.panorama_fisheye, color: Colors.black45)),
        validator: (value) {
          return null;
        },
        onTap: () {
          showModalBottomSheet(
              constraints: BoxConstraints.loose(
                  Size.fromHeight(MediaQuery.of(context).size.height * .25)),
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
                          text: 'Seleccione el tipo de Producto',
                          fontWeight: FontWeight.w200,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: tipo.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            thickness: 0,
                            height: 0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final e = tipo[index];
                            return ListTile(
                              dense: false,
                              visualDensity: VisualDensity.compact,
                              leading: const Icon(
                                Icons.airport_shuttle_sharp,
                                color: Colors.red,
                                size: 15,
                              ),
                              title: H2Text(
                                text: e,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              onTap: () {
                                _tipoController.text = e;
                                print(_tipoController.text);
                                print('Before $e');
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
    );
  }
}

class TextFieldIdProveedor extends StatelessWidget {
  TextFieldIdProveedor({
    super.key,
    required TextEditingController idProveedorController,
  }) : _idProveedorController = idProveedorController;

  final TextEditingController _idProveedorController;
  String proveedor = 'date';
  @override
  Widget build(BuildContext context) {
    final listaProveedor = Provider.of<TProveedorProvider>(context)
        .listaProveedor
      ..sort((a, b) =>
          a.nombreEmpresaProveedor.compareTo(b.nombreEmpresaProveedor));
    return CardCustomFom(
      label: 'ID de Proveedor del producto.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _idProveedorController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'ID Proveedor',
            prefixIcon:
                const Icon(Icons.airport_shuttle_sharp, color: Colors.black45)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo obligatorio';
          } else {
            return null;
          }
        },
        onTap: () {
          showModalBottomSheet(
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
                          text: 'Seleccione un Proveedor',
                          fontWeight: FontWeight.w200,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: listaProveedor.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            thickness: 0,
                            height: 0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final e = listaProveedor[index];
                            return ListTile(
                              dense: false,
                              visualDensity: VisualDensity.compact,
                              leading: const Icon(
                                Icons.airport_shuttle_sharp,
                                color: Colors.red,
                                size: 15,
                              ),
                              title: H2Text(
                                text: e.nombreEmpresaProveedor,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              onTap: () {
                                _idProveedorController.text = e.id!;
                                proveedor = e.nombreEmpresaProveedor;
                                print('After $proveedor');
                                print(_idProveedorController.text);
                                print('Before $proveedor');
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
    );
  }
}

class TextFiledIdCategoria extends StatelessWidget {
  const TextFiledIdCategoria({
    super.key,
    required TextEditingController idCategoriaController,
  }) : _idCategoriaController = idCategoriaController;

  final TextEditingController _idCategoriaController;
  @override
  Widget build(BuildContext context) {
    final listaCategoria = Provider.of<TCategoriaProvider>(context).listcategory
      ..sort((a, b) => a.categoria.compareTo(b.categoria));
    return CardCustomFom(
      label: 'ID de categoría del producto.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _idCategoriaController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'ID Categoría',
            prefixIcon: const Icon(Icons.category, color: Colors.black45)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo obligatorio';
          } else {
            return null;
          }
        },
        onTap: () {
          showModalBottomSheet(
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
                          text: 'Seleccione una categoría de producto',
                          fontWeight: FontWeight.w200,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: listaCategoria.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            thickness: 0,
                            height: 0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final e = listaCategoria[index];
                            return ListTile(
                              dense: false,
                              visualDensity: VisualDensity.compact,
                              leading: const Icon(
                                Icons.category,
                                color: Colors.red,
                                size: 15,
                              ),
                              title: H2Text(
                                text: e.categoria,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              onTap: () {
                                _idCategoriaController.text = e.id!;
                                print(_idCategoriaController.text);
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
    );
  }
}

class TextFieldIdUbiacion extends StatelessWidget {
  const TextFieldIdUbiacion({
    super.key,
    required TextEditingController idUbicacionController,
  }) : _idUbicacionController = idUbicacionController;

  final TextEditingController _idUbicacionController;
  @override
  Widget build(BuildContext context) {
    final listaUbicacion = Provider.of<TUbicacionAlmacenProvider>(context)
        .listUbicacion
      ..sort((a, b) => a.nombreUbicacion.compareTo(b.nombreUbicacion));
    return CardCustomFom(
      label: 'ID de ubicación de almacenamiento del producto.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _idUbicacionController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'ID Ubicación',
            prefixIcon:
                const Icon(Icons.fmd_good_sharp, color: Colors.black45)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo obligatorio';
          } else {
            return null;
          }
        },
        onTap: () {
          _showModalUbicacion(context, listaUbicacion, _idUbicacionController);
        },
      ),
    );
  }

  Future<dynamic> _showModalUbicacion(
      BuildContext context,
      List<TUbicacionAlmacenModel> listaUbicacion,
      TextEditingController idUbicacionController) {
    return showModalBottomSheet(
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
                    text: 'Seleccione una ubicación de almacenamiento',
                    fontWeight: FontWeight.w200,
                    fontSize: 13,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: listaUbicacion.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      thickness: 0,
                      height: 0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final e = listaUbicacion[index];
                      return ListTile(
                        dense: false,
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 15,
                        ),
                        title: H2Text(
                          text: e.nombreUbicacion,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                        onTap: () {
                          idUbicacionController.text = e.id!;
                          print(idUbicacionController);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
