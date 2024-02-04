// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'package:andean_manager/models/model_t_detalle_trabajos.dart';
// import 'package:andean_manager/models/model_t_empleado.dart';
// import 'package:andean_manager/models/model_t_productos_app.dart';
// import 'package:andean_manager/models/model_t_salidas.dart';
// import 'package:andean_manager/models/model_t_ubicacion_almacen.dart';
// import 'package:andean_manager/provider/provider_datacahe.dart';
// import 'package:andean_manager/provider/provider_empleados.rol_sueldo.dart';
// import 'package:andean_manager/provider/provider_t_detalle_trabajo.dart';
// import 'package:andean_manager/provider/provider_t_empleado.dart';
// import 'package:andean_manager/provider/provider_t_productoapp.dart';
// import 'package:andean_manager/provider/provider_t_ubicacion_almacen.dart';
// import 'package:andean_manager/utils/custom_text.dart';
// import 'package:andean_manager/utils/format_fecha.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:provider/provider.dart';

// class PDfExportSalidasFilter extends StatefulWidget {
//   const PDfExportSalidasFilter({super.key, required this.listaTproductos, required this.tituloEmpleado});
//   final List<TSalidasAppModel> listaTproductos;
//   final String tituloEmpleado;
//   @override
//   State<PDfExportSalidasFilter> createState() => _PDfExportSalidasFilterState();
// }

// class _PDfExportSalidasFilterState extends State<PDfExportSalidasFilter> {
//   bool isSaving = false;

  
//   @override
//   Widget build(BuildContext context) {
//     final listaProducto = Provider.of<TProductosAppProvider>(context).listProductos;
//     final listaUbicacion = Provider.of<TUbicacionAlmacenProvider>(context).listUbicacion;
//     final listaProveedor = Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
//     final listaEmpleados = Provider.of<TEmpleadoProvider>(context).listaEmpleados;
//     final listRolesSueldo = Provider.of<TRolesSueldoProvider>(context).listRolesSueldo;
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
//               Icons.print_rounded,
//               size: 18,
//             ),
//             label: const H2Text(
//               text: 'pdf',
//               fontSize: 15,
//             ),
//             onPressed: () async {
//               setState(() {
//                 isSaving = true;
//               });
//               // Simulación de guardado con un retraso de 2 segundos
//               await Future.delayed(const Duration(seconds: 2));

//               //PDF Generate
//               ByteData byteData =
//                   await rootBundle.load('assets/img/andeanlodges.png');
//               Uint8List imagenBytes = byteData.buffer.asUint8List();
//               const grisbordertable =  PdfColor.fromInt(0xFFACA7A7); // Gris oscuro

//               pw.Document pdf = pw.Document();


//               //PAGINA lista de compras
//               pdf.addPage(pw.MultiPage(
//                 margin: const pw.EdgeInsets.all(20),
//                 maxPages: 200,
//                 pageFormat: PdfPageFormat.a4.copyWith(
//                     marginTop: 0, marginBottom: 30), // Aplica los márgenes
//                 build: (pw.Context context) {
//                   var textStyle = pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold, fontSize: 10);
//                   const edgeInsets = pw.EdgeInsets.symmetric( horizontal: 5, vertical: 2);
//                   return [
//                    pw.Column(
//                     children: [
//                       titlePages(imagenBytes),
//                         pw.Table(
//                       border: pw.TableBorder.all(color: grisbordertable),
//                       children: [
//                         pw.TableRow(
//                           children: [
//                            pw.Center(child: pw.Text('Nro', style: textStyle)),
//                           pw.Center(child: pw.Text('Producto', style: textStyle)),
//                           pw.Center(child: pw.Text('Grupo', style: textStyle)),
//                           pw.Center(child: pw.Text('Entregado', style: textStyle)),
//                           pw.Center(child: pw.Text('Función', style: textStyle)),
//                           pw.Center(child: pw.Text('Almacén', style: textStyle)),
//                           pw.Center(child: pw.Text('Fecha Salida', style: textStyle,textAlign: pw.TextAlign.center),),
//                           pw.Center(child: pw.Text('Cantidad Salida', style: textStyle,textAlign: pw.TextAlign.center),),
//                           pw.Center(child: pw.Text('Precio Salida', style: textStyle,textAlign: pw.TextAlign.center),),
//                           pw.Center(child: pw.Text('Costo Total', style: textStyle, textAlign: pw.TextAlign.center),),
//                           ],
//                         ),
//                         ...widget.listaTproductos.map((e) {

//                           TProductosAppModel obtenerProducto(
//                               String idProducto) {
//                             for (var data in listaProducto) {
//                               if (data.id == idProducto) {
//                                 return data;
//                               }
//                             }
//                             return TProductosAppModel(
//                                 idProveedor: '',
//                                 nombreProducto: 'Producto eliminado',
//                                 marcaProducto: '',
//                                 unidMedida: '',
//                                 precioUnd: 0,
//                                 unidMedidaSalida: '',
//                                 precioUnidadSalidaGrupo: 0,
//                                 descripcionUbicDetll: '',
//                                 tipoProducto: '',
//                                 fechaVencimiento: DateTime.now(),
//                                 estado: false,
//                                 id: '',
//                                 idCategoria: '',
//                                 idUbicacion: '');
//                           }

//                           final p = obtenerProducto(e.idProducto);
//                           //OBTENER EL valor total de la lista
//                          double calcularTotal() {
//                           double total = 0;
//                           for (var data in widget.listaTproductos) {
//                             TProductosAppModel p = obtenerProducto(data.idProducto);
//                             total += (data.cantidadSalida * p.precioUnidadSalidaGrupo);
//                           }
//                           return total;
//                         }
                         
//                           double total = calcularTotal();
//                           providerCache.updateTotal(total);
//                           TUbicacionAlmacenModel obtenerUbicacion(
//                               String idUbicacion) {
//                             for (var data in listaUbicacion) {
//                               if (data.id == p.idUbicacion) {
//                                 return data;
//                               }
//                             }
//                             return TUbicacionAlmacenModel(
//                                 nombreUbicacion: '', descripcionUbicacion: '');
//                           }

//                           final u = obtenerUbicacion(p.idUbicacion);

//                           TDetalleTrabajoModel obtenerDetalleTrabajo(
//                               String idTrabajo) {
//                             for (var data in listaProveedor) {
//                               if (data.id == e.idTrabajo) {
//                                 return data;
//                               }
//                             }
//                             return TDetalleTrabajoModel(
//                                 codigoGrupo: '',
//                                 idRestriccionAlimentos: '',
//                                 idCantidadPaxguia: '',
//                                 idItinerariodiasnoches: '',
//                                 idTipogasto: '',
//                                 fechaInicio: DateTime.now(),
//                                 fechaFin: DateTime.now(),
//                                 descripcion: '',
//                                 costoAsociados: 0);
//                           }

//                           final v = obtenerDetalleTrabajo(e.idTrabajo);

//                           TEmpleadoModel obtenerEmpleado(String idEmpleado) {
//                             for (var data in listaEmpleados) {
//                               if (data.id == e.idEmpleado) {
//                                 return data;
//                               }
//                             }
//                             return TEmpleadoModel(
//                                 estado: false,
//                                 idRolesSueldoEmpleados: '',
//                                 nombre: '',
//                                 apellidoPaterno: '',
//                                 apellidoMaterno: '',
//                                 sexo: '',
//                                 direccionResidencia: '',
//                                 lugarNacimiento: '',
//                                 fechaNacimiento: DateTime.now(),
//                                 correoElectronico: '',
//                                 nivelEscolaridad: '',
//                                 estadoCivil: '',
//                                 modalidadLaboral: '',
//                                 cedula: 0,
//                                 cuentaBancaria: '',
//                                 telefono: '',
//                                 contrasena: '',
//                                 rol: '');
//                           }

//                           final m = obtenerEmpleado(e.idEmpleado);

//                           String obtenerRolFuncion(String idEmpleado) {
//                             for (var data in listRolesSueldo) {
//                               if (data.id == m.idRolesSueldoEmpleados) {
//                                 return data.cargoPuesto;
//                               }
//                             }
//                             return '';
//                           }

//                           final r = obtenerRolFuncion(e.idEmpleado);

//                           final index = widget.listaTproductos.indexOf(e);
//                           int contador = index + 1;

                         

//                           return pw.TableRow(
//                             verticalAlignment:
//                                 pw.TableCellVerticalAlignment.middle,
//                             decoration: const pw.BoxDecoration(
//                                 // color: e. == true ? rojoClaro : azulClaro,
//                                 ),
//                             children: [
//                               pw.Container(
//                                 width: 50,
//                                 padding: edgeInsets,
//                                 child: pw.Text(contador.toString(),
//                                     style: tableTextStyle()),
//                               ),
//                               pw.Container(
//                                 width: 150,
//                                 padding: edgeInsets,
//                                 child: pw.Text("${p.nombreProducto} * ${p.marcaProducto} * ${p.unidMedidaSalida}",
//                                     style: tableTextStyle()),
//                               ),
//                               pw.Container(
//                                 width: 80,
//                                 padding: edgeInsets,
//                                 child: pw.Center(child: pw.Text(v.codigoGrupo,
//                                     style: tableTextStyle()),),
//                               ),
//                               pw.Container(
//                                 padding: edgeInsets,
//                                 width: 90.0,
//                                 child: pw.Text("${m.nombre} ${m.apellidoPaterno} ${m.apellidoMaterno}",
//                                     style: tableTextStyle()),
//                               ),
//                                pw.Container(
//                                 padding: edgeInsets,
//                                 width: 90.0,
//                                 child: pw.Text("($r)",
//                                     style: tableTextStyle()),
//                               ),
//                                pw.Container(
//                                 padding: edgeInsets,
//                                 width: 90.0,
//                                 child: pw.Text("(${u.nombreUbicacion})",
//                                     style: tableTextStyle()),
//                               ),
//                               pw.Container(
//                                   padding: edgeInsets,
//                                   width: 80,
//                                   child: pw.Text(
//                                    formatFechaHora(e.created!),
//                                     style: tableTextStyle(),
//                                   )),
//                               pw.Container(
//                                 padding: edgeInsets,
//                                 width: 60.0,
//                                 child: pw.Text(e.cantidadSalida.toString(),
//                                     style: tableTextStyle(),)                              ),
//                               pw.Container(
//                                 padding: edgeInsets,
//                                 width: 60.0,
//                                 child: pw.Text(p.precioUnidadSalidaGrupo.toString(),
//                                     style: tableTextStyle(),)),
//                               pw.Container(
//                                 padding: edgeInsets,
//                                 width: 60.0,
//                                 child: pw.Text((e.cantidadSalida * p.precioUnidadSalidaGrupo).toStringAsFixed(2).toString(),
//                                     style: tableTextStyle(),)),
//                             ],
//                           );
//                         }).toList(),
                        
//                       ],
//                     ),
//                     pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 15),
//                     child:  pw.Row(
//                       children: [
//                           pw.Text(
//                             'Valor total: ',
//                             style: const pw.TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                           pw.Text(
//                           'S/. ${providerCache.total.toStringAsFixed(2)}',
//                           style: const pw.TextStyle(
//                             fontSize: 14,
//                           ),
//                          )
//                         ],
//                       )
//                     )
//                     ],
//                    )
//                   ];
//                 },
               
//                 footer: (context) {
//                   return fooTerPDF();
//                 },
//               ));

//               Uint8List bytes = await pdf.save();
//               Directory directory = await getApplicationDocumentsDirectory();
//               File filePdf = File("${directory.path}/productos.pdf");
//               filePdf.writeAsBytes(bytes);
//               OpenFilex.open(filePdf.path);
//               // print(directory.path);
//               // print(bytes);
//               // Mostrar un mensaje de éxito
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Archivo PDF exportado con éxito'),
//                 ),
//               );
//               setState(() {
//                 isSaving = false;
//               });
//             },
//           );
//   }

//   pw.TextStyle tableTextStyle() {
//     return pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal);
//   }

//   pw.Container fooTerPDF() {
//     const marronColor = PdfColor.fromInt(0xFF663300); // Marrón
//     return pw.Container(
//       alignment: pw.Alignment.center,
//       // margin: const pw.EdgeInsets.only(top: 10),
//       child: pw.Column(
//         children: [
//           pw.Divider(
//               color: marronColor, thickness: 3, height: 10), // Línea divisoria
//           // pw.SizedBox(height: 10),
//           pw.Text(
//             'Con el corazón en las montañas, construimos experiencias únicas para el mundo.',
//             style: const pw.TextStyle(
//                 fontSize: 9,
//                 color: marronColor), // Color gris oscuro personalizado
//           ),
//         ],
//       ),
//     );
//   }

//   pw.Widget titlePages(Uint8List imagenBytes) {
//     const marronColor = PdfColor.fromInt(0xFF663300); // Marrón
//     return pw.Container(
//       alignment: pw.Alignment.center,
//       margin: const pw.EdgeInsets.only(bottom: 10),
//       child: pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.center,
//         children: [
//           pw.Container(
//             width: 130,
//             child: pw.Column(
//               children: [
//                 pw.Image(
//                   pw.MemoryImage(imagenBytes),
//                 ),
//                 pw.Text('Área de Operaciones y Logística',
//                     style: pw.TextStyle(
//                       fontSize: 8, // Tamaño de fuente personalizable
//                       color: marronColor, // Color marrón
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                     textAlign: pw.TextAlign.center),
//                 pw.SizedBox(
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           pw.Container(
//             margin: const pw.EdgeInsets.symmetric(horizontal: 5),
//             width: 4, // Ancho muy pequeño para simular un divisor vertical
//             height: 60, // Altura igual a la altura de la imagen
//             color: marronColor, // Color marrón
//           ),
//           pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text(
//                 'HISTORIAL DE SALIDAS',
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold,
//                   color: marronColor,
//                 ),
//               ),
//               pw.Text(
//                 formatFechaHoraNow(DateTime.now()),
//                 style: const pw.TextStyle(
//                   fontSize: 12,
//                   color: marronColor,
//                 ),
//               ),
//               pw.Text(
//                 'Código: ${widget.tituloEmpleado}',
//                 style: const pw.TextStyle(
//                   fontSize: 12,
//                   color: marronColor,
//                 ),
//               ),
//                pw.Text(
//                     '${widget.listaTproductos.length} registros',
//                     style: const pw.TextStyle(
//                       fontSize: 9,
//                       color: marronColor,
//                     ),
//                   ),
             
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
