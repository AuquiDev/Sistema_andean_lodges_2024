// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_null_comparison

import 'package:ausangate_op/models/model_t_asistencia.dart';
import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/provider/provider_t_asistencia.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/utils/buton_style.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/divider_custom.dart';
import 'package:ausangate_op/widgets/card_custom_formfield_shadow.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

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

  String idtrabajo = '';
  @override
  void initState() {
    if (widget.e != null) {
      _idempleadosController.text = widget.e!.idEmpleados;
      _idtrabajoController.text = widget.e!.idTrabajo;
      _horaEntradaController.text = widget.e!.horaEntrada.toString();
      _horaSalidaController.text = widget.e!.horaSalida.toString();
      _nombrePersonalController.text = widget.e!.nombrePersonal.toString();
      _actividadRolController.text = widget.e!.actividadRol.toString();
      _detallesController.text = widget.e!.detalles.toString();
      optionPersonal = widget.e!.actividadRol;
      idtrabajo = _idtrabajoController.text;
      print('Ediatr Entrada');
    }
    super.initState();
  }

  String optionPersonal = 'COCINERO'; // Idioma predeterminado: español

  @override
  Widget build(BuildContext context) {
    final isavingProvider = Provider.of<TAsistenciaProvider>(context).isSyncing;
    //LISTA GRUPOS ALMACÉN
    final listadetalletrabajo =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;

    listadetalletrabajo.sort((a, b) => a.created!.compareTo(b.created!));

    String obtenerDetalleTrabajo(String idTrabajo) {
      for (var data in listadetalletrabajo) {
        if (data.id == idTrabajo) {
          return data.codigoGrupo;
        }
      }
      return idtrabajo;
    }

    return GestureDetector(
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
            constraints: const BoxConstraints(maxWidth: 450),
            margin: const EdgeInsets.all(25),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        shetPage(listadetalletrabajo,
                            obtenerDetalleTrabajo(idtrabajo));
                      },
                      child: WidgetCircularAnimator(
                        size: 65,
                        innerColor: Colors.pinkAccent,
                        outerColor: Colors.pink,
                        outerAnimation: Curves.elasticInOut,
                        child: DelayedDisplay(
                          delay: const Duration(seconds: 1),
                          child: CircleAvatar(
                            backgroundColor: Colors.pink,
                            child: RippleAnimation(
                              color: const Color(0xFFE7E4D7),
                              delay: const Duration(milliseconds: 500),
                              repeat: idtrabajo.isEmpty ? true : false,
                              ripplesCount: 1,
                              minRadius: 50,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: H2Text(
                                    text: obtenerDetalleTrabajo(idtrabajo),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const H2Text(
                      text: 'Codígo.',
                      fontSize: 12,
                      color: Colors.pink,
                    ),
                  ],
                ),
                CardCustomFom(
                  label:
                      'Describe cualquier detalle relevante, como incidencias, sugerencias, observaciones sobre el personal, justificaciones, etc.',
                  child: TextFormField(
                    controller: _detallesController,
                    maxLength: 10000,
                    maxLines: 4,
                    decoration: decorationTextField(
                        hintText: 'Ingrese observación',
                        labelText: 'Campo opcional',
                        prefixIcon: const Icon(Icons.panorama_fisheye,
                            color: Colors.black45)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: isavingProvider
                        ? null
                        : () async {
                            editarEntrada();
                            _formKey.currentState!.save();
                             Navigator.pop(context);
                          },
                    child: SizedBox(
                        height: 40,
                        width: 250,
                        child: Center(
                            child: isavingProvider
                                ? const CircularProgressIndicator(
                                    color: Colors.pink,
                                  )
                                : const H2Text(
                                    text: 'Guardar',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> editarEntrada() async {
    await context.read<TAsistenciaProvider>().updateTAsistenciaProvider(
          id: widget.e!.id,
          idEmpleados: _idempleadosController.text,
          idTrabajo: _idtrabajoController.text,
          horaEntrada: DateTime.parse(_horaEntradaController.text),
          horaSalida: DateTime.parse(_horaSalidaController.text),
          nombrePersonal: _nombrePersonalController.text,
          actividadRol: _actividadRolController.text,
          detalles: _detallesController.text,
        );
    // snackBarButon('✅ Registro editado correctamente.');
   
  }

  // void snackBarButon(String e) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Row(
  //       children: [
  //         H2Text(
  //           text: e,
  //           maxLines: 3,
  //           fontSize: 12,
  //           color: Colors.white,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ],
  //     ),
  //   ));
  // }

  void shetPage(List<TDetalleTrabajoModel> listadetalletrabajo,
      String obtenerDetalleTrabajo) {
    showModalBottomSheet(
        constraints: BoxConstraints.loose(
            Size.fromHeight(MediaQuery.of(context).size.height * .50)),
        scrollControlDisabledMaxHeightRatio: BorderSide.strokeAlignOutside,
        useSafeArea: true,
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 550),
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DividerCustom(),
                const Center(
                  child: H2Text(
                    text: 'Seleccione el Codígo de Grupo.',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    // Calcular el número de columnas en función del ancho disponible
                    int crossAxisCount = (constraints.maxWidth / 80).floor();
                    // Puedes ajustar el valor 100 según tus necesidades
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          childAspectRatio: 2),
                      itemCount: listadetalletrabajo.length,
                      itemBuilder: (BuildContext context, int index) {
                        final t = listadetalletrabajo.reversed.toList()[index];
                        return OutlinedButton(
                          style: buttonStyle2(),
                          onPressed: () {
                            idtrabajo = t.id!;
                            obtenerDetalleTrabajo;
                            // obtenerDetalleTrabajo(idtrabajo);
                            _idtrabajoController.text = t.id!;

                            // obtenerDetalleTrabajo(
                            //     _idtrabajoController
                            //         .text);
                            print(t.codigoGrupo);
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: FittedBox(
                            child: H2Text(
                              text: t.codigoGrupo,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: idtrabajo == t.id
                                  ? const Color(0xFFB44E00)
                                  : Colors.black,
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
  }
}
