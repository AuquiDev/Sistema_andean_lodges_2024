import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/pages/tabla_source.dart';
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
        return Card(
          surfaceTintColor: Colors.white,
          elevation: 10,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(1),
                    width: constraints.maxWidth * .98,
                    height: constraints.maxHeight * 0.6,
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
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration:  BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          const H2Text(
                            text: 'Stock: ',
                            fontSize: 10,
                            maxLines: 2,
                            fontWeight: FontWeight.w600,
                          ),
                          H2Text(
                            text: formatearNumero(e.stock).toString(),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: getColorStock(e),
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
                margin: const EdgeInsets.symmetric(horizontal: 7),
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
          ),
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
            children:[
              DetailsProductos(e: e)
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const H2Text(text: 'Cerrar',fontSize: 14, ))
        ],
        
        );
        
      },
    );
  }
}