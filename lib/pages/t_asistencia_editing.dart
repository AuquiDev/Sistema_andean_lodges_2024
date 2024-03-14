// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_asistencia.dart';
import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_asistencia.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/parse_fecha_nula.dart';
import 'package:ausangate_op/widgets/card_custom_formfield_shadow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormularioAsistencia extends StatefulWidget {
  const FormularioAsistencia({
    super.key,
    this.e,
  });

  final TAsistenciaModel? e;

  @override
  State<FormularioAsistencia> createState() => _FormularioAsistenciaState();
}

class _FormularioAsistenciaState extends State<FormularioAsistencia> {
  final TextEditingController _idempleadosController = TextEditingController();
  final TextEditingController _idtrabajoController = TextEditingController();
  final TextEditingController _horaEntradaController = TextEditingController();
  final TextEditingController _horaSalidaController = TextEditingController();
  final TextEditingController _nombrePersonalController =
      TextEditingController();
  final TextEditingController _actividadRolController = TextEditingController();
  final TextEditingController _detallesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String proveedor = '';
  // String codigogrupo = 'codígo';

  var title = 'Registrar Asistencia';

  @override
  void initState() {
    if (widget.e != null) {
      _idempleadosController.text = widget.e!.idEmpleados;
      _idtrabajoController.text = widget.e!.idTrabajo;
      _horaEntradaController.text = widget.e!.horaEntrada.toString();
      if (widget.e!.horaSalida!.year != 1998) {
        _horaSalidaController.text = widget.e!.horaSalida.toString();
      } else {
        _horaSalidaController.text = '';
      }
      _nombrePersonalController.text = widget.e!.nombrePersonal.toString();
      _actividadRolController.text = widget.e!.actividadRol.toString();
      _detallesController.text = widget.e!.detalles.toString();
      optionPersonal = widget.e!.actividadRol;
      title = 'Editar Registro';
    } else {
      print('Crear nuevo');
      _actividadRolController.text = optionPersonal;
    }
    super.initState();
  }

  String optionPersonal = 'COCINERO'; // Idioma predeterminado: español

  Map<String, String> gruposOcupacionales = {
    'GUARDIÁN DE LODGES':
        'Guardián de lodges es responsable de la seguridad y bienestar en los lodges.',
    'ALMACÉN CONGOMIRE': 'Personal encargado del almacén en Congomire.',
    'GRUPO DE TEJEDORAS':
        'Equipo de tejedoras que trabajan en la creación de productos textiles.',
    // 'CABALLO CARGA/SILLA':
    //     'Caballos utilizados en diversas tareas, como transporte de carga o compañía.',
    // 'LLAMAS':
    //     'Llamas utilizadas en diversas tareas, como transporte de carga o compañía.',
    'LIMPIEZA':
        'Personal de limpieza responsable de mantener las instalaciones en condiciones óptimas.',
    'LLAMEROS': 'Personas que cuidan y guían a las llamas.',
    'ARRIEROS':
        'Encargados del cuidado y manejo de animales de carga, como llamas o Caballos.',
    'COCINERO': 'Encargado de la preparación de alimentos.',
    'ASISTENTE DE COCINA':
        'Asistente en labores de cocina, apoyando al cocinero principal.',
    'ANFITRIÓN':
        'Persona encargada de recibir y atender a los visitantes o huéspedes.'
  };

  @override
  Widget build(BuildContext context) {
    final isavingProvider = Provider.of<TAsistenciaProvider>(context).isSyncing;   
    //LISTA GRUPOS ALMACÉN
    final listadetalletrabajo = Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
    
    listadetalletrabajo.sort((a, b) => a.created!.compareTo(b.created!));

    TDetalleTrabajoModel obtenerDetalleTrabajo(String idTrabajo) {
      for (var data in listadetalletrabajo) {
        if (data.id == idTrabajo) {
          return data;
        }
      }
      return TDetalleTrabajoModel(
          codigoGrupo: '',
          idRestriccionAlimentos: '',
          idCantidadPaxguia: '',
          idItinerariodiasnoches: '',
          idTipogasto: '',
          fechaInicio: DateTime.now(),
          fechaFin: DateTime.now(),
          descripcion: '',
          costoAsociados: 0);
    }

    // final v = obtenerDetalleTrabajo(widget.e != null ? widget.e!.idTrabajo : '');
    // final v = obtenerDetalleTrabajo(widget.e != null ? widget.e!.idTrabajo : _detallesController.text);

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).unfocus();
                print('FocusScope of: Desaprecer teclado.');
              },
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 550),
                    margin: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            H2Text(
                              text:
                                  'Formulario de Asistencia ${widget.e != null ? widget.e!.id : ''}',
                              fontSize: 16,
                            ),
                          ],
                        ),
                        //IDEMPELADO : es quien usa elsistema
                        Stack(
                          children: [
                            CardCustomFom(
                              label: 'Codígo de grupo :',
                              child: TextFormField(
                                controller: _idtrabajoController,
                                readOnly:
                                    true, // Deshabilita la edición directa del texto
                                showCursor:
                                    true, // Muestra el cursor al tocar el campo
                                decoration: decorationTextField(
                                    hintText: 'campo obligatorio',
                                    labelText: 'Id trabajo',
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
                                onTap: () {
                                  showModalBottomSheet(
                                      constraints: BoxConstraints.loose(
                                          Size.fromHeight(MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Expanded(
                                                child: LayoutBuilder(builder:
                                                    (BuildContext context,
                                                        BoxConstraints
                                                            constraints) {
                                                  // Calcular el número de columnas en función del ancho disponible
                                                  int crossAxisCount =
                                                      (constraints.maxWidth /
                                                              100)
                                                          .floor();
                                                  // Puedes ajustar el valor 100 según tus necesidades
                                                  return GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:
                                                          crossAxisCount,
                                                        mainAxisSpacing: 1,
                                                        crossAxisSpacing: 1,
                                                        childAspectRatio: 2
                                                    ),
                                                    itemCount:
                                                        listadetalletrabajo
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final t = listadetalletrabajo
                                                              .reversed
                                                              .toList()[index];
                                                      return GestureDetector(
                                                        onTap: () {
                                                          _idtrabajoController
                                                              .text = t.id!;

                                                          obtenerDetalleTrabajo(_idtrabajoController.text);
                                                          print(t.codigoGrupo);
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          color:_idtrabajoController.text == t.id ?
                                                           const Color(0xFFEDED06) : const Color(0x1F908989),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              H2Text(
                                                                text: t
                                                                    .codigoGrupo,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 20,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              height: 70,
                              width: 150,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ]),
                                child: Center(
                                    child: H2Text(
                                  text: obtenerDetalleTrabajo(_idtrabajoController.text).codigoGrupo,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                              ),
                            )
                          ],
                        ),

                        H2Text(
                          text: gruposOcupacionales[optionPersonal]!,
                          fontSize: 12,
                          maxLines: 6,
                          textAlign: TextAlign.start,
                        ),
                        CardCustomFom(
                          label: 'Actividad y/o Rol que desempeña.',
                          child: DropdownButtonFormField(
                            decoration: decorationTextField(
                                hintText: 'Seleccione personal',
                                labelText: 'Seleccione una opción',
                                prefixIcon: const Icon(Icons.people)),
                            value: optionPersonal,
                            onChanged: (String? newValue) {
                              setState(() {
                                optionPersonal = newValue!;
                                _actividadRolController.text = optionPersonal;
                                print(
                                    '${_actividadRolController.text}: Slected');
                              });
                            },
                            items: gruposOcupacionales.entries
                                .map((MapEntry<String, String> entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: H2Text(
                                  text: entry.key,
                                  fontSize: 13,
                                  maxLines: 6,
                                ),
                              );
                            }).toList(),
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
                          label: 'Nombre del personal',
                          child: TextFormField(
                            controller: _nombrePersonalController,
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Ingrese el nombre del personal',
                                prefixIcon: const Icon(
                                  Icons.person,
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo obligatorio';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        CheckboxListTile.adaptive(
                          title: const H2Text(
                            text: 'Hora de Entrada',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          subtitle: H2Text(
                            text: _horaEntradaController.text.isNotEmpty
                                ? formatFechaHoraNow(
                                    DateTime.parse(_horaEntradaController.text))
                                : '',
                            fontSize: 12,
                          ),
                          value: _horaEntradaController.text.isNotEmpty,
                          onChanged: _horaEntradaController.text.isNotEmpty
                              ? null
                              : (value) {
                                  setState(() {
                                    if (value!) {
                                      _horaEntradaController.text =
                                          DateTime.now().toString();
                                      print(_horaEntradaController.text);
                                    } else {
                                      _horaEntradaController
                                          .clear(); // Limpia el campo si se desmarca
                                    }
                                  });
                                },
                        ),
                        _horaEntradaController.text.isNotEmpty
                            ? CheckboxListTile.adaptive(
                                title: const H2Text(
                                  text: 'Hora de Salida',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                subtitle: H2Text(
                                  text: _horaSalidaController.text.isNotEmpty
                                      ? formatFechaHoraNow(DateTime.parse(
                                          _horaSalidaController.text))
                                      : '',
                                  fontSize: 12,
                                ),
                                value: _horaSalidaController.text.isNotEmpty,
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      _horaSalidaController.text =
                                          DateTime.now().toString();
                                      print(_horaSalidaController.text);
                                    } else {
                                      _horaSalidaController
                                          .clear(); // Limpia el campo si se desmarca

                                    }
                                  });
                                },
                              )
                            : const SizedBox(),

                        CardCustomFom(
                          label:
                              'Describe cualquier detalle relevante, como incidencias, sugerencias, observaciones sobre el personal, justificaciones, etc.',
                          child: TextFormField(
                            controller: _detallesController,
                            maxLength: 350,
                            maxLines: 4,
                            decoration: decorationTextField(
                                hintText: 'opcional',
                                labelText: 'Campo opcional',
                                prefixIcon: const Icon(Icons.panorama_fisheye,
                                    color: Colors.black45)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 50),
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.deepOrange)),
                            onPressed: isavingProvider
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate() &&
                                        _horaEntradaController
                                            .text.isNotEmpty) {
                                      if (widget.e != null) {//si los datos a estiar son diferente de nulo
                                        //Si la hora de salida no esta vacia que Editar
                                        if (_horaSalidaController.text.isNotEmpty) {
                                          editarEntrada();
                                         _formKey.currentState!.save();
                                         //Si esta vacio la hora de salida
                                        } else {
                                          //Verifica que :Si no hubo ningun cambio en la Hora de Salida entonces editar
                                           if (widget.e!.horaSalida == DateTime.parse(_horaSalidaController.text)) {
                                            editarEntrada();
                                         _formKey.currentState!.save();
                                         //Si realiaa cambio en lahora de salida y la saldia esta vacia decir que complete
                                           } else {
                                             completeForm();
                                           }
                                        }
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
                                    child: isavingProvider
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
          ),
        ],
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
    await context.read<TAsistenciaProvider>().updateTAsistenciaProvider(
          id: widget.e!.id,
          idEmpleados: _idempleadosController.text,
          idTrabajo: _idtrabajoController.text,
          horaEntrada: DateTime.parse(_horaEntradaController.text),
          horaSalida: parseDateTime(_horaSalidaController.text),
          nombrePersonal: _nombrePersonalController.text,
          actividadRol: _actividadRolController.text,
          detalles: _detallesController.text,
        );
    snackBarButon('✅ Registro editado correctamente.');
    Navigator.pop(context);
  }

  Future<void> guardarEntrada() async {
    final user =
        Provider.of<UsuarioProvider>(context, listen: false).usuarioEncontrado;
    user != null ? _idempleadosController.text = user.id! : null;
    DateTime? horaSalida;
    if (_horaSalidaController.text != null &&
        _horaSalidaController.text.isNotEmpty) {
      horaSalida = DateTime.parse(_horaSalidaController.text);
    }
    await context.read<TAsistenciaProvider>().postTAsistenciaProvider(
          id: '',
          idEmpleados: _idempleadosController.text,
          idTrabajo: _idtrabajoController.text,
          horaEntrada: DateTime.parse(_horaEntradaController.text),
          horaSalida: horaSalida, //DateTime.parse(_horaSalidaController.text),
          nombrePersonal: _nombrePersonalController.text,
          actividadRol: _actividadRolController.text,
          detalles: _detallesController.text,
        );
    snackBarButon('✅ Registro guardado correctamente.');
    _clearn();
    // Navigator.pop(context);
  }

  void _clearn() {
    _idempleadosController.clear();
    // _idtrabajoController.clear();
    _horaEntradaController.clear();
    _horaSalidaController.clear();
    _nombrePersonalController.clear();
    // _actividadRolController.clear();
    _detallesController.clear();
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
}

