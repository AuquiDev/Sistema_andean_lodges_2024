// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/provider/provider_t_det.itinerario.dart';
import 'package:ausangate_op/provider/provider_t_det.restricciones.dart';
import 'package:ausangate_op/provider/provider_t_det.tipo_gasto.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/provider/provider_t_detcand_paxguia.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/utils/parse_string_a_double.dart';
import 'package:ausangate_op/widgets/card_custom_formfield_shadow.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GruposEditingPage extends StatefulWidget {
  const GruposEditingPage({
    super.key,
    this.e,
  });

  final TDetalleTrabajoModel? e;

  @override
  State<GruposEditingPage> createState() => _GruposEditingPageState();
}

class _GruposEditingPageState extends State<GruposEditingPage> {
  final TextEditingController _codigoGrupoController = TextEditingController();
  final TextEditingController _idRestriccionesController =
      TextEditingController();
  final TextEditingController _idCatidadPaxGuiaController =
      TextEditingController();
  final TextEditingController _idItinerarioController = TextEditingController();
  final TextEditingController _idTipoGastoController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _costosAsociadosController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String paxguia = '';
  String itinerario = '';
  String tipoGasto = '';
  String restriccion = '';
  List<DateTime?> _selectedDates = [];
  var title = 'Crear nuevo Grupo';

  @override
  void initState() {
    if (widget.e != null) {
      _codigoGrupoController.text = widget.e!.codigoGrupo;
      _idRestriccionesController.text = widget.e!.idRestriccionAlimentos;
      _idCatidadPaxGuiaController.text = widget.e!.idCantidadPaxguia;
      _idItinerarioController.text = widget.e!.idItinerariodiasnoches;
      _idTipoGastoController.text = widget.e!.idTipogasto;
      _fechaInicioController.text = widget.e!.fechaInicio.toString();
      _fechaFinController.text = widget.e!.fechaFin.toString();
      _descripcionController.text = widget.e!.descripcion;
      _costosAsociadosController.text = widget.e!.costoAsociados.toString();
      title = 'Editar Registro';
    } else {
      print('Crear nuevo');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ubicacionLoading = Provider.of<TDetalleTrabajoProvider>(context).isSyncing;
    final listaPaxGuia = Provider.of<TCantidadPaxGuiaProvider>(context).listapaxguias
      ..sort((a, b) => a.created!.compareTo(b.created!));

    final listaItinerario = Provider.of<TItinerarioProvider>(context).listItinerario.reversed.toList();
   
    final listaTipoGasto = Provider.of<TTipoGastoProvider>(context).listTipogasto
          ..sort((a, b) => a.nombreGasto.compareTo(b.nombreGasto),);
    final listaRestricciones =
        Provider.of<TRestriccionesProvider>(context).listaRestricciones;
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
            title: Column(
              children: [
                H2Text(
                  text: title.toUpperCase(),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.deepOrange,
                ),
                const H2Text(
                  text: 'Grupos confirmados',
                  fontSize: 10,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(maxWidth:600),
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  CardCustomFom(
                    label: 'Codígo de Grupo',
                    child: TextFormField(
                      controller: _codigoGrupoController,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'Codígo',
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
                   Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CardCustomFom(
                          label: 'Fecha de Inicio.',
                          child: TextFormField(
                            // enabled: false,
                            readOnly:
                                true, // Deshabilita la edición directa del texto
                            showCursor:
                                true, // Muestra el cursor al tocar el campo
                            controller: _fechaInicioController,
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Fecha salida',
                                prefixIcon: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.black45)),
                            onTap: () {
                              _pickDate(context);
                              // showrangeFecha('Por favor, seleccione el intervalo de tiempo que desee para su consulta, tal como se muestra en la imagen. Presione "OK" para continuar.');
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
                      ),
                      const SizedBox(width: 10,),
                      Flexible(
                        flex: 1,
                        child: CardCustomFom(
                          label: 'Fecha de Fin.',
                          child: TextFormField(
                            enabled: false,
                            readOnly:
                                true, // Deshabilita la edición directa del texto
                            showCursor:
                                true, // Muestra el cursor al tocar el campo
                            controller: _fechaFinController,
                            decoration: decorationTextField(
                                hintText: 'campo obligatorio',
                                labelText: 'Fecha Retorno',
                                prefixIcon: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.black45)),
                            onTap: null,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo obligatorio';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                   CardCustomFom(
                    label: 'Programa (dias/noches) :$itinerario',
                    child: TextFormField(
                      controller: _idItinerarioController,
                      readOnly: true,
                      showCursor: true,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'seleccione una opción',
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
                                    TextButton(
                                      style: _buttonStyle(),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 15),
                                        child: H2Text(
                                          text: 'Crear nuevo',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        padding: const EdgeInsets.only(top: 20),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 2.5,
                                                crossAxisCount: 3),
                                        itemCount: listaItinerario.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final e = listaItinerario[index];
                                          return ElevatedButton(
                                            style: _buttonStyle(),
                                            onPressed: () {
                                              _idItinerarioController.text =
                                                  e.id!;
                                              setState(() {
                                                itinerario = e.diasNoches;
                                              });
                                            },
                                            child: H2Text(
                                              text: e.diasNoches,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              color: Colors.black,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
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
                    label: '# Pasajeros y Guias :$paxguia',
                    child: TextFormField(
                      controller: _idCatidadPaxGuiaController,
                      readOnly:
                          true, // Deshabilita la edición directa del texto
                      showCursor: true, // Muestra el cursor al tocar el campo
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'seleccione una opción',
                          prefixIcon:
                              const Icon(Icons.people, color: Colors.black45)),
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
                                    TextButton(
                                      style: _buttonStyle(),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 15),
                                        child: H2Text(
                                          text: 'Crear nuevo',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        padding: const EdgeInsets.only(top: 20),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 2.5,
                                                crossAxisCount: 3),
                                        itemCount: listaPaxGuia.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final e = listaPaxGuia[index];
                                          return ElevatedButton(
                                            style: _buttonStyle(),
                                            onPressed: () {
                                              _idCatidadPaxGuiaController.text =
                                                  e.id!;
                                              setState(() {
                                                paxguia =
                                                    '\n${e.pax} y ${e.guia}';
                                              });
                                            },
                                            child: H2Text(
                                              text: '${e.pax} y ${e.guia}',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              color: Colors.black,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
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
                    label: 'Restricción de Alimentos: $restriccion',
                    child: TextFormField(
                      controller: _idRestriccionesController,
                      readOnly: true,
                      showCursor: true,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'seleccione una opción',
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
                                    TextButton(
                                      style: _buttonStyle(),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 15),
                                        child: H2Text(
                                          text: 'Crear nuevo',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        padding: const EdgeInsets.only(top: 20),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 2.5,
                                                crossAxisCount: 3),
                                        itemCount: listaRestricciones.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final e = listaRestricciones[index];
                                          return ElevatedButton(
                                            style: _buttonStyle(),
                                            onPressed: () {
                                              _idRestriccionesController.text =
                                                  e.id!;
                                              setState(() {
                                                restriccion =
                                                    e.nombreRestriccion;
                                              });
                                            },
                                            child: H2Text(
                                              text: e.nombreRestriccion,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              color: Colors.black,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
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
                    label: 'Tipo Gasto :$tipoGasto',
                    child: TextFormField(
                      controller: _idTipoGastoController,
                      readOnly: true,
                      showCursor: true,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'seleccione una opción',
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
                                    TextButton(
                                      style: _buttonStyle(),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 15),
                                        child: H2Text(
                                          text: 'Crear nuevo',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        padding: const EdgeInsets.only(top: 20),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 2.5,
                                                crossAxisCount: 3),
                                        itemCount: listaTipoGasto.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final e = listaTipoGasto[index];
                                          return ElevatedButton(
                                            style: _buttonStyle(),
                                            onPressed: () {
                                              _idTipoGastoController.text =
                                                  e.id!;
                                              setState(() {
                                                tipoGasto = e.nombreGasto;
                                              });
                                            },
                                            child: H2Text(
                                              text: e.nombreGasto,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              color: Colors.black,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
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
                    label:
                        'Descripción:\n(Detalles pasajero, servicio (privado/fijo), cambios de menú, etc.)',
                    child: TextFormField(
                      controller: _descripcionController,
                      maxLength: 350,
                      maxLines: 4,
                      decoration: decorationTextField(
                          hintText: 'opcional',
                          labelText: 'Descripción de grupo',
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
                    label: 'Costos asociados',
                    child: TextFormField(
                      controller: _costosAsociadosController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'Costos asociados',
                          prefixIcon: const Icon(Icons.panorama_fish_eye,
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

                 
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.deepOrange)),
                      onPressed: ubicacionLoading
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
                              }
                               else {
                                // Mostrar un SnackBar indicando el primer campo con error
                                completeForm();
                              }
                            },
                      child: SizedBox(
                          height: 60,
                          child: Center(
                              child: ubicacionLoading
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
     // Obtener la entrada existente
    final entradaexistente = widget.e!.codigoGrupo;
      // Verificar si el código ha cambiado// el resultado es  un Bool
    final codigoCambiado = entradaexistente != _codigoGrupoController.text;
    final codigoexiste = context.read<TDetalleTrabajoProvider>().listaDetallTrabajo.any(
        (e) => e.codigoGrupo == _codigoGrupoController.text,
      );

    if (codigoCambiado && codigoexiste) {
        // Notificar al usuario que el nuevo código de grupo ya existe
      showSialogButon('⚠️ El nuevo código de grupo ya existe. Por favor, elija otro.');
    } else {
       await context.read<TDetalleTrabajoProvider>().updateTdetalleTrabajoProvider(
          id: widget.e!.id,
          codigoGrupo: _codigoGrupoController.text,
          idRestriccionAlimentos: _idRestriccionesController.text,
          idCantidadPaxguia: _idCatidadPaxGuiaController.text,
          idTipogasto: _idTipoGastoController.text,
          idItinerariodiasnoches: _idItinerarioController.text,
          fechaInicio: DateTime.parse(_fechaInicioController.text),
          fechaFin:DateTime.parse(_fechaFinController.text),
          descripcion: _descripcionController.text,
          costoAsociados: convertirTextoADouble(_costosAsociadosController.text),
        );
    snackBarButon('✅ Registro editado correctamente.');
    Navigator.pop(context);
    }
   
  }

  Future<void> guardarEntrada() async {
    //Any devulve true
   final codigoexistente =   context.read<TDetalleTrabajoProvider>().listaDetallTrabajo.any((e) => 
        e.codigoGrupo == _codigoGrupoController.text
      );
      if(codigoexistente){
        showSialogButon('⚠️ El código de grupo ya existe. Por favor, elija otro.');
      } else{
         await context.read<TDetalleTrabajoProvider>().postTdetalleTrabajoProvider(
          id: '',
         codigoGrupo: _codigoGrupoController.text,
          idRestriccionAlimentos: _idRestriccionesController.text,
          idCantidadPaxguia: _idCatidadPaxGuiaController.text,
          idTipogasto: _idTipoGastoController.text,
          idItinerariodiasnoches: _idItinerarioController.text,
          fechaInicio: DateTime.parse(_fechaInicioController.text),
          fechaFin:DateTime.parse(_fechaFinController.text),
          descripcion: _descripcionController.text,
          costoAsociados: convertirTextoADouble(_costosAsociadosController.text),
        );
        snackBarButon('✅ Registro guardado correctamente.');
        _clearn();
        Navigator.pop(context);
      }
  }

void showSialogButon(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Codígo existente'),
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
  void _clearn() {
    _codigoGrupoController.clear();
    _idRestriccionesController.clear();
    _idCatidadPaxGuiaController.clear();
    _idTipoGastoController.clear();
    _idItinerarioController.clear();
    _fechaInicioController.clear();
    _fechaFinController.clear();
    _descripcionController.clear();
    _costosAsociadosController.clear();

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

  ButtonStyle _buttonStyle() {
    return const ButtonStyle(
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 0)),
      elevation: MaterialStatePropertyAll(7),
      visualDensity: VisualDensity.compact,
      backgroundColor: MaterialStatePropertyAll(Colors.white),
      overlayColor: MaterialStatePropertyAll(Colors.black),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    
    final List<DateTime?>? pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range),
      dialogSize: const Size(375, 400),
      value: _selectedDates,
    );

    if (pickedDates != null && pickedDates.length==2) {
      setState(() {
        _selectedDates = pickedDates;
        _fechaInicioController.text = pickedDates[0].toString(); 
        _fechaFinController.text = pickedDates[1].toString();
      });
    }
    else{
      showrangeFecha('Por favor, seleccione el intervalo de tiempo que desee para su consulta, tal como se muestra en la imagen. Presione "OK" para continuar.');
    }
  }
  void showrangeFecha(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccione un rango de fechas:'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/img/fecha_select_range.png'),
              Text(text),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickDate(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
