import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/pages/productos_details.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/utils/formatear_numero.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';

class CustomCardProducto extends StatelessWidget {
  const CustomCardProducto({
    super.key,
    required this.e,
  });

  final ViewInventarioGeneralProductosModel e;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => DetailsProductos(e: e)));
        showWebDialog(context);
      },
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment
                          .topLeft, // Punto de inicio superior izquierdo
                      end:
                          Alignment.bottomRight, // Punto final inferior derecho
                      stops: [
                        0.0,
                        0.25,
                        0.5,
                        0.75,
                        1.0
                      ], // Ubicaciones de color personalizadas

                      // center: Alignment.center,
                      // radius: 1.7,
                      colors: [
                        Color(0xFF301F15), // Tonos más oscuros
                        Color(0xFF492E1D),
                        Color(0xFF603D29),
                        Color(0xFF7D5740),
                        Color(0xFF876443),
                      ],
                    ),
                  ),
                  width: constraints.maxWidth * .98,
                  height: constraints.maxHeight * 0.55,
                  child: Image.network(
                    // ignore: unnecessary_null_comparison, unnecessary_type_check
                    (e.imagen != null && e.imagen is String &&
                            e.imagen.isNotEmpty)
                        ? 'https://planet-broken.pockethost.io/api/files/${e.collectionId}/${e.id}/${e.imagen}'
                        : 'https://via.placeholder.com/300',
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/img/andeanlodges.png',
                        height: 150,
                      ); // Widget a mostrar si hay un error al cargar la imagen
                    },
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  top: 3,
                  left: 3,
                  child: Container(
                    // height: 55,
                    width: 45,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: H2Text(
                            text: formatearNumero(e.stock).toString(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: getColorStock(e),
                          ),
                        ),
                        const H2Text(
                          text: 'Stock',
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: constraints.maxHeight *
                  0.35, // Altura de la imagen: 70% del espacio disponible
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2Text(
                    text: e.producto,
                    fontSize: 12,
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H2Text(
                              text: e.nombreUbicacion,
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                            H2Text(
                              text: e.fechaVencimiento!.year == 1998
                                  ? ''
                                  : 'F.V.: ${formatFecha(e.fechaVencimiento!)}',
                              fontSize: 10,
                              color: getColorfechav(e),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
            ),
          ],
        );
      }),
    );
  }

  void showWebDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [DetailsProductos(e: e)],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const H2Text(
                  text: 'Cerrar',
                  fontSize: 14,
                  color: Colors.blue,
                ))
          ],
        );
      },
    );
  }
}

Color getColorBasedOnStockAndExpiration(ViewInventarioGeneralProductosModel e) {
  // Si el stock está agotado o la fecha de vencimiento ha pasado
  if (e.stock == 0 ||
      (e.fechaVencimiento != null &&
          e.fechaVencimiento!.isBefore(DateTime.now()))) {
    return Colors.red.withOpacity(
        0.3); // Color más pronunciado para stock agotado o producto vencido
  }

  // Si el stock es menor a 10 o la fecha de vencimiento está próxima
  else if (e.stock < 10 ||
      (e.fechaVencimiento != null &&
          e.fechaVencimiento!.difference(DateTime.now()).inDays <= 7)) {
    return Colors.orange.withOpacity(
        0.2); // Color más pronunciado para stock bajo o producto próximo a vencer/agotar
  }

  // En cualquier otro caso
  return Colors.white; // Color predeterminado
}

Color getColorStock(ViewInventarioGeneralProductosModel e) {
  double stockTotal = e.stock;

  if (stockTotal <= 0) {
    return Colors.red.withOpacity(0.9); // Agotado
  } else if (stockTotal > 0 && stockTotal <= 5) {
    return const Color(0xFF904F08); // Pocas existencias (1-5) Und.
  } else if (stockTotal > 5 && stockTotal <= 10) {
    return const Color(0xFF104E94); // Existencias bajas (6-10) Und.
  } else {
    return Colors.black; // Existencias adecuadas
  }
}

Color getColorfechav(ViewInventarioGeneralProductosModel e) {
  if (e.fechaVencimiento != null) {
    DateTime now = DateTime.now();
    DateTime startOfMonthNextMonth = DateTime(now.year, now.month + 2, 1);
    DateTime startOfMonthThisMonth = DateTime(now.year, now.month, 1);

    if (e.fechaVencimiento!.isBefore(now)) {
      return Colors.red.withOpacity(0.9); // Vencido
    } else if (e.fechaVencimiento!.isAtSameMomentAs(startOfMonthThisMonth)) {
      return Colors.blue; // Por vencer este mes
    } else if (e.fechaVencimiento!.isAtSameMomentAs(startOfMonthNextMonth)) {
      return const Color.fromARGB(255, 9, 66, 112); // Por vencer el próximo mes
    }
  }

  return Colors.black; // No vencido
}
