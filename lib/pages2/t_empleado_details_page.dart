
// ignore_for_file: deprecated_member_use

import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsEmpleadospage extends StatelessWidget {
  const DetailsEmpleadospage({
    super.key,
    required this.e,
    required this.cargopuesto,
    required this.sueldoBase,
    required this.tipoMoneda,
    required this.tipoCalculoSueldo,
  });

  final TEmpleadoModel e;
  final String cargopuesto;
  final double sueldoBase;
  final String tipoMoneda;
  final String tipoCalculoSueldo;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H3Text(
                    text:
                        'Datos de Empleado:'
                            .toUpperCase(),
                    maxLines: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF06685E),
                  ),
                  H3Text(
                    text: '${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}',
                    maxLines: 10,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: DataTable(
                  headingRowHeight: 20,
                  dataRowHeight: 35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  columns: const [
                    DataColumn(label: Text('Campo')),
                    DataColumn(label: Text('Descripción')),
                  ],
                  rows: [
                     _dataRow('Estado de Cuenta', e.estado ? 'Activo' : 'Inactivo'),
                      _dataRow('Rol', e.rol),
                    _dataRow('IdRolEmpleado', e.idRolesSueldoEmpleados),
                    _dataRow('Cargo o puesto', cargopuesto),
                    _dataRow('Sueldo Base', "${sueldoBase.toStringAsFixed(2)} $tipoMoneda/$tipoCalculoSueldo"),
                    _dataRow('Nombre', e.nombre),
                    _dataRow('Apellido Paterno', e.apellidoPaterno),
                     _dataRow('Apellido Materno', e.apellidoMaterno),
                    _dataRow('', ''),
                    _dataRow('Género', e.sexo),
                    _dataRow('Dirección de Residencia', e.direccionResidencia),
                    _dataRow('Lugar de Nacimiento', e.lugarNacimiento),
                    _dataRow('Fecha de Nacimiento',formatFecha( e.fechaNacimiento!)),
                    _dataRow('Correo Electronico', e.correoElectronico),
                    _dataRow('Nivel de Escolaridad', e.nivelEscolaridad),
                    _dataRow('Estado Civil', e.estadoCivil),
                    _dataRow('Modalidad Laboral', e.modalidadLaboral),
                    _dataRow('cédula (DNI)', e.cedula.toString()),
                    _dataRow('Cuenta Bancaria', e.cuentaBancaria),
                   
                    DataRow(cells: [
                      const DataCell(H3Text(
                        text: 'imagen',
                        fontWeight: FontWeight.bold,
                      )),
                      DataCell(TextButton.icon(
                          onPressed: () {
                            if (e.imagen!.isNotEmpty) {
                              _launchURL(
                                  'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.imagen}');
                            } else {
                              _messageDialog(context);
                            }
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: e.imagen!.isNotEmpty
                              ? const H3Text(text: '')
                              : const H3Text(text: 'N/A'))),
                    ]),
                     DataRow(cells: [
                      const DataCell(H3Text(
                        text: 'Document CV',
                        fontWeight: FontWeight.bold,
                      )),
                      DataCell(TextButton.icon(
                          onPressed: () {
                            if (e.cvDocument!.isNotEmpty) {
                              _launchURL(
                                  'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.cvDocument}');
                            } else {
                              _messageDialog(context);
                            }
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: e.cvDocument!.isNotEmpty
                              ? const H3Text(text: '')
                              : const H3Text(text: 'N/A'))),
                    ]),
                    _dataRow('Telefono', e.telefono),
                    _dataRow('Contraseña', e.contrasena),
                   
                    _dataRow('', ''),
                    _dataRow('Creación', formatFechaHora(e.created!)),
                    _dataRow('ultima Modificación', formatFechaHora(e.updated!)),
                    _dataRow('collectionID', e.collectionId.toString()),
                     _dataRow('collectionName', e.collectionName.toString()),
                    
      
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  void _messageDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No hay documento disponible'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Método para abrir una URL
  Future<void> _launchURL(String url) async {
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  DataRow _dataRow(String campo, String description) {
    return DataRow(
      cells: [
        DataCell(H3Text(
          text: campo,
          fontWeight: FontWeight.bold,
        )),
        DataCell(H3Text(text: description)),
      ],
    );
  }
}
