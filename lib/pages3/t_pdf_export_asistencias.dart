// // ignore_for_file: use_build_context_synchronously



// import 'package:ausangate_op/models/model_t_asistencia.dart';
// import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
// import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
// import 'package:ausangate_op/utils/custom_text.dart';
// import 'package:ausangate_op/utils/format_fecha.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:provider/provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:html' as html;

// class PDFExportAsistencia extends StatefulWidget {
//   const PDFExportAsistencia({super.key, required this.listaTproductos, required this.tituloEmpleado});
//   final List<TAsistenciaModel> listaTproductos;
//   final String tituloEmpleado;
//   @override
//   State<PDFExportAsistencia> createState() => _PDFExportAsistenciaState();
// }

// class _PDFExportAsistenciaState extends State<PDFExportAsistencia> {
//   bool isSaving = false;

  
//   @override
//   Widget build(BuildContext context) {
//     final listaProveedor = Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;
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
//                           pw.Center(child: pw.Text('Nombre Personal', style: textStyle)),
//                           pw.Center(child: pw.Text('Actividad/rol', style: textStyle)),
//                           pw.Center(child: pw.Text('Grupo', style: textStyle)),
//                           pw.Center(child: pw.Text('Hora entrada', style: textStyle,textAlign: pw.TextAlign.center),),
//                           pw.Center(child: pw.Text('Hora Salida', style: textStyle,textAlign: pw.TextAlign.center),),
//                           pw.Center(child: pw.Text('Detalles', style: textStyle,textAlign: pw.TextAlign.center),),
//                           ],
//                         ),
//                         ...widget.listaTproductos.map((e) {

                         

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
//                                 width: 30,
//                                 padding: edgeInsets,
//                                 child: pw.Text(contador.toString(),
//                                     style: tableTextStyle()),
//                               ),
//                               pw.Container(
//                                 width: 110,
//                                 padding: edgeInsets,
//                                 child: pw.Text(e.nombrePersonal,
//                                     style: tableTextStyle()),
//                               ),
//                               pw.Container(
//                                 padding: edgeInsets,
//                                 width: 90.0,
//                                 child: pw.Text(e.actividadRol,
//                                     style: tableTextStyle()),
//                               ),

//                                pw.Container(
//                                 width: 50,
//                                 padding: edgeInsets,
//                                 child: pw.Center(child: pw.Text(v.codigoGrupo,
//                                     style: tableTextStyle()),),
//                               ),
//                               pw.Container(
//                                   padding: edgeInsets,
//                                   width: 120,
//                                   child: pw.Text(
//                                    formatFechaHoraNow(e.horaEntrada),
//                                     style: tableTextStyle(),
//                                   )),
//                               pw.Container(
//                                   padding: edgeInsets,
//                                   width: 120,
//                                   child: pw.Text(
//                                    formatFechaHoraNow(e.horaSalida!),
//                                     style: tableTextStyle(),
//                                   )),

//                               pw.Container(
//                                 padding: edgeInsets,
//                                 width: 160.0,
//                                 child: pw.Text(e.detalles ,
//                                     style: tableTextStyle(),maxLines: 50)),
                             
//                             ],
//                           );
//                         }),
                        
//                       ],
//                     ),
                    
//                     ],
//                    )
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
//                 ..setAttribute("download", "asistencias.pdf")
//                 ..click();

//               html.Url.revokeObjectUrl(url);

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
//                 'REPORTE DE ASISTENCIAS GRUPO ${widget.tituloEmpleado}',
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold,
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
