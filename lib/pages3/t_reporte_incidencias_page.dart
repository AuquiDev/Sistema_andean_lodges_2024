// ignore_for_file: unused_field, avoid_print, must_be_immutable, use_build_context_synchronously, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/models/model_t_reporte_incidencias.dart';
import 'package:ausangate_op/pages3/preguntas_pasajeros.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/provider/provider_t_reporte_incidencias.dart';
import 'package:ausangate_op/utils/custom_form.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/widgets/card_custom_reporte_pasajero.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditReportPageIncidencias extends StatefulWidget {
  const EditReportPageIncidencias({
    super.key,
    this.e,
  });
  final TReporteIncidenciasModel? e;
  @override
  State<EditReportPageIncidencias> createState() =>
      _EditReportPageIncidenciasState();
}

class _EditReportPageIncidenciasState extends State<EditReportPageIncidencias> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idtrabajoController = TextEditingController();
  final TextEditingController _idEmpleadosController = TextEditingController();
  final TextEditingController _pregunta1Controller = TextEditingController();
  final TextEditingController _pregunta2Controller = TextEditingController();
  final TextEditingController _pregunta3Controller = TextEditingController();
  final TextEditingController _pregunta4Controller = TextEditingController();
  final TextEditingController _pregunta5Controller = TextEditingController();
  final TextEditingController _pregunta6Controller = TextEditingController();
  final TextEditingController _pregunta7Controller = TextEditingController();

  var title = 'REPORTE DE INCIDENTES - ANDEAN LODGES';
  bool valueEstadoProducto = true; //SwithAdaptative check
  @override
  void initState() {
    final userCahe =
        Provider.of<UsuarioProvider>(context, listen: false).usuarioEncontrado;
    if (widget.e != null) {
      _idtrabajoController.text = widget.e!.idTrabajo;
      _idEmpleadosController.text = userCahe!.id!;
      _pregunta1Controller.text = widget.e!.pregunta1;
      _pregunta2Controller.text = widget.e!.pregunta2;
      _pregunta3Controller.text = widget.e!.pregunta3;
      _pregunta4Controller.text = widget.e!.pregunta4;
      _pregunta5Controller.text = widget.e!.pregunta5;
      _pregunta6Controller.text = widget.e!.pregunta6;
      _pregunta7Controller.text = widget.e!.pregunta7;
      // title = 'Editar: ${widget.e!.nombrePasajero}';
    } else {
      _idEmpleadosController.text = userCahe!.id!;
    }
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  final ScrollController _scrollController = ScrollController();
  bool showAppBar = true;

  void _onScroll() {
    //devulve el valor del scrollDirection.
    setState(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        //Scroll Abajo
        showAppBar = true;
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //Scroll Arriba
        showAppBar = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  bool _showCustomInput1 = false;
  bool _showCustomInput2 = false;
  bool _showCustomInput3 = false;
  bool _showCustomInput4 = false;
  bool _showCustomInput5 = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final isOffline = Provider.of<UsuarioProvider>(context).isOffline;
   
    final isSavingSerer =
        Provider.of<TReporteIncidenciasProvider>(context).isSyncing;
    bool isavingProvider =  isSavingSerer;

    //LISTA GRUPOS ALMACÉN
    final listatrabajoApi =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
   
    final listadetalletrabajo =  listatrabajoApi;
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

    //Se USA en el Boton Guardar
    final size = MediaQuery.of(context).size;
    // bool idioma = bool.parse(_idiomaController.text);
    return GestureDetector(
      onTap: () {
        // Cierra el teclado cuando tocas en cualquier lugar de la pantalla
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          color: const Color(0x2B7E682D),
          child: Center(
            child: Column(
              children: [
                size.height > 500
                    ? Container(
                        child: showAppBar
                            ? const CardTitleFormPax(
                                title:
                                    'Por favor, complete este reporte detallando cualquier incidente ocurrido en las siguientes etapas del viaje.')
                            : const SizedBox(),
                      )
                    : const SizedBox(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //IDEMPELADO : es quien usa elsistema
                              //IDTRABAJO es codigo de grupo 
                              Stack(
                                children: [
                                  CardCustomFormOutilne(
                                    label: 'Codígo de grupo',
                                    child: Column(
                                      children: [
                                        if (_idtrabajoController.text.isEmpty)
                                          TextFormField(
                                            controller: _idtrabajoController,
                                            readOnly:
                                                true, // Deshabilita la edición directa del texto
                                            showCursor:
                                                true, // Muestra el cursor al tocar el campo
                                            decoration:
                                                decorationTextFieldUnderLine(
                                              hintText: 'campo obligatorio',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Campo obligatorio';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onTap: () {
                                              showModalBottomSheet(
                                                  constraints: BoxConstraints
                                                      .loose(Size.fromHeight(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .80)),
                                                  scrollControlDisabledMaxHeightRatio:
                                                      BorderSide
                                                          .strokeAlignOutside,
                                                  useSafeArea: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const DividerCustom(),
                                                          const Center(
                                                            child: H2Text(
                                                              text:
                                                                  'Seleccione el Codígo de Grupo.',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          Expanded(
                                                            child: LayoutBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    BoxConstraints
                                                                        constraints) {
                                                              // Calcular el número de columnas en función del ancho disponible
                                                              int crossAxisCount =
                                                                  (constraints.maxWidth /
                                                                          100)
                                                                      .floor();
                                                              // Puedes ajustar el valor 100 según tus necesidades
                                                              return GridView
                                                                  .builder(
                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        crossAxisCount,
                                                                    mainAxisSpacing:
                                                                        1,
                                                                    crossAxisSpacing:
                                                                        1,
                                                                    childAspectRatio:
                                                                        2),
                                                                itemCount:
                                                                    listadetalletrabajo
                                                                        .length,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  final t = listadetalletrabajo
                                                                      .reversed
                                                                      .toList()[index];
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      _idtrabajoController
                                                                              .text =
                                                                          t.id!;

                                                                      obtenerDetalleTrabajo(
                                                                          _idtrabajoController
                                                                              .text);
                                                                      print(t
                                                                          .codigoGrupo);
                                                                      setState(
                                                                          () {});
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      color: _idtrabajoController.text == t.id
                                                                          ? const Color(
                                                                              0xFFEDED06)
                                                                          : const Color(
                                                                              0x1F908989),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          H2Text(
                                                                            text:
                                                                                t.codigoGrupo,
                                                                            fontWeight:
                                                                                FontWeight.w900,
                                                                            fontSize:
                                                                                20,
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
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    height: 70,
                                    width: 170,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _idtrabajoController.clear();
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF5F3113),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: H2Text(
                                          text: obtenerDetalleTrabajo(
                                                  _idtrabajoController.text)
                                              .codigoGrupo,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.white,
                                        )),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              //PREGUNTA 01
                              CardCustomFormOutilne(
                                label:preguntasIncidencias[0],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadioListTile<String>(
                                      title: const Text('No'),
                                      value: 'No',
                                      groupValue: _pregunta1Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta1Controller.text = value!;
                                        });
                                        _showCustomInput1 = false;
                                      },
                                    ),

                                    RadioListTile<String>(
                                      title: const Text('Si'),
                                      value: 'Si',
                                      groupValue: _pregunta1Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta1Controller.text = value!;
                                        });
                                        // Mostrar el TextField cuando se selecciona "Otros"
                                        _showCustomInput1 = true;
                                      },
                                    ),
                                    // TextField para datos personalizados cuando se selecciona "Otros"
                                    if (_showCustomInput1)
                                      CardCustomFormOutilne(
                                        label: 'Otros (Especifique)',
                                        child: TextFormField(
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          maxLength: 350,
                                          maxLines: 4,
                                          controller: _pregunta1Controller,
                                          decoration:
                                              decorationTextFieldUnderLine(
                                            hintText:
                                                'Ingrese detalles adicionales',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Campo Obligatorio';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                             
                              //PREGUNTA 02
                              CardCustomFormOutilne(
                                label:preguntasIncidencias[1],
                                child: Column(
                                  children: [
                                    RadioListTile<String>(
                                      title: const Text('No'),
                                      value: 'No',
                                      groupValue: _pregunta2Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta2Controller.text = value!;
                                        });
                                        _showCustomInput2 = false;
                                      },
                                    ),

                                    RadioListTile<String>(
                                      title: const Text('Si'),
                                      value: 'Si',
                                      groupValue: _pregunta2Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta2Controller.text = value!;
                                        });
                                        // Mostrar el TextField cuando se selecciona "Otros"
                                        _showCustomInput2 = true;
                                      },
                                    ),
                                    // TextField para datos personalizados cuando se selecciona "Otros"
                                    if (_showCustomInput2)
                                      CardCustomFormOutilne(
                                        label: 'Otros (Especifique)',
                                        child: TextFormField(
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          maxLength: 350,
                                          maxLines: 4,
                                          controller: _pregunta2Controller,
                                          decoration:
                                              decorationTextFieldUnderLine(
                                            hintText:
                                                'Ingrese detalles adicionales',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Campo Obligatorio';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                            
                              //PREGUNTA 03
                              CardCustomFormOutilne(
                                label:preguntasIncidencias[2],
                                child: Column(
                                  children: [
                                    RadioListTile<String>(
                                      title: const Text('No'),
                                      value: 'No',
                                      groupValue: _pregunta3Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta3Controller.text = value!;
                                        });
                                        _showCustomInput3 = false;
                                      },
                                    ),

                                    RadioListTile<String>(
                                      title: const Text('Si'),
                                      value: 'Si',
                                      groupValue: _pregunta3Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta3Controller.text = value!;
                                        });
                                        // Mostrar el TextField cuando se selecciona "Otros"
                                        _showCustomInput3 = true;
                                      },
                                    ),
                                    // TextField para datos personalizados cuando se selecciona "Otros"
                                    if (_showCustomInput3)
                                      CardCustomFormOutilne(
                                        label: 'Otros (Especifique)',
                                        child: TextFormField(
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          maxLength: 350,
                                          maxLines: 4,
                                          controller: _pregunta3Controller,
                                          decoration:
                                              decorationTextFieldUnderLine(
                                            hintText:
                                                'Ingrese detalles adicionales',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Campo Obligatorio';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            
                              //PREGUNTA 04
                              CardCustomFormOutilne(
                                label:preguntasIncidencias[3],
                                child: Column(
                                  children: [
                                    RadioListTile<String>(
                                      title: const Text('No'),
                                      value: 'No',
                                      groupValue: _pregunta4Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta4Controller.text = value!;
                                        });
                                        _showCustomInput4 = false;
                                      },
                                    ),

                                    RadioListTile<String>(
                                      title: const Text('Si'),
                                      value: 'Si',
                                      groupValue: _pregunta4Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta4Controller.text = value!;
                                        });
                                        // Mostrar el TextField cuando se selecciona "Otros"
                                        _showCustomInput4 = true;
                                      },
                                    ),
                                    // TextField para datos personalizados cuando se selecciona "Otros"
                                    if (_showCustomInput4)
                                      CardCustomFormOutilne(
                                        label: 'Otros (Especifique)',
                                        child: TextFormField(
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          maxLength: 350,
                                          maxLines: 4,
                                          controller: _pregunta4Controller,
                                          decoration:
                                              decorationTextFieldUnderLine(
                                            hintText:
                                                'Ingrese detalles adicionales',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Campo Obligatorio';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              
                              //PREGUNTA 05
                              CardCustomFormOutilne(
                                label:preguntasIncidencias[4],
                                child: Column(
                                  children: [
                                    RadioListTile<String>(
                                      title: const Text('No'),
                                      value: 'No',
                                      groupValue: _pregunta5Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta5Controller.text = value!;
                                        });
                                        _showCustomInput5 = false;
                                      },
                                    ),

                                    RadioListTile<String>(
                                      title: const Text('Si'),
                                      value: 'Si',
                                      groupValue: _pregunta5Controller.text,
                                      onChanged: (value) {
                                        setState(() {
                                          _pregunta5Controller.text = value!;
                                        });
                                        // Mostrar el TextField cuando se selecciona "Otros"
                                        _showCustomInput5 = true;
                                      },
                                    ),
                                    // TextField para datos personalizados cuando se selecciona "Otros"
                                    if (_showCustomInput5)
                                      CardCustomFormOutilne(
                                        label: 'Otros (Especifique)',
                                        child: TextFormField(
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          maxLength: 350,
                                          maxLines: 4,
                                          controller: _pregunta5Controller,
                                          decoration:
                                              decorationTextFieldUnderLine(
                                            hintText:
                                                'Ingrese detalles adicionales',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Campo Obligatorio';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              //PREGUNTA 06
                              CardCustomFormOutilne(
                                label:  preguntasIncidencias[5],
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLength: 350,
                                  maxLines: 4,
                                  controller: _pregunta6Controller,
                                  decoration: decorationTextFieldUnderLine(
                                    hintText: 'Ingrese detalles adicionales',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Campo Obligatorio';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              
                              //PREGUNTA 07
                              CardCustomFormOutilne(
                                label:preguntasIncidencias[6],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        const H2Text(
                                          text: 'Muy malos',
                                          fontSize: 15,
                                          maxLines: 3,
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              const H2Text(
                                                text: '1',
                                                fontSize: 16,
                                              ),
                                              Radio(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                value: '1',
                                                groupValue:
                                                    _pregunta7Controller.text,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta7Controller.text =
                                                        value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              const H2Text(
                                                text: '2',
                                                fontSize: 16,
                                              ),
                                              Radio(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                value: '2',
                                                groupValue:
                                                    _pregunta7Controller.text,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta7Controller.text =
                                                        value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              const H2Text(
                                                text: '3',
                                                fontSize: 16,
                                              ),
                                              Radio(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                value: '3',
                                                groupValue:
                                                    _pregunta7Controller.text,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta7Controller.text =
                                                        value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              const H2Text(
                                                text: '4',
                                                fontSize: 16,
                                              ),
                                              Radio(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                value: '4',
                                                groupValue:
                                                    _pregunta7Controller.text,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta7Controller.text =
                                                        value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            children: [
                                              const H2Text(
                                                text: '5',
                                                fontSize: 16,
                                              ),
                                              Radio(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                value: '5',
                                                groupValue:
                                                    _pregunta7Controller.text,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _pregunta7Controller.text =
                                                        value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const H2Text(
                                          text: 'Exelente',
                                          fontSize: 15,
                                        ),
                                      ],
                                    ),
                                    // Botón para borrar selección
                                    if (_pregunta7Controller.text.isNotEmpty)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _pregunta7Controller.text =
                                                ''; // Borrar selección
                                          });
                                        },
                                        child: const Text('Borrar Selección'),
                                      )
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30.0),
                                    child: TextButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0))),
                                          backgroundColor:
                                              const MaterialStatePropertyAll(
                                            Color(0xFF5F3113),
                                          )),
                                      onPressed: isavingProvider
                                          ? null
                                          : () async {
                                              print('push buton');
                                              if (_formKey.currentState!
                                                  .validate()) {
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
                                          width: 100,
                                          height: 30,
                                          child: Center(
                                              child: isavingProvider
                                                  ? const CircularProgressIndicator()
                                                  : const H2Text(
                                                      text: 'Enviar',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ))),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _cleanAll();
                                        });
                                      },
                                      child: const H2Text(
                                        text: 'Borrar Formulario',
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 5, 94, 123),
                                        fontSize: 16,
                                      ))
                                ],
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

 
  Future<void> editarDatos() async {
    await context.read<TReporteIncidenciasProvider>().updateTAsistenciaProvider(
          id: widget.e!.id,
          idEmpleados: _idEmpleadosController.text,
          idTrabajo: _idtrabajoController.text,
          pregunta1: _pregunta1Controller.text,
          pregunta2: _pregunta2Controller.text,
          pregunta3: _pregunta3Controller.text,
          pregunta4: _pregunta4Controller.text,
          pregunta5: _pregunta5Controller.text,
          pregunta6: _pregunta6Controller.text,
          pregunta7: _pregunta7Controller.text,
        );
    print('NOMBRE: ${_idEmpleadosController.text}');

    snackBarButon('✅ Registro editado correctamente.');
    Navigator.pop(context);
  }

  Future<void> enviarDatos() async {
    await context.read<TReporteIncidenciasProvider>().postTAsistenciaProvider(
          //  id: id,
          idEmpleados: _idEmpleadosController.text,
          idTrabajo: _idtrabajoController.text,
          pregunta1: _pregunta1Controller.text,
          pregunta2: _pregunta2Controller.text,
          pregunta3: _pregunta3Controller.text,
          pregunta4: _pregunta4Controller.text,
          pregunta5: _pregunta5Controller.text,
          pregunta6: _pregunta6Controller.text,
          pregunta7: _pregunta7Controller.text,
        );
    print('ESTADO: ${_idEmpleadosController.text}');
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
    // _idEmpleadosController.clear();
    // _idtrabajoController.clear();
    _pregunta1Controller.clear();
    _pregunta2Controller.clear();
    _pregunta3Controller.clear();
    _pregunta4Controller.clear();
    _pregunta5Controller.clear();
    _pregunta6Controller.clear();
    _pregunta7Controller.clear();
  }
}
