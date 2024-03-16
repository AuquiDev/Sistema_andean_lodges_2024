// ignore_for_file: avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'package:ausangate_op/pages3/t_asistencia_listdata.dart';
import 'package:ausangate_op/provider/provider_t_asistencia.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormularioAsistenciapage extends StatelessWidget {
  const FormularioAsistenciapage({super.key});

  @override
  Widget build(BuildContext context) {
    final listAsitencia =
        Provider.of<TAsistenciaProvider>(context).listAsistencia;
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: ListAsistencia(
            listAsitencia: listAsitencia,
          )),
    );
  }
}
