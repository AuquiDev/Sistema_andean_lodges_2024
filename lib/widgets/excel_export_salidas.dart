// // ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

// import 'dart:io';
// import 'package:ausangate_op/models/model_t_salidas.dart';
// import 'package:ausangate_op/provider/provider_cache.dart';
// import 'package:ausangate_op/provider/provider_empleados.rol_sueldo.dart';
// import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
// import 'package:ausangate_op/provider/provider_t_productoapp.dart';
// import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
// import 'package:ausangate_op/utils/text_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../provider/provider_t_empleado.dart';

// class ExeclExportSalidas extends StatelessWidget {
//   const ExeclExportSalidas(
//       {super.key, required this.listaTproductos, required this.tituloEmpleado});
//   final List<TSalidasAppModel> listaTproductos;
//   final String tituloEmpleado;

//   @override
//   Widget build(BuildContext context) {
//     return ExcelBottonFile(
//       listaTproductos: listaTproductos,
//       tituloEmpleado: tituloEmpleado,
//     );
//   }
// }

// class ExcelBottonFile extends StatefulWidget {
//   const ExcelBottonFile(
//       {super.key, required this.listaTproductos, required this.tituloEmpleado});
//   final List<TSalidasAppModel> listaTproductos;
//   final String tituloEmpleado;

//   @override
//   _ExcelBottonFileState createState() => _ExcelBottonFileState();
// }

// class _ExcelBottonFileState extends State<ExcelBottonFile> {
//   bool isSaving = false;

//   @override
//   Widget build(BuildContext context) {
//     final listaProducto =
//         Provider.of<TProductosAppProvider>(context).listProductos;
//     final listaUbicacion =
//         Provider.of<TUbicacionAlmacenProvider>(context).listUbicacion;
//     final listaProveedor =
//         Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
//     final listaEmpleados =
//         Provider.of<TEmpleadoProvider>(context).listaEmpleados;
//     final listRolesSueldo =
//         Provider.of<TRolesSueldoProvider>(context).listRolesSueldo;
//     final providerCache = Provider.of<UsuarioProvider>(context);

//     return isSaving
//         ? const SizedBox(
//             width: 30,
//             height: 30,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//             ))
//         : OutlinedButton.icon(
//             icon: const Icon(
//               Icons.domain_verification_rounded,
//               size: 18,
//             ),
//             label: const H2Text(
//               text: 'Excel',
//               fontSize: 15,
//             ),
//             onPressed: () async {
//               setState(() {
//                 isSaving = true;
//               });

//               // Simulación de guardado con un retraso de 2 segundos
//               await Future.delayed(const Duration(seconds: 2));

//               // Exporta los datos a Excel y abre el archivo
//               final excel = Excel.createExcel();
//               final sheet = excel['Sheet1'];
//               sheet.setDefaultColumnWidth(16);
//               sheet.setColumnAutoFit(2);
//               // Crear un estilo para los encabezados
//               CellStyle(
//                 backgroundColorHex: 'FFFF00', // Fondo amarillo
//                 fontSize: 10,
//                 bold: true,
//                 horizontalAlign: HorizontalAlign.Center, // Alineación centrada
//                 verticalAlign: VerticalAlign.Center, // Alineación centrada
//                 textWrapping: TextWrapping.WrapText, // Ajuste de texto
                
//               );
            
//               // Agregar la lista de datos a la hoja de Excel
//               sheet.appendRow([
//                 const TextCellValue('#'),
//                 const TextCellValue('Producto'),
//                 const TextCellValue('Almacén'),
//                 const TextCellValue('Grupo'),
//                 const TextCellValue('Empleado'),
//                 const TextCellValue('Función'),
//                 const TextCellValue('Fecha Salida'),
//                 const TextCellValue('Cantidad'),
//                 const TextCellValue('Precio Salida'),
//                 const TextCellValue('Costo total'),
//                 const TextCellValue('Descripción'),
//                 const TextCellValue('fecha Modíficación'),
//               ]);
//               // Crear una lista de listas con los datos de Producto
//               for (var e in widget.listaTproductos) {
//                 TProductosAppModel obtenerProducto(String idProducto) {
//                   for (var data in listaProducto) {
//                     if (data.id == idProducto) {
//                       return data;
//                     }
//                   }
//                   return TProductosAppModel(
//                       idProveedor: '',
//                       nombreProducto: 'Producto eliminado',
//                       marcaProducto: '',
//                       unidMedida: '',
//                       precioUnd: 0,
//                       unidMedidaSalida: '',
//                       precioUnidadSalidaGrupo: 0,
//                       descripcionUbicDetll: '',
//                       tipoProducto: '',
//                       fechaVencimiento: DateTime.now(),
//                       estado: false,
//                       id: '',
//                       idCategoria: '',
//                       idUbicacion: '');
//                 }

//                 final p = obtenerProducto(e.idProducto);
//                 double calcularTotal() {
//                   double total = 0;
//                   for (var data in widget.listaTproductos) {
//                     TProductosAppModel p = obtenerProducto(data.idProducto);
//                     total += (data.cantidadSalida * p.precioUnidadSalidaGrupo);
//                   }
//                   return total;
//                 }

//                 double total = calcularTotal();
//                 providerCache.updateTotal(total);
                
//                 TUbicacionAlmacenModel obtenerUbicacion(String idUbicacion) {
//                   for (var data in listaUbicacion) {
//                     if (data.id == p.idUbicacion) {
//                       return data;
//                     }
//                   }
//                   return TUbicacionAlmacenModel(
//                       nombreUbicacion: '', descripcionUbicacion: '');
//                 }

//                 final u = obtenerUbicacion(p.idUbicacion);
//                 TDetalleTrabajoModel obtenerDetalleTrabajo(String idTrabajo) {
//                   for (var data in listaProveedor) {
//                     if (data.id == idTrabajo) {
//                       return data;
//                     }
//                   }
//                   return TDetalleTrabajoModel(
//                       codigoGrupo: '',
//                       idRestriccionAlimentos: '',
//                       idCantidadPaxguia: '',
//                       idItinerariodiasnoches: '',
//                       idTipogasto: '',
//                       fechaInicio: DateTime.now(),
//                       fechaFin: DateTime.now(),
//                       descripcion: '',
//                       costoAsociados: 0);
//                 }

//                 final v = obtenerDetalleTrabajo(e.idTrabajo);
//                 TEmpleadoModel obtenerEmpleado(String idEmpleado) {
//                   for (var data in listaEmpleados) {
//                     if (data.id == idEmpleado) {
//                       return data;
//                     }
//                   }
//                   return TEmpleadoModel(
//                       estado: false,
//                       idRolesSueldoEmpleados: '',
//                       nombre: '',
//                       apellidoPaterno: '',
//                       apellidoMaterno: '',
//                       sexo: '',
//                       direccionResidencia: '',
//                       lugarNacimiento: '',
//                       fechaNacimiento: DateTime.now(),
//                       correoElectronico: '',
//                       nivelEscolaridad: '',
//                       estadoCivil: '',
//                       modalidadLaboral: '',
//                       cedula: 0,
//                       cuentaBancaria: '',
//                       telefono: '',
//                       contrasena: '',
//                       rol: '');
//                 }

//                 final m = obtenerEmpleado(e.idEmpleado);
//                 String obtenerRolFuncion(String idrolesEmpleados) {
//                   for (var data in listRolesSueldo) {
//                     if (data.id == idrolesEmpleados) {
//                       return data.cargoPuesto;
//                     }
//                   }
//                   return '';
//                 }

//                 final r = obtenerRolFuncion(m.idRolesSueldoEmpleados);

//                 final index = widget.listaTproductos.indexOf(e);
//                 int contador = index + 1;

//                 sheet.appendRow([
//                   TextCellValue(contador.toString()),
//                   TextCellValue(
//                       '${p.nombreProducto} * ${p.marcaProducto} * ${p.unidMedidaSalida}'),
//                   TextCellValue(u.nombreUbicacion),
//                   TextCellValue(v.codigoGrupo),
//                   TextCellValue(
//                       "${m.nombre} ${m.apellidoPaterno} ${m.apellidoMaterno}"),
//                   TextCellValue(r),
//                   TextCellValue(e.created.toString()),
//                   TextCellValue(e.cantidadSalida.toString()),
//                   TextCellValue(p.precioUnidadSalidaGrupo.toString()),
//                   TextCellValue((e.cantidadSalida * p.precioUnidadSalidaGrupo)
//                       .toStringAsFixed(2)
//                       .toString()),
//                   TextCellValue(e.descripcionSalida.toString()),
//                   TextCellValue(e.updated.toString()),
//                 ]);
//               }
//              sheet.appendRow([
//                  const TextCellValue('Valor Total (s/.):'),
//                    TextCellValue('${providerCache.total}'),
//               ]);
//               // Guardar el archivo Excel en el directorio de documentos de la aplicación
//               //   final fileBytes = excel.encode();
//               final List<int>? excelBytes = excel.encode();
//               Directory directory =
//                   await getApplicationDocumentsDirectory(); // Reemplaza con la ubicación deseada en el sistema de archivos
//               final excelFile = File(
//                   '${directory.path}/${widget.tituloEmpleado}.xlsx'); //CAMBIAR el nombre del archivo en funcion a codigo dias noches cocinero
//               excelFile.writeAsBytes(excelBytes!);
//               OpenFilex.open(excelFile.path);

//               // Mostrar un mensaje de éxito
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Archivo Excel exportado con éxito'),
//                 ),
//               );

//               // Actualiza la vista
//               setState(() {
//                 isSaving = false;
//               });

//               // Navega a la nueva página para mostrar los datos guardados
//             });
//   }
// }
