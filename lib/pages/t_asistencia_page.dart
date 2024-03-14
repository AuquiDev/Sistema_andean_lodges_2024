// ignore_for_file: avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'package:ausangate_op/pages/t_asistencia_editing.dart';
import 'package:ausangate_op/pages3/t_asistencia_listdata.dart';
import 'package:ausangate_op/provider/provider_t_asistencia.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FormularioAsistenciapage extends StatelessWidget {
  const FormularioAsistenciapage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    //Modo OFFLINE
    final listAsitencia = Provider.of<TAsistenciaProvider>(context).listAsistencia;

    final isSavingSerer = Provider.of<TAsistenciaProvider>(context).isSyncing;

    bool isavingProvider =  isSavingSerer;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ( size.height < 500)
          ? null
          : AppBar(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
              title: const H2Text(
              text: 'Gire la pantalla para ver la lista de asistencias.',
              fontSize: 10,
            )),
      body: SafeArea(
        bottom: false,
        child: Row(
          children: [
            //Las Condicionales que aplican aqui son para actulizar y redibujar el widget
            //ListAsistencia, => isavingProvider es un bolenao que se ativa al guardar oeditar un registro.
            //isOffline, es uan variable boleana que utilzia una lista local o del api
            isavingProvider
                ? Center(
                  child: size.width > 500
                        ? const Flexible(
                      flex: 1, child: Center(child: CircularProgressIndicator())) :  const SizedBox(),
                )
                : Container(
                    child: size.width > 500
                        ? ListAsistencia(
                            listAsitencia:
                                listAsitencia,
                          )
                        : const SizedBox(),
                  ),
            const FormularioAsistencia()
          ],
        ),
      ),
    );
  }
}
