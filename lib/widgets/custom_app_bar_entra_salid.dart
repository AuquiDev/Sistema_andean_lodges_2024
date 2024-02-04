
import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';

class CustomAppBarPRoductos extends StatelessWidget {
  const CustomAppBarPRoductos(
      {super.key,
      required this.categoria,
      required this.ubicacion,
      required this.precio,
      required this.undMedida,
      required this.stockList,
      required this.producto});

  final String categoria;
  final String ubicacion;
  final String precio;
  final String undMedida;
  // final String stock;
  final TProductosAppModel producto;
  final List<dynamic> stockList;
  @override
  Widget build(BuildContext context) {
    double stock = stockList[0];
    double totalEntrdas = stockList[1];
    double totalSalidas = stockList[2];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const H2Text(
                          text: 'Almacén:',
                          fontWeight: FontWeight.w200,
                          fontSize: 10,
                        ),
                        H2Text(
                          text: ubicacion,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                     H2Text(
                      text: '\nStock en ${producto.unidMedida}',
                      fontWeight: FontWeight.w300,
                      fontSize: 9,
                      maxLines: 2,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(100, 38),
                          // maximumSize: const Size(110, 38),
                          padding: const EdgeInsets.all(3),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          )),
                      onPressed: null,
                      child: Column(
                        children: [
                          const H2Text(
                            text: 'Existencias',
                            fontWeight: FontWeight.w400,
                            fontSize: 9,
                            color: Colors.indigo,
                          ),
                          H2Text(
                            text: stock.toString(),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: double.parse(stock.toString()) > 0
                                ? Colors.black
                                : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const H2Text(
                          text: 'Precio Compra:',
                          fontWeight: FontWeight.w200,
                          fontSize: 9,
                        ),
                        H2Text(
                          text: 'S/.${producto.precioUnd}',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const H2Text(
                          text: 'Undad de Compra',
                          fontWeight: FontWeight.w200,
                          fontSize: 9,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        Center(
                          child: H2Text(
                            text: producto.unidMedida,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(110, 38),
                          // maximumSize: const Size(110, 38),
                          padding: const EdgeInsets.all(3),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          )),
                      onPressed: null,
                      child: Column(
                        children: [
                          const H2Text(
                            text: 'Total Entradas',
                            fontWeight: FontWeight.w400,
                            fontSize: 9,
                            color: Colors.indigo,
                          ),
                          H2Text(
                            text: totalEntrdas.toString(),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const H2Text(
                          text: 'Precio Salida:',
                          fontWeight: FontWeight.w200,
                          fontSize: 9,
                        ),
                        H2Text(
                          text: 'S/.$precio',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const H2Text(
                          text: 'Distribución salidas',
                          fontWeight: FontWeight.w200,
                          fontSize: 9,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        H2Text(
                          text: undMedida,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(100, 38),
                          // maximumSize: const Size(110, 38),
                          padding: const EdgeInsets.all(3),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          )),
                      onPressed: null,
                      child: Column(
                        children: [
                          const H2Text(
                            text: 'Total Salidas',
                            fontWeight: FontWeight.w400,
                            fontSize: 9,
                            color: Colors.indigo,
                          ),
                          H2Text(
                            text: totalSalidas.toString(),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
