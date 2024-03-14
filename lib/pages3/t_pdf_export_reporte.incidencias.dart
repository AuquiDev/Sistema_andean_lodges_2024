// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
// import 'package:ausangate_op/models/model_t_empleado.dart';
// import 'package:ausangate_op/models/model_t_reporte_incidencias.dart';
// import 'package:ausangate_op/pages3/preguntas_pasajeros.dart';
// import 'package:ausangate_op/provider/provider_datacahe.dart';
// import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
// import 'package:ausangate_op/provider/provider_t_empleado.dart';
// import 'package:ausangate_op/utils/custom_text.dart';
// import 'package:ausangate_op/utils/format_fecha.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:provider/provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:html' as html;

// class PdfExportReporteIncidencias extends StatefulWidget {
//   const PdfExportReporteIncidencias(
//       {super.key, required this.listaTproductos, required this.tituloEmpleado});
//   final List<TReporteIncidenciasModel> listaTproductos;
//   final String tituloEmpleado;
//   @override
//   State<PdfExportReporteIncidencias> createState() => _PdfExportReporteIncidenciasState();
// }

// class _PdfExportReporteIncidenciasState extends State<PdfExportReporteIncidencias> {
//   bool isSaving = false;

//   @override
//   Widget build(BuildContext context) {
//     final isOffline = Provider.of<UsuarioProvider>(context).isOffline;

//     final listaGrupoAPi =   Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;


//     List<TDetalleTrabajoModel> listaGrupos =  listaGrupoAPi;

//     final listaUsuarioAPI = Provider.of<TEmpleadoProvider>(context).listaEmpleados;


//     List<TEmpleadoModel> listaUsuarios = listaUsuarioAPI;

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
//               const grisbordertable =
//                   PdfColor.fromInt(0xFFACA7A7); // Gris oscuro

//               pw.Document pdf = pw.Document();

//               //PAGINA lista de compras
//               pdf.addPage(pw.MultiPage(
//                 margin: const pw.EdgeInsets.all(20),
//                 maxPages: 200,
//                 pageFormat: PdfPageFormat.a4.copyWith( marginTop: 0, marginBottom: 30), // Aplica los márgenes
//                 build: (pw.Context context) {
//                   var textStyle =
//                       pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9);
//                   const edgeInsets =
//                       pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2);
//                   return [
//                     pw.Column(
//                       children: [
//                         titlePages(imagenBytes),
//                         ...widget.listaTproductos.map((e) {
//                           //METODO OBTENER EL CODIGOP DE GRUP{O}
//                           TDetalleTrabajoModel obtenerDetalleTrabajo(
//                               String idTrabajo) {
//                             for (var data in listaGrupos) {
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

//                           //METODO OBTENER EL CODIGOP DE GRUP{O}
//                           String obtenerGuia(
//                               String idEmpleados) {
//                             for (var data in listaUsuarios) {
//                               if (data.id == idEmpleados) {
//                                 return '${data.nombre} ${data.apellidoPaterno} ${data.apellidoMaterno}';
//                               }
//                             }
//                             return '';
//                           }

//                           final guia = obtenerGuia(e.idEmpleados);

//                           final index = widget.listaTproductos.indexOf(e);
//                           int contador = index + 1;

//                           return pw.Column(
//                             crossAxisAlignment: pw.CrossAxisAlignment.start,
//                             children: [
//                               pw.Table(
//                                   border: pw.TableBorder.all(
//                                       color: grisbordertable),
//                                   children: [
//                                     pw.TableRow(
//                                       children: [
//                                         pw.Center(
//                                             child: pw.Text('Grupo',
//                                                 style: textStyle)),
//                                         pw.Center(
//                                             child: pw.Text(
//                                                 'Nombre Personal',
//                                                 style: textStyle)),
                                       
//                                         pw.Center(
//                                           child: pw.Text('Detalles de Registro',
//                                               style: textStyle,
//                                               textAlign: pw.TextAlign.center),
//                                         ),
//                                       ],
//                                     ),
//                                     pw.TableRow(
//                                       children: [
//                                         pw.Container(
//                                           width: 40,
//                                           padding: edgeInsets,
//                                           child: pw.Center(
//                                             child: pw.Text(v.codigoGrupo,
//                                                 style: tableTextStyle()),
//                                           ),
//                                         ),
                                     
//                                         pw.Container(
//                                           width: 90,
//                                           padding: edgeInsets,
//                                           child: pw.Text(guia,
//                                               style: tableTextStyle()),
//                                         ),
//                                         pw.Container(
//                                           width: 140,
//                                           padding: edgeInsets,
//                                           child: pw.Column(
//                                               crossAxisAlignment:
//                                                   pw.CrossAxisAlignment.start,
//                                               children: [
//                                                 pw.Text(
//                                                     'F.Creación: ${formatFechaHoraNow(e.created!)}',
//                                                     style: tableTextStyle()),
//                                                 pw.SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 pw.Text(
//                                                     'F.Modifición: ${formatFechaHoraNow(e.updated!)}',
//                                                     style: tableTextStyle())
//                                               ]),
//                                         ),
//                                       ],
//                                     ),
//                                   ]),

                             
                             
//                               //PREGUNTA 01
//                               containerCuestions( pregunta: preguntasIncidencias[0],respuesta: e.pregunta1 ),
//                               //PREGUNTA 02
//                               containerCuestions( pregunta: preguntasIncidencias[1],respuesta: e.pregunta1 ),
//                               //PREGUNTA 03
//                              containerCuestions( pregunta: preguntasIncidencias[2],respuesta: e.pregunta1 ),
//                               //PREGUNTA 04
//                              containerCuestions( pregunta: preguntasIncidencias[3],respuesta: e.pregunta1 ),
//                               //PREGUNTA 05
//                              containerCuestions( pregunta: preguntasIncidencias[4],respuesta: e.pregunta1 ),
//                               //PREGUNTA 06
//                              containerCuestions( pregunta: preguntasIncidencias[5],respuesta: e.pregunta1 ),
//                               //PREGUNTA 07
//                               containerCuestions( pregunta: preguntasIncidencias[6],respuesta: e.pregunta1 ),
                              
//                             ],
//                           );
//                         }),
//                       ],
//                     )
//                   ];
//                 },

//                 footer: (context) {
//                   return fooTerPDF();
//                 },
//               ));

//               // Uint8List bytes = await pdf.save();
//               // Directory directory = await getApplicationDocumentsDirectory();
//               // File filePdf = File("${directory.path}/productos.pdf");
//               // filePdf.writeAsBytes(bytes);
//               // OpenFilex.open(filePdf.path);

//                final pdfBytes = Uint8List.fromList(await pdf.save());
//               final blob = html.Blob([pdfBytes]);
//               final url = html.Url.createObjectUrlFromBlob(blob);

//               html.AnchorElement(href: url)
//                 ..setAttribute("download", "report_incidencias.pdf")
//                 ..click();

//               html.Url.revokeObjectUrl(url);

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
//     const azulColor = PdfColor.fromInt(0xFF071568); // Azul
//     return pw.TextStyle(
//         fontSize: 9, fontWeight: pw.FontWeight.normal, color: azulColor);
//   }

//   pw.Widget containerCuestions({ String? pregunta, String? respuesta}) {
//      var textStyle =
//                       pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9);
//     const edgeInsets =
//                       pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2);
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Container(
//           padding: edgeInsets,
//           child: pw.Text(pregunta!,
//               style: textStyle),
//         ),
//         pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.start,
//           children: [
//             pw.Container(
//               padding: edgeInsets,
//               child: pw.Text('Respuesta :',
//                   style: tableTextStyle()),
//             ),
//             pw.Container(
//               padding: edgeInsets,
//               child: pw.Text(respuesta!, style: tableTextStyle()),
//             ),
//           ],
//         )
//       ],
//     );
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
//         mainAxisAlignment: pw.MainAxisAlignment.start,
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
//                 'REPORTE DE INCIDENTES',
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold,
//                   color: marronColor,
//                 ),
//               ),
//                 pw.Text(
//                 '${widget.listaTproductos.length} registros',
//                 style: const pw.TextStyle(
//                   fontSize: 9,
//                   color: marronColor,
//                 ),
//               ),
//                pw.Text(
//                 'Código: ${widget.tituloEmpleado}'.toUpperCase(),
//                 style: const pw.TextStyle(
//                   fontSize: 12,
//                   color: marronColor,
//                 ),
//               ),
//               pw.Text(
//                 formatFechaHoraNow(DateTime.now()),
//                 style: const pw.TextStyle(
//                   fontSize: 10,
//                   color: marronColor,
//                 ),
//               ),
             
            
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
