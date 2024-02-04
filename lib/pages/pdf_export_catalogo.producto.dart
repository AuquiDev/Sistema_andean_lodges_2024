// ignore_for_file: use_build_context_synchronously, avoid_web_libraries_in_flutter

import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/formatear_numero.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

class PdfExportCatalogoProductos extends StatefulWidget {
  const PdfExportCatalogoProductos({
    super.key,
    required this.sortedKey,
    required this.categoriasFilter,
     required this.title,
  });
  final List<dynamic> sortedKey;
  final Map<String, List<ViewInventarioGeneralProductosModel>> categoriasFilter;
  final String title;

  @override
  State<PdfExportCatalogoProductos> createState() =>
      _PdfExportCatalogoProductosState();
}

class _PdfExportCatalogoProductosState
    extends State<PdfExportCatalogoProductos> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final providerCache = Provider.of<UsuarioProvider>(context);

    return isSaving
        ? const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ))
        : OutlinedButton.icon(
            icon: const Icon(
              Icons.print_rounded,
              size: 18,
            ),
            label: const H2Text(
              text: 'pdf',
              fontSize: 15,
            ),
            onPressed: () async {
              setState(() {
                isSaving = true;
              });
              // Simulación de guardado con un retraso de 2 segundos
              await Future.delayed(const Duration(seconds: 2));

              //PDF Generate
              ByteData byteData =
                  await rootBundle.load('assets/img/andeanlodges.png');
              Uint8List imagenBytes = byteData.buffer.asUint8List();
              const grisbordertable =
                  PdfColor.fromInt(0xFFACA7A7); // Gris oscuro

              pw.Document pdf = pw.Document();

              //PAGINA lista de compras
              pdf.addPage(pw.MultiPage(
                orientation: pw.PageOrientation.landscape,
                margin: const pw.EdgeInsets.all(20),
                maxPages: 200,
                pageFormat: PdfPageFormat.a4.copyWith(
                    marginTop: 0, marginBottom: 30), // Aplica los márgenes
                build: (pw.Context context) {
                  var textStyle = pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10);
                  const edgeInsets =
                      pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2);
                  return [
                    titlePages(imagenBytes),
                    ...widget.sortedKey.map((e) {
                      final index = widget.sortedKey.indexOf(e);
                      final category = widget.sortedKey[index];
                      final productosPorCategoria =
                          widget.categoriasFilter[category];
                      //ORDENAMOS LA LISTA
                      productosPorCategoria!
                          .sort((a, b) => a.producto.compareTo(b.producto));

                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          //TITULO CATEGORIA
                          pw.Text(
                            '$category',
                            style:  pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold
                            ),
                          ),

                          pw.Table(
                            border: pw.TableBorder.all(color: grisbordertable),
                            children: [
                              pw.TableRow(
                                children: [
                                  pw.Center(
                                      child: pw.Text('#', style: textStyle)),
                                  pw.Center(
                                      child:
                                          pw.Text('Almacén', style: textStyle)),
                                  pw.Center(
                                      child: pw.Text('Producto',
                                          style: textStyle)),
                                 
                                  pw.Center(
                                      child:
                                          pw.Text('Stock', style: textStyle)),
                                  pw.Center(
                                      child: pw.Text('Fecha V.',
                                          style: textStyle)),
                                  pw.Center(
                                      child: pw.Text('Proveedor',
                                          style: textStyle)),
                                  pw.Center(
                                    child: pw.Text('Tipo',
                                        style: textStyle,
                                        textAlign: pw.TextAlign.center),
                                  ),
                                  pw.Center(
                                    child: pw.Text('Generales',
                                        style: textStyle,
                                        textAlign: pw.TextAlign.center),
                                  ),
                                   pw.Center(
                                    child: pw.Text('Precio Compra',
                                        style: textStyle,
                                        textAlign: pw.TextAlign.center),
                                  ),
                                ],
                              ),
                              ...productosPorCategoria.map((e) {
                                
                                //OBTENER EL valor total de la lista
                                double calcularTotal() {
                                  double total = 0;
                                  for (var data in productosPorCategoria) {
                                    total += (data.precioUnd);
                                  }
                                  return total;
                                }

                                double total = calcularTotal();

                                providerCache.updateTotal(total);

                                final index = productosPorCategoria.indexOf(e);

                                int contador = index + 1;

                                return pw.TableRow(
                                  verticalAlignment:
                                      pw.TableCellVerticalAlignment.middle,
                                  decoration: const pw.BoxDecoration(
                                      // color: e. == true ? rojoClaro : azulClaro,
                                      ),
                                  children: [
                                    //INDEX
                                    pw.Container(
                                      width: 30,
                                      padding: edgeInsets,
                                      child: pw.Text(contador.toString(),
                                          style: tableTextStyle()),
                                    ),
                                    //UBICACION
                                    pw.Container(
                                      padding: edgeInsets,
                                      width: 90.0,
                                      child: pw.Text(e.nombreUbicacion,
                                          style: tableTextStyle()),
                                    ),
                                    //PRODUCTO
                                    pw.Container(
                                      width: 200,
                                      padding: edgeInsets,
                                      child: pw.Text(e.producto,
                                          style: tableTextStyle()),
                                    ),
                                    
                                    //STOCK
                                    pw.Container(
                                      width: 80,
                                      padding: edgeInsets,
                                      child: pw.Center(
                                        child: pw.Text(formatearNumero(e.stock),
                                            style: pw.TextStyle(
                                                fontSize: 8,
                                                fontWeight:
                                                    pw.FontWeight.normal,
                                                color: getColorStock(e))),
                                      ),
                                    ),
                                    //FECHA VECIMIENTO
                                    pw.Container(
                                      padding: edgeInsets,
                                      width: 90.0,
                                      child: pw.Text(
                                          formatFecha(e.fechaVencimiento!),
                                          style: pw.TextStyle(
                                              fontSize: 8,
                                              fontWeight: pw.FontWeight.normal,
                                              color: getColorfechav(e))),
                                    ),
                                    //PROVEEDOR
                                    pw.Container(
                                      padding: edgeInsets,
                                      width: 100.0,
                                      child: pw.Text(e.nombreEmpresaProveedor,
                                          style: tableTextStyle()),
                                    ),
                                    //TIPO
                                    pw.Container(
                                        padding: edgeInsets,
                                        width: 100.0,
                                        child: pw.Text(
                                          e.tipoProducto.toString(),
                                          style: tableTextStyle(),
                                        )),
                                    //GENERALES
                                    pw.Container(
                                        padding: edgeInsets,
                                        width: 250.0,
                                        child: pw.Column(
                                          children: [
                                            pw.Text('Stock: ${e.estadoStock}',
                                                style: pw.TextStyle(
                                                    fontSize: 8,
                                                    fontWeight:
                                                        pw.FontWeight.normal,
                                                    color: getColorStock(e))),
                                            pw.Text('Fecha: ${e.estadoFecha}',
                                                style: pw.TextStyle(
                                                    fontSize: 8,
                                                    fontWeight:
                                                        pw.FontWeight.normal,
                                                    color: getColorfechav(e))),
                                          ],
                                        )),
                                    //PRECIO ENTRADA
                                    pw.Container(
                                        padding: edgeInsets,
                                        width: 60.0,
                                        child: pw.Text(
                                          's/. ${e.precioUnd}',
                                          style: tableTextStyle(),
                                        )),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                          //DETALLES REGISTRO
                          pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 5),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    'Valor total: ',
                                    style: const pw.TextStyle(
                                      fontSize: 8,
                                      color: PdfColor.fromInt(0xFF0D396B)
                                    ),
                                  ),
                                  pw.Text(
                                    'S/. ${providerCache.total.toStringAsFixed(2)}',
                                    style: const pw.TextStyle(
                                      fontSize: 8,
                                       color: PdfColor.fromInt(0xFF0D396B)
                                    ),
                                  )
                                ],
                              ))
                        ],
                      );
                    }).toList(),
                  ];
                },

                footer: (context) {
                  return fooTerPDF();
                },
              ));

              final pdfBytes = Uint8List.fromList(await pdf.save());
              final blob = html.Blob([pdfBytes]);
              final url = html.Url.createObjectUrlFromBlob(blob);

              html.AnchorElement(href: url)
                ..setAttribute("download", "document_inventario.pdf")
                ..click();

              html.Url.revokeObjectUrl(url);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Archivo PDF exportado con éxito'),
                ),
              );
              setState(() {
                isSaving = false;
              });
            },
          );
  }

  pw.TextStyle tableTextStyle() {
    return pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal);
  }

  pw.Container fooTerPDF() {
    const marronColor = PdfColor.fromInt(0xFF663300); // Marrón
    return pw.Container(
      alignment: pw.Alignment.center,
      // margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Column(
        children: [
          pw.Divider(
              color: marronColor, thickness: 3, height: 10), // Línea divisoria
          // pw.SizedBox(height: 10),
          pw.Text(
            'Con el corazón en las montañas, construimos experiencias únicas para el mundo.',
            style: const pw.TextStyle(
                fontSize: 9,
                color: marronColor), // Color gris oscuro personalizado
          ),
        ],
      ),
    );
  }

  pw.Widget titlePages(Uint8List imagenBytes) {
    const marronColor = PdfColor.fromInt(0xFF663300); // Marrón
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Container(
            width: 130,
            child: pw.Column(
              children: [
                pw.Image(
                  pw.MemoryImage(imagenBytes),
                ),
                pw.Text('Área de Operaciones y Logística',
                    style: pw.TextStyle(
                      fontSize: 8, // Tamaño de fuente personalizable
                      color: marronColor, // Color marrón
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center),
              ],
            ),
          ),
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 5),
            width: 2, // Ancho muy pequeño para simular un divisor vertical
            height: 40, // Altura igual a la altura de la imagen
            color: marronColor, // Color marrón
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                widget.title,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: marronColor,
                ),
              ),
              pw.Text(
                formatFechaHoraNow(DateTime.now()),
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: marronColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PdfColor getColorfechav(ViewInventarioGeneralProductosModel e) {
    if (e.fechaVencimiento != null) {
      DateTime now = DateTime.now();
      DateTime startOfMonthNextMonth = DateTime(now.year, now.month + 2, 1);
      DateTime startOfMonthThisMonth = DateTime(now.year, now.month, 1);

      if (e.fechaVencimiento!.isBefore(now)) {
        return const PdfColor.fromInt(0xFF941710); // Vencido
      } else if (e.fechaVencimiento!.isAtSameMomentAs(startOfMonthThisMonth)) {
        return const PdfColor.fromInt(0xFF0D396B); // Por vencer este mes
      } else if (e.fechaVencimiento!.isAtSameMomentAs(startOfMonthNextMonth)) {
        return const PdfColor.fromInt(0xFF09284B); // Por vencer el próximo mes
      }
    }

    return const PdfColor.fromInt(0xFF131212); // No vencido
  }

  PdfColor getColorStock(ViewInventarioGeneralProductosModel e) {
    double stockTotal = e.stock;

    if (stockTotal <= 0) {
      return const PdfColor.fromInt(0xFF941710); // Agotado
    } else if (stockTotal > 0 && stockTotal <= 5) {
      return const PdfColor.fromInt(0xFF904F08); // Pocas existencias (1-5) Und.
    } else if (stockTotal > 5 && stockTotal <= 10) {
      return const PdfColor.fromInt(
          0xFF104E94); // Existencias bajas (6-10) Und.
    } else {
      return const PdfColor.fromInt(0xFF131212); // Existencias adecuadas
    }
  }
}
