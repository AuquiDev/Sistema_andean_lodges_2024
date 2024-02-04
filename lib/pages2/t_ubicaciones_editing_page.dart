// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:ausangate_op/models/model_t_ubicacion_almacen.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/widgets/card_custom_formfield_shadow.dart';
import 'package:ausangate_op/models/model_t_ubicacion_almacen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UbicacionesForm extends StatefulWidget {
  const UbicacionesForm({
    super.key,
    this.e,
  });

  final TUbicacionAlmacenModel? e;

  @override
  State<UbicacionesForm> createState() => _UbicacionesFormState();
}

class _UbicacionesFormState extends State<UbicacionesForm> {
  final TextEditingController _nombreUbicacionController =
      TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String proveedor = '';
  String codigogrupo = '';

  var title = 'Crear nueva Ubicación';

  @override
  void initState() {
    if (widget.e != null) {
      _nombreUbicacionController.text = widget.e!.nombreUbicacion;
      _descripcionController.text = widget.e!.descripcionUbicacion;

      title = 'Editar Registro';
    } else {
      print('Crear nuevo');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    final ubicacionLoading =  Provider.of<TUbicacionAlmacenProvider>(context).isSyncing;
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
                  text: title.toUpperCase(),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.deepOrange,
                ),
                const H2Text(
                  text: 'Ubicaciones de Almacén',
                  fontSize: 10,
                  fontWeight: FontWeight.w200,
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
                  CardCustomFom(
                    label: 'Nombre de Ubicación',
                    child: TextFormField(
                      controller: _nombreUbicacionController,
                      decoration: decorationTextField(
                          hintText: 'campo obligatorio',
                          labelText: 'Ubicación de almacén',
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
                    label:
                        'Descripción:\n(Dirección, Responsable, Contacto, etc.)',
                    child: TextFormField(
                      controller: _descripcionController,
                      maxLength: 350,
                      maxLines: 4,
                      decoration: decorationTextField(
                          hintText: 'opcional',
                          labelText: 'Descripción de Ubicación',
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
                              } else {
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
    await context.read<TUbicacionAlmacenProvider>().updateTUbicacionesProvider(
          id: widget.e!.id,
          nombreUbicacion: _nombreUbicacionController.text,
          descripcionUbicacion: _descripcionController.text,
        );
    snackBarButon('✅ Registro editado correctamente.');
    Navigator.pop(context);
  }

  Future<void> guardarEntrada() async {
    await context.read<TUbicacionAlmacenProvider>().postTUbicacionesProvider(
          id: '',
          nombreUbicacion: _nombreUbicacionController.text,
          descripcionUbicacion: _descripcionController.text,
        );
    snackBarButon('✅ Registro guardado correctamente.');
    _clearn();
    Navigator.pop(context);
  }

  void _clearn() {
    _nombreUbicacionController.clear();
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


}
