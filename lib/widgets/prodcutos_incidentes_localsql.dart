// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'package:andean_manager/utils/custom_text.dart';
// import 'package:andean_manager/utils/format_fecha.dart';
// import 'package:ausangate_op/utils/text_custom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class PDfIncidentes extends StatefulWidget {
//   const PDfIncidentes({super.key, required this.incidencias, required this.title, });
//   final List<String> incidencias;
//   final String title;
//   @override
//   State<PDfIncidentes> createState() => _PDfIncidentesState();
// }

// class _PDfIncidentesState extends State<PDfIncidentes> {
//   bool isSaving = false;

  
//   @override
//   Widget build(BuildContext context) {
//     return isSaving
//         ? const SizedBox(
//             width: 30,
//             height: 30,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//             ))
//         : OutlinedButton.icon(
//             icon: const Icon(
//               Icons.download,
//               size: 18,
//             ),
//             label: const H2Text(
//               text: 'report',
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

//               pw.Document pdf = pw.Document();


//               //PAGINA lista de compras
//               pdf.addPage(pw.MultiPage(
//                 margin: const pw.EdgeInsets.all(20),
//                 maxPages: 200,
//                 pageFormat: PdfPageFormat.a4.copyWith(
//                     marginTop: 0, marginBottom: 30), // Aplica los márgenes
//                 build: (pw.Context context) {
//                   const edgeInsets = pw.EdgeInsets.symmetric( horizontal: 5, vertical: 2);
//                   return [
//                    pw.Column(
//                     children: [
                      
//                       titlePages(imagenBytes),
//                       ...widget.incidencias.map((e) {
//                           final index = widget.incidencias.indexOf(e);
//                           int contador = index + 1;
//                           return pw.Row(
//                             children: [
//                               pw.Container(
//                                 width: 30,
//                                 height: 15,
//                                 padding: edgeInsets,
//                                 child: pw.Text(contador.toString(),
//                                     style: tableTextStyle()),
//                               ),
//                               pw.Text(e,style: tableTextStyle()),
                           
//                             ],
//                           );
//                         }).toList(),
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
//                 'Reporte de Incidencias: Modo Offline',
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
//                 '${widget.title} "Productos" almacenados localmente.',
//                 style: const pw.TextStyle(
//                   fontSize: 8,
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
