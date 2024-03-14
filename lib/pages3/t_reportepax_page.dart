// ignore_for_file: unused_field, avoid_print, must_be_immutable, use_build_context_synchronously, prefer_adjacent_string_concatenation

import 'dart:async';

import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/models/model_t_report_pasajero.dart';
import 'package:ausangate_op/pages3/preguntas_pasajeros.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/provider/provider_t_report_pasajero.dart';
import 'package:ausangate_op/utils/custom_form.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/utils/parse_bool.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:ausangate_op/widgets/card_custom_reporte_pasajero.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditReportPagePasajeros extends StatefulWidget {
  const EditReportPagePasajeros({
    super.key,
    this.e,
  });
  final TReportPasajeroModel? e;
  @override
  State<EditReportPagePasajeros> createState() =>
      _EditReportPagePasajerosState();
}

class _EditReportPagePasajerosState extends State<EditReportPagePasajeros> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idtrabajoController = TextEditingController();
  final TextEditingController _nombrePaxController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _idiomaController = TextEditingController();
  final TextEditingController _pregunta1Controller = TextEditingController();
  final TextEditingController _pregunta2Controller = TextEditingController();
  final TextEditingController _pregunta3Controller = TextEditingController();
  final TextEditingController _pregunta4Controller = TextEditingController();
  final TextEditingController _pregunta5Controller = TextEditingController();
  final TextEditingController _pregunta6Controller = TextEditingController();
  final TextEditingController _pregunta7Controller = TextEditingController();
  final TextEditingController _pregunta8Controller = TextEditingController();
  final TextEditingController _pregunta9Controller = TextEditingController();
  final TextEditingController _pregunta10Controller = TextEditingController();
  final TextEditingController _pregunta11Controller = TextEditingController();
  final TextEditingController _pregunta12Controller = TextEditingController();
  final TextEditingController _pregunta13Controller = TextEditingController();
  final TextEditingController _idEmpleadosController = TextEditingController();

  var title = 'Andean Lodges';
  bool valueEstadoProducto = true; //SwithAdaptative check
  @override
  void initState() {
    final userCahe = Provider.of<UsuarioProvider>(context, listen: false).usuarioEncontrado;
    if (widget.e != null) {
      _idtrabajoController.text = widget.e!.idTrabajo;
      _nombrePaxController.text = widget.e!.nombrePasajero;
      _gmailController.text = widget.e!.gmail;
      _idiomaController.text = widget.e!.idioma.toString();
      _pregunta1Controller.text = widget.e!.pregunta1;
      _pregunta2Controller.text = widget.e!.pregunta2;
      _pregunta3Controller.text = widget.e!.pregunta3;
      _pregunta4Controller.text = widget.e!.pregunta4;
      _pregunta5Controller.text = widget.e!.pregunta5;
      _pregunta6Controller.text = widget.e!.pregunta6;
      _pregunta7Controller.text = widget.e!.pregunta7;
      _pregunta8Controller.text = widget.e!.pregunta8;
      _pregunta9Controller.text = widget.e!.pregunta9;
      _pregunta10Controller.text = widget.e!.pregunta10;
      _pregunta11Controller.text = widget.e!.pregunta11;
      _pregunta12Controller.text = widget.e!.pregunta12;
      _pregunta13Controller.text = widget.e!.pregunta13;
      _idEmpleadosController.text = userCahe!.id!;
      title = 'Editar: ${widget.e!.nombrePasajero}';
    } else {
      _idiomaController.text = valueEstadoProducto.toString();
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

  bool _showCustomInput = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final isSavingSerer =Provider.of<TReportPasajeroProvider>(context).isSyncing;
    bool isavingProvider =   isSavingSerer;

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
    bool idioma = bool.parse(_idiomaController.text);
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
                            ? CardTitleFormPax(
                                title: idioma
                                    ? titlesFormEspanish[6]
                                    : titlesFormIngles[6])
                            : const SizedBox(),
                      )
                    : const SizedBox(),
                Expanded(
                  child: ScrollWeb(
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
                              children: [
                                //IDEMPELADO : es quien usa elsistema
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
                                                                    FontWeight.w400,
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
                                                                            .toList()[
                                                                        index];
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
                                                                        color: _idtrabajoController.text ==
                                                                                t.id
                                                                            ? const Color(
                                                                                0xFFEDED06)
                                                                            : const Color(
                                                                                0x1F908989),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .center,
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
                                            borderRadius: BorderRadius.circular(10),
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
                              
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? titlesFormEspanish[0]
                                      : titlesFormIngles[0],
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: RadioListTile<bool>(
                                          title: Text(idioma
                                              ? titlesFormEspanish[2]
                                              : titlesFormIngles[2]),
                                          value: true,
                                          groupValue:
                                              parseBool(_idiomaController.text),
                                          onChanged: (value) {
                                            setState(() {
                                              _idiomaController.text =
                                                  value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: RadioListTile<bool>(
                                          title: Text(idioma
                                              ? titlesFormEspanish[1]
                                              : titlesFormIngles[1]),
                                          value: false,
                                          groupValue:
                                              parseBool(_idiomaController.text),
                                          onChanged: (value) {
                                            setState(() {
                                              _idiomaController.text =
                                                  value.toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[0]
                                      : preguntasIngles[0],
                                  child: TextFormField(
                                    controller: _nombrePaxController,
                                    decoration: decorationTextFieldUnderLine(
                                      hintText: idioma
                                          ? titlesFormEspanish[5]
                                          : titlesFormIngles[5],
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
                                CardCustomFormOutilne(
                                  label: 'E-mail',
                                  child: TextFormField(
                                    controller: _gmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: decorationTextFieldUnderLine(
                                     hintText: 'correo@example.com',
                                    ),
                                  validator: (value) {
                                      // Solo realiza la validación si el campo no está vacío
                                      if (value != null && value.isNotEmpty) {
                                        // Validación simple para verificar si es un correo electrónico válido
                                        if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                                            .hasMatch(value)) {
                                          return 'Ingrese un correo electrónico válido';
                                        }
                                      }
                                      return null; // La validación pasa
                                    },
                                          
                                  ),
                                ),
                                //PREGUNTA 01
                              
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[2]
                                      : preguntasIngles[2],
                                  child: Column(
                                    children: [
                                      RadioListTile<String>(
                                        title: const Text('www.andeanlodges.com'),
                                        value: 'www.andeanlodges.com',
                                        groupValue: _pregunta1Controller.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta1Controller.text = value!;
                                          });
                                          _showCustomInput = false;
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: Text(idioma ? 'Amigos' : 'Friend'),
                                        value: idioma ? 'Amigos' : 'Friend',
                                        groupValue: _pregunta1Controller.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta1Controller.text = value!;
                                          });
                                          _showCustomInput = false;
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: Text(idioma
                                            ? 'Prensa'
                                            : 'Newspapers / Press'),
                                        value: idioma
                                            ? 'Prensa'
                                            : 'Newspapers / Press',
                                        groupValue: _pregunta1Controller.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta1Controller.text = value!;
                                          });
                                          _showCustomInput = false;
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: Text(idioma
                                            ? 'Blogs/Redes Sociales'
                                            : 'Blogs/ Social media'),
                                        value: idioma
                                            ? 'Blogs/Redes Sociales'
                                            : 'Blogs/ Social media',
                                        groupValue: _pregunta1Controller.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta1Controller.text = value!;
                                          });
                                          _showCustomInput = false;
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: Text(idioma ? 'Otros' : 'Others'),
                                        value: idioma ? 'Otros' : 'Others',
                                        groupValue: _pregunta1Controller.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _pregunta1Controller.text = value!;
                                          });
                                          // Mostrar el TextField cuando se selecciona "Otros"
                                          _showCustomInput = true;
                                        },
                                      ),
                                      // TextField para datos personalizados cuando se selecciona "Otros"
                                      if (_showCustomInput)
                                        CardCustomFormOutilne(
                                          label: idioma
                                              ? 'Otros (Especifique)'
                                              : 'Others (Specify)',
                                          child: TextFormField(
                                            controller: _pregunta1Controller,
                                            decoration:
                                                decorationTextFieldUnderLine(
                                              hintText: idioma
                                                  ? 'Ingrese detalles adicionales'
                                                  : 'Enter additional details',
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return idioma
                                                    ? titlesFormEspanish[5]
                                                    : titlesFormIngles[5];
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
                                  label: idioma
                                      ? preguntasEspanish[3]
                                      : preguntasIngles[3],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy mala' : 'Very bad',
                                            fontSize: 15,
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
                                                      _pregunta2Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta2Controller.text =
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
                                                      _pregunta2Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta2Controller.text =
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
                                                      _pregunta2Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta2Controller.text =
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
                                                      _pregunta2Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta2Controller.text =
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
                                                      _pregunta2Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta2Controller.text =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                      if (_pregunta2Controller.text.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pregunta2Controller.text =
                                                  ''; // Borrar selección
                                            });
                                          },
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
                                    ],
                                  ),
                                ),
                              
                                //PREGUNTA 03
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[4]
                                      : preguntasIngles[4],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy mala' : 'Very bad',
                                            fontSize: 15,
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
                                                      _pregunta3Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta3Controller.text =
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
                                                      _pregunta3Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta3Controller.text =
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
                                                      _pregunta3Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta3Controller.text =
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
                                                      _pregunta3Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta3Controller.text =
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
                                                      _pregunta3Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta3Controller.text =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                      if (_pregunta3Controller.text.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pregunta3Controller.text =
                                                  ''; // Borrar selección
                                            });
                                          },
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
                                    ],
                                  ),
                                ),
                              
                                //PREGUNTA 04
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[5]
                                      : preguntasIngles[5],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy malas' : 'Very bad',
                                            fontSize: 15,
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
                                                      _pregunta4Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta4Controller.text =
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
                                                      _pregunta4Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta4Controller.text =
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
                                                      _pregunta4Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta4Controller.text =
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
                                                      _pregunta4Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta4Controller.text =
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
                                                      _pregunta4Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta4Controller.text =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                      // Botón para borrar selección
                                      if (_pregunta4Controller.text.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pregunta4Controller.text =
                                                  ''; // Borrar selección
                                            });
                                          },
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
                                    ],
                                  ),
                                ),
                              
                                //PREGUNTA 05
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[6]
                                      : preguntasIngles[6],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy malo' : 'Very bad',
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
                                                      _pregunta5Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta5Controller.text =
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
                                                      _pregunta5Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta5Controller.text =
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
                                                      _pregunta5Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta5Controller.text =
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
                                                      _pregunta5Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta5Controller.text =
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
                                                      _pregunta5Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta5Controller.text =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                      // Botón para borrar selección
                                      if (_pregunta5Controller.text.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pregunta5Controller.text =
                                                  ''; // Borrar selección
                                            });
                                          },
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
                                    ],
                                  ),
                                ),
                              
                                //PREGUNTA 06
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[7]
                                      : preguntasIngles[7],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy malo' : 'Very bad',
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
                                                      _pregunta6Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta6Controller.text =
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
                                                      _pregunta6Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta6Controller.text =
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
                                                      _pregunta6Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta6Controller.text =
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
                                                      _pregunta6Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta6Controller.text =
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
                                                      _pregunta6Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta6Controller.text =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                      // Botón para borrar selección
                                      if (_pregunta6Controller.text.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pregunta6Controller.text =
                                                  ''; // Borrar selección
                                            });
                                          },
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
                                    ],
                                  ),
                                ),
                              
                                //PREGUNTA 07
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[8]
                                      : preguntasIngles[8],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy malos' : 'Very bad',
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
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
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
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
                                    ],
                                  ),
                                ),
                              
                                //PREGUNTA 08
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[9]
                                      : preguntasIngles[9],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy malo' : 'Very bad',
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
                                                      _pregunta8Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta8Controller.text =
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
                                                      _pregunta8Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta8Controller.text =
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
                                                      _pregunta8Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta8Controller.text =
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
                                                      _pregunta8Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta8Controller.text =
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
                                                      _pregunta8Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta8Controller.text =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                      // Botón para borrar selección
                                      if (_pregunta8Controller.text.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pregunta8Controller.text =
                                                  ''; // Borrar selección
                                            });
                                          },
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
                                    ],
                                  ),
                                ),
                                //PREGUNTA 09
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[10]
                                      : preguntasIngles[10],
                                  child: TextFormField(
                                    controller: _pregunta9Controller,
                                    decoration: decorationTextFieldUnderLine(
                                      hintText:
                                          idioma ? 'tu respuesta' : 'Your response',
                                    ),
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                                //PREGUNTA 10
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[11]
                                      : preguntasIngles[11],
                                  child: TextFormField(
                                    controller: _pregunta10Controller,
                                    decoration: decorationTextFieldUnderLine(
                                      hintText:
                                          idioma ? 'tu respuesta' : 'Your response',
                                    ),
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                                //PREGUNTA 11
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[12]
                                      : preguntasIngles[12],
                                  child: TextFormField(
                                    controller: _pregunta11Controller,
                                    decoration: decorationTextFieldUnderLine(
                                      hintText:
                                          idioma ? 'tu respuesta' : 'Your response',
                                    ),
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              
                                //PREGUNTA 12
                              
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[14]
                                      : preguntasIngles[14],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy mala' : 'Very bad',
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
                                                      _pregunta12Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta12Controller.text =
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
                                                      _pregunta12Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta12Controller.text =
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
                                                      _pregunta12Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta12Controller.text =
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
                                                      _pregunta12Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta12Controller.text =
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
                                                      _pregunta12Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta12Controller.text =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                      // Botón para borrar selección
                                      if (_pregunta12Controller.text.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pregunta12Controller.text =
                                                  ''; // Borrar selección
                                            });
                                          },
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
                                    ],
                                  ),
                                ),
                                 //PREGUNTA 13
                              
                                CardCustomFormOutilne(
                                  label: idioma
                                      ? preguntasEspanish[14]
                                      : preguntasIngles[14],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          H2Text(
                                            text: idioma ? 'Muy mala' : 'Very bad',
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
                                                      _pregunta13Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta13Controller.text =
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
                                                      _pregunta13Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta13Controller.text =
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
                                                      _pregunta13Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta13Controller.text =
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
                                                      _pregunta13Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta13Controller.text =
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
                                                      _pregunta13Controller.text,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _pregunta13Controller.text =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          H2Text(
                                            text: idioma ? 'Exelente' : 'Excellent',
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                      // Botón para borrar selección
                                      if (_pregunta13Controller.text.isNotEmpty)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _pregunta13Controller.text =
                                                  ''; // Borrar selección
                                            });
                                          },
                                          child: Text(idioma
                                              ? 'Borrar Selección'
                                              : "Clear Selection"),
                                        ),
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
                                                        fontWeight: FontWeight.w500,
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
                                // Container(
                                //     margin: const EdgeInsets.symmetric(vertical: 20),
                                //   child: OutlinedButton(
                                //     onPressed: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => const ConectivityDemo()));
                                //     },
                                //     child:  const Text('data'),
                                //     ),
                                // ),
                              ],
                            ),
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
    await context.read<TReportPasajeroProvider>().putReportePasajeroProvider(
        id: widget.e!.id,
        gmail: _gmailController.text,
        idTrabajo: _idtrabajoController.text,
        nombrePasajero: _nombrePaxController.text,
        idioma: bool.parse(_idiomaController.text),
        pregunta1: _pregunta1Controller.text,
        pregunta2: _pregunta2Controller.text,
        pregunta3: _pregunta3Controller.text,
        pregunta4: _pregunta4Controller.text,
        pregunta5: _pregunta5Controller.text,
        pregunta6: _pregunta6Controller.text,
        pregunta7: _pregunta7Controller.text,
        pregunta8: _pregunta8Controller.text,
        pregunta9: _pregunta9Controller.text,
        pregunta10: _pregunta10Controller.text,
        pregunta11: _pregunta11Controller.text,
        pregunta12: _pregunta12Controller.text,
        pregunta13: _pregunta13Controller.text,
        idEmpleados: _idEmpleadosController.text);
    print('NOMBRE: ${_idiomaController.text}');
    
    snackBarButon('✅ Registro editado correctamente.');
    Navigator.pop(context);
  }

  Future<void> enviarDatos() async {
    await context.read<TReportPasajeroProvider>().postReportePasajeroProvider(
        //  id: id,
        gmail: _gmailController.text,
        idTrabajo: _idtrabajoController.text,
        nombrePasajero: _nombrePaxController.text,
        idioma: bool.parse(_idiomaController.text),
        pregunta1: _pregunta1Controller.text,
        pregunta2: _pregunta2Controller.text,
        pregunta3: _pregunta3Controller.text,
        pregunta4: _pregunta4Controller.text,
        pregunta5: _pregunta5Controller.text,
        pregunta6: _pregunta6Controller.text,
        pregunta7: _pregunta7Controller.text,
        pregunta8: _pregunta8Controller.text,
        pregunta9: _pregunta9Controller.text,
        pregunta10: _pregunta10Controller.text,
        pregunta11: _pregunta11Controller.text,
        pregunta12: _pregunta12Controller.text,
        pregunta13: _pregunta13Controller.text,
        idEmpleados: _idEmpleadosController.text);
    print('ESTADO: ${_pregunta9Controller.text}');
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
    _gmailController.clear();
    // _idtrabajoController.clear();
    _nombrePaxController.clear();
    // _idiomaController.clear();
    _pregunta1Controller.clear();
    _pregunta2Controller.clear();
    _pregunta3Controller.clear();
    _pregunta4Controller.clear();
    _pregunta5Controller.clear();
    _pregunta6Controller.clear();
    _pregunta7Controller.clear();
    _pregunta8Controller.clear();
    _pregunta9Controller.clear();
    _pregunta10Controller.clear();
    _pregunta11Controller.clear();
    _pregunta12Controller.clear();
    _pregunta13Controller.clear();
    // _idEmpleadosController.clear();
  }
}
