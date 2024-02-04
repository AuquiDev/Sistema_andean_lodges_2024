// ignore_for_file: avoid_print

import 'dart:async';

import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/provider/provider_empleados.rol_sueldo.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/utils/parse_bool.dart';
import 'package:ausangate_op/widgets/card_custom_formfield_shadow.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:provider/provider.dart';


class EmpleadosFormEditing extends StatefulWidget {
  const EmpleadosFormEditing({
    super.key,
    this.e,
    this.rolPuesto,
  });
  final TEmpleadoModel? e;
  final String? rolPuesto;
  @override
  State<EmpleadosFormEditing> createState() => _EmpleadosFormEditingState();
}

class _EmpleadosFormEditingState extends State<EmpleadosFormEditing> {
  final _formKey = GlobalKey<FormState>();
  //FORM INDEX se desplace automáticamente hasta el primer campo no llenado cuando se presiona el botón
  // final _scrollIndexForm = AutoScrollController();

  final TextEditingController _idEmpleadoController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _idRolesSueldoEmpleadosController =
      TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _direccionResidenciaController =
      TextEditingController();
  final TextEditingController _lugarNacimientoController =
      TextEditingController();
  final TextEditingController _fechaacimientoController =
      TextEditingController();
  final TextEditingController _correoElectronicoController =
      TextEditingController();

  final TextEditingController _nivelescolaridadController = TextEditingController();
  final TextEditingController _estadoCivilController = TextEditingController();

  final TextEditingController _modalidadLaboralController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();

  final TextEditingController _cuentaBancariaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

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
  var title = 'Crear nuevo empleado';
  bool valueEstadoProducto = true; //SwithAdaptative check
  bool isVisible = true; //contraseña
  String rolPuesto = '';
  @override
  void initState() {
    if (widget.e != null) {
      _idEmpleadoController.text = widget.e!.id!;
      _estadoController.text = widget.e!.estado.toString();
      _idRolesSueldoEmpleadosController.text = widget.e!.idRolesSueldoEmpleados;
      _nombreController.text = widget.e!.nombre;
      _apellidoPaternoController.text = widget.e!.apellidoPaterno;
      _apellidoMaternoController.text = widget.e!.apellidoMaterno;
      _sexoController.text = widget.e!.sexo;
      _direccionResidenciaController.text = widget.e!.direccionResidencia;
      _lugarNacimientoController.text = widget.e!.lugarNacimiento;
      _fechaacimientoController.text = widget.e!.fechaNacimiento.toString();
      _correoElectronicoController.text = widget.e!.correoElectronico;
      _nivelescolaridadController.text = widget.e!.nivelEscolaridad;
      _estadoCivilController.text = widget.e!.estadoCivil;
      _modalidadLaboralController.text = widget.e!.modalidadLaboral;
      _cedulaController.text = widget.e!.cedula.toString();
      _cuentaBancariaController.text = widget.e!.cuentaBancaria;
      _telefonoController.text = widget.e!.telefono;
      _contrasenaController.text = widget.e!.contrasena;
      _roleController.text = widget.e!.rol.toString();
      title = 'Editar Registro';
      rolPuesto = widget.rolPuesto!;
    } else {
      _estadoController.text = valueEstadoProducto.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerEmpleados =
        Provider.of<TEmpleadoProvider>(context); //Cargar para gurdar
    final listaRolesSueldo = Provider.of<TRolesSueldoProvider>(context)
        .listRolesSueldo
      ..sort((a, b) => a.cargoPuesto.compareTo(b.cargoPuesto));
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
          title: H2Text(text: title),
        ),
        body: SingleChildScrollView(
          // controller: _scrollIndexForm,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        H2Text(
                            text: parseBool(_estadoController.text)
                                ? 'Activo'
                                : 'Inactivo',
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
                  //FALTA CREAR PROVIDER
                  CardCustomFom(
                    label: 'Seleccione ID Puesto : $rolPuesto ',
                    child: TextFormField(
                      readOnly:
                          true, // Deshabilita la edición directa del texto
                      showCursor: true, // Muestra el cursor al tocar el campo
                      controller: _idRolesSueldoEmpleadosController,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'ID puesto',
                          prefixIcon: const Icon(Icons.panorama_fish_eye,
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
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const DividerCustom(),
                                    Expanded(
                                      child: ListView.separated(
                                        itemCount: listaRolesSueldo.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(
                                          thickness: 0,
                                          height: 0,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final e = listaRolesSueldo[index];
                                          return ListTile(
                                            dense: false,
                                            visualDensity:
                                                VisualDensity.compact,
                                            leading: const Icon(
                                              Icons.category,
                                              color: Colors.red,
                                              size: 15,
                                            ),
                                            title: H2Text(
                                              text: e.cargoPuesto,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                            subtitle: Row(
                                              children: [
                                                H2Text(
                                                  text:
                                                      "${e.sueldoBase} . ${e.tipoMoneda} /${e.tipoCalculoSueldo}",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              _idRolesSueldoEmpleadosController
                                                  .text = e.id!;
                                              setState(() {
                                                rolPuesto = e.cargoPuesto;
                                              });
                                              print(
                                                  _idRolesSueldoEmpleadosController
                                                      .text);
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
                    label: 'Ingrese Nombre empleado',
                    child: TextFormField(
                      controller: _nombreController,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'Nombre',
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
                    label: 'Ingrese Apellido Paterno.',
                    child: TextFormField(
                      controller: _apellidoPaternoController,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'apellido paterno',
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
                    label: 'Ingrese Apellido Materno.',
                    child: TextFormField(
                      controller: _apellidoMaternoController,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'apellido materno',
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
                  TextFieldSexo(sexoController: _sexoController),
                  CardCustomFom(
                    label: 'Ingrese dirección de Residencia.',
                    child: TextFormField(
                      controller: _direccionResidenciaController,
                      decoration: decorationTextField(
                          hintText: 'campo opcional',
                          labelText: 'dirección de Residencia.',
                          prefixIcon: const Icon(Icons.panorama_fisheye,
                              color: Colors.black45)),
                    ),
                  ),
                  CardCustomFom(
                    label: 'Ingrese Lugar de nacimiento.',
                    child: TextFormField(
                      controller: _lugarNacimientoController,
                      decoration: decorationTextField(
                          hintText: 'campo opcional',
                          labelText: 'Lugar de nacimiento',
                          prefixIcon: const Icon(Icons.panorama_fisheye,
                              color: Colors.black45)),
                    ),
                  ),
                  CardCustomFom(
                    label: 'Fecha de Nacimiento.',
                    child: TextFormField(
                      // enabled: false,
                      readOnly:
                          true, // Deshabilita la edición directa del texto
                      showCursor: true, // Muestra el cursor al tocar el campo
                      controller: _fechaacimientoController,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'Fecha Nacimiento',
                          prefixIcon: const Icon(Icons.calendar_month_outlined,
                              color: Colors.black45)),
                      onTap: () {
                        _pickDate(context);
                        print(_fechaacimientoController.text);
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
                    label: 'Ingrese Correo Electrónico',
                    child: TextFormField(
                      controller: _correoElectronicoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: decorationTextField(
                          hintText: 'correo@example.com',
                          labelText: 'Correo Electrónico',
                          prefixIcon: const Icon(Icons.panorama_fisheye,
                              color: Colors.black45)),
                      validator: (value) {
                        // Validación simple para verificar si es un correo electrónico válido
                        if (value == null || value.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                            .hasMatch(value)) {
                          return 'Ingrese un correo electrónico válido';
                        }
                        return null; // La validación pasa
                      },
                    ),
                  ),

                  CardCustomFom(
                    label: 'Ingrese su número de Cédula: ',
                    child: TextFormField(
                      controller: _cedulaController,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      inputFormatters: [
                        //Expresion Regular
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'DNI ',
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.black45)),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        if (value!.length < 8) {
                          return 'Ingrese 8 digitos';
                        }
                        return null;
                      },
                    ),
                  ),

                  CardCustomFom(
                    label: 'Ingrese su Contraseña',
                    child: TextFormField(
                      controller: _contrasenaController,
                      obscureText: isVisible,
                      // maxLength: 6,
                      keyboardType: TextInputType.visiblePassword,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')), // Denegar espacios
                      ],
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'contraseña',
                          prefixIcon: IconButton(
                              onPressed: () {
                                isVisible = !isVisible;
                                setState(() {});
                              },
                              icon: Icon(
                                isVisible != true
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 18,
                              ))),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        if (value!.length < 6) {
                          return 'Ingrese más de 6 caracteres';
                        }
                        if (value.contains(' ')) {
                          return 'La contraseña no puede contener espacios';
                        }
                        return null;
                      },
                    ),
                  ),
                  CardCustomFom(
                    label: 'Ingrese Cuenta Bancaria.',
                    child: TextFormField(
                      controller: _cuentaBancariaController,
                      decoration: decorationTextField(
                          hintText: 'campo opcional',
                          labelText: 'nro. cuenta',
                          prefixIcon: const Icon(Icons.badge_outlined,
                              color: Colors.black45)),
                    ),
                  ),
                  CardCustomFom(
                    label: 'Ingrese nro. Teléfono.',
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        //Expresion Regular
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                      controller: _cuentaBancariaController,
                      decoration: decorationTextField(
                          hintText: 'campo opcional',
                          labelText: 'nro. Teléfono',
                          prefixIcon:
                              const Icon(Icons.phone, color: Colors.black45)),
                    ),
                  ),
                  TextFieldRol(roleController: _roleController),
                  TextFieldNivelEscolaridad(
                    nivelescolaridadController: _nivelescolaridadController,
                  ),
                  TextFieldEstadoCivil(
                      estadoCivilController: _estadoCivilController),
                  TextFieldModalidadLaboral(
                      modalidadLaboralController: _modalidadLaboralController),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.deepOrange)),
                      onPressed: providerEmpleados.isSyncing
                          ? null
                          : () async {
                              print('push buton');
                              if (_formKey.currentState!.validate()) {
                                if (widget.e != null) {
                                  editarDatos();
                                  _formKey.currentState!.save();
                                } else {
                                  enviarDatos();
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
                              child: providerEmpleados.isSyncing
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
    );
  }
  
  Future<void> editarDatos() async {
    await context.read<TEmpleadoProvider>().updateEmpleadoProvider(
        id: widget.e!.id,
        estado: parseBool(_estadoController.text),
        idRolesSueldoEmpleados: _idRolesSueldoEmpleadosController.text,
        nombre: _nombreController.text,
        apellidoPaterno: _apellidoPaternoController.text,
        apellidoMaterno: _apellidoMaternoController.text,
        sexo: _sexoController.text,
        direccionResidencia: _direccionResidenciaController.text,
        lugarNacimiento: _lugarNacimientoController.text,
        fechaNacimiento: DateTime.parse(_fechaacimientoController.text),
        correoElectronico: _correoElectronicoController.text,
        nivelEscolaridad: _nivelescolaridadController.text,
        estadoCivil: _estadoCivilController.text,
        modalidadLaboral: _modalidadLaboralController.text,
        cedula: int.parse(_cedulaController.text),
        cuentaBancaria: _cuentaBancariaController.text,
        telefono: _telefonoController.text,
        contrasena: _contrasenaController.text,
        rol: _roleController.text);
    snackBarButon('✅ Registro editado correctamente.');
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> enviarDatos() async {
    await context.read<TEmpleadoProvider>().postEmpleadoProvider(
        //  id: id,
        estado: parseBool(_estadoController.text),
        idRolesSueldoEmpleados: _idRolesSueldoEmpleadosController.text,
        nombre: _nombreController.text,
        apellidoPaterno: _apellidoPaternoController.text,
        apellidoMaterno: _apellidoMaternoController.text,
        sexo: _sexoController.text,
        direccionResidencia: _direccionResidenciaController.text,
        lugarNacimiento: _lugarNacimientoController.text,
        fechaNacimiento: DateTime.parse(_fechaacimientoController.text),
        correoElectronico: _correoElectronicoController.text,
        nivelEscolaridad: _nivelescolaridadController.text,
        estadoCivil: _estadoCivilController.text,
        modalidadLaboral: _modalidadLaboralController.text,
        cedula: int.parse(_cedulaController.text),
        cuentaBancaria: _cuentaBancariaController.text,
        telefono: _telefonoController.text,
        contrasena: _contrasenaController.text,
        rol: _roleController.text);
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
    _estadoController.clear();
    _idRolesSueldoEmpleadosController.clear();
    _nombreController.clear();
    _apellidoPaternoController.clear();
    _apellidoMaternoController.clear();
    _sexoController.clear();
    _direccionResidenciaController.clear();
    _lugarNacimientoController.clear();
    _fechaacimientoController.clear();
    _correoElectronicoController.clear();
    _nivelescolaridadController.clear();
    _estadoCivilController.clear();
    _modalidadLaboralController.clear();
    _cedulaController.clear();
    _cuentaBancariaController.clear();
    _telefonoController.clear();
    _contrasenaController.clear();
    _roleController.clear();
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
        _fechaacimientoController.text =
            pickedDates[0].toString(); //_formatDate(pickedDates[0]);
        print('posicion 01 ${pickedDates[0]}');
        print('TextController ${_fechaacimientoController.text}');
      });
    }
  }

  //ENOMCTRAR ERROR DE FORMUALRIO Y REDIRIGIR AUTOMETICAMENTE
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
}

class TextFieldSexo extends StatelessWidget {
  const TextFieldSexo({
    super.key,
    required TextEditingController sexoController,
  }) : _sexoController = sexoController;

  final TextEditingController _sexoController;

  @override
  Widget build(BuildContext context) {
    List<String> tipo = ['Femenino', 'Masculino'];
    return CardCustomFom(
      label: 'Seleccione el Género de empleado.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _sexoController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'género',
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
                          text: 'Seleccione una opción',
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
                                _sexoController.text = e;
                                print(_sexoController.text);
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

class TextFieldRol extends StatelessWidget {
  const TextFieldRol({
    super.key,
    required TextEditingController roleController,
  }) : _roleController = roleController;

  final TextEditingController _roleController;

  @override
  Widget build(BuildContext context) {
    List<String> tipo = ['admin', 'user'];
    return CardCustomFom(
      label: 'Seleccione el Rol de usuario.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _roleController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'role de usurio',
            prefixIcon:
                const Icon(Icons.panorama_fisheye, color: Colors.black45)),
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
                          text: 'Seleccione una opción',
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
                                _roleController.text = e;
                                print(_roleController.text);
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

class TextFieldNivelEscolaridad extends StatelessWidget {
  const TextFieldNivelEscolaridad({
    super.key,
    required TextEditingController nivelescolaridadController,
  }) : _nivelescolaridadController = nivelescolaridadController;

  final TextEditingController _nivelescolaridadController;

  @override
  Widget build(BuildContext context) {
    List<String> tipo = [
      'ninguna',
      'Primaria',
      'Secundaria',
      'Técnico',
      'Bachiller',
      'Licenciatura',
      'Ingeniería',
      'Maestría',
      'Doctorado',
      'Otros'
    ];
    return CardCustomFom(
      label: 'Seleccione el Nivel Escolaridad.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _nivelescolaridadController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'nivel escolaridad',
            prefixIcon:
                const Icon(Icons.panorama_fisheye, color: Colors.black45)),
        validator: (value) {
          return null;
        },
        onTap: () {
          showModalBottomSheet(
              constraints: BoxConstraints.loose(
                  Size.fromHeight(MediaQuery.of(context).size.height * .8)),
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
                          text: 'Seleccione una opción',
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
                                Icons.assignment_ind,
                                color: Colors.red,
                                size: 15,
                              ),
                              title: H2Text(
                                text: e,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              onTap: () {
                                _nivelescolaridadController.text = e;
                                print(_nivelescolaridadController.text);
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

class TextFieldEstadoCivil extends StatelessWidget {
  const TextFieldEstadoCivil({
    super.key,
    required TextEditingController estadoCivilController,
  }) : _estadoCivilController = estadoCivilController;

  final TextEditingController _estadoCivilController;

  @override
  Widget build(BuildContext context) {
    List<String> tipo = [
      'Soltero(a)',
      'Casado(a)',
      'Divorciado(a)',
      'Viudo(a)',
      'Otro'
    ];
    return CardCustomFom(
      label: 'Seleccione el Estado civil.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _estadoCivilController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'estado civil',
            prefixIcon:
                const Icon(Icons.panorama_fisheye, color: Colors.black45)),
        validator: (value) {
          return null;
        },
        onTap: () {
          showModalBottomSheet(
              constraints: BoxConstraints.loose(
                  Size.fromHeight(MediaQuery.of(context).size.height * .8)),
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
                          text: 'Seleccione una opción',
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
                                Icons.assignment_ind,
                                color: Colors.red,
                                size: 15,
                              ),
                              title: H2Text(
                                text: e,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              onTap: () {
                                _estadoCivilController.text = e;
                                print(_estadoCivilController.text);
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

class TextFieldModalidadLaboral extends StatelessWidget {
  const TextFieldModalidadLaboral({
    super.key,
    required TextEditingController modalidadLaboralController,
  }) : _modalidadLaboralController = modalidadLaboralController;

  final TextEditingController _modalidadLaboralController;

  @override
  Widget build(BuildContext context) {
    List<String> tipo = [
      'Tiempo Completo',
      'Medio Tiempo',
      'Contrato Temporal',
      'Contrato por Proyecto',
      'Prácticas',
      'Freelance',
      'Trabajo Eventual',
      'Otro'
    ];

    return CardCustomFom(
      label: 'Seleccione la Modalidad Laboral.',
      child: TextFormField(
        readOnly: true, // Deshabilita la edición directa del texto
        showCursor: true, // Muestra el cursor al tocar el campo
        controller: _modalidadLaboralController,
        decoration: decorationTextField(
            hintText: 'campo obligatorio',
            labelText: 'Modalidad Laboral',
            prefixIcon:
                const Icon(Icons.panorama_fisheye, color: Colors.black45)),
        validator: (value) {
          return null;
        },
        onTap: () {
          showModalBottomSheet(
              constraints: BoxConstraints.loose(
                  Size.fromHeight(MediaQuery.of(context).size.height * .8)),
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
                          text: 'Seleccione una opción',
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
                                Icons.assignment_ind,
                                color: Colors.red,
                                size: 15,
                              ),
                              title: H2Text(
                                text: e,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                              onTap: () {
                                _modalidadLaboralController.text = e;
                                print(_modalidadLaboralController.text);
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
