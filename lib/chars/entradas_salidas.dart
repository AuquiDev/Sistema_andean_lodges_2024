
import 'package:ausangate_op/models/model_t_entradas.dart';
import 'package:ausangate_op/models/model_t_salidas.dart';
import 'package:ausangate_op/provider/provider_t_entradas.dart';
import 'package:ausangate_op/provider/provider_t_salidas.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalidasChar extends StatelessWidget {
  const SalidasChar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TSalidasAppModel> listaSalidas =
        Provider.of<TSalidasAppProvider>(context).listSalidas;

    // Organize salidas by month and year
    Map<String, List<TSalidasAppModel>> salidasPorMesYAnio = {};

    for (TSalidasAppModel salida in listaSalidas) {
      if (salida.created != null) {
        String keyFecha = fechaFiltrada(salida.created!);
        if (!salidasPorMesYAnio.containsKey(keyFecha)) {
          salidasPorMesYAnio[keyFecha] = [];
        }
        salidasPorMesYAnio[keyFecha]!.add(salida);
      }
    }

    // Create a list of points for the chart
    List<ChartSampleData> chartData = [];
    salidasPorMesYAnio.forEach((keyFecha, salidas) {
      int totalSalidas = salidas.length; // Usar la longitud de la lista
      chartData.add(ChartSampleData(
        x: keyFecha, // Usar la clave (mes y año) como valor de X
        y: totalSalidas.toDouble(), // Convertir el total a double
      ));
    });

    return SfCartesianChart(
      backgroundColor: Colors.black12,
      title: const ChartTitle(text: 'SALIDAS', alignment: ChartAlignment.near),
      plotAreaBackgroundColor: Colors.black,
      primaryXAxis: const CategoryAxis(), // Cambiar a CategoryAxis para fechas
      series: <CartesianSeries<ChartSampleData, String>>[
        LineSeries<ChartSampleData, String>(
          dataSource: chartData..sort((a, b) => a.x.compareTo(b.x)),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          color:
              Colors.yellowAccent, // Puedes cambiar el color de la línea aquí
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}

class ChartSampleData {
  ChartSampleData({required this.x, required this.y});

  final String x; // Change the variable type to String
  final double y;
}

class EntradasChasr extends StatelessWidget {
  const EntradasChasr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TEntradasModel> listaSalidas =
        Provider.of<TEntradasAppProvider>(context).listaEntradas;

    // Organize salidas by month and year
    Map<String, List<TEntradasModel>> salidasPorMesYAnio = {};

    for (TEntradasModel entrada in listaSalidas) {
      if (entrada.created != null) {
        String keyFecha = fechaFiltrada(entrada.created!);

        if (!salidasPorMesYAnio.containsKey(keyFecha)) {
          salidasPorMesYAnio[keyFecha] = [];
        }
        salidasPorMesYAnio[keyFecha]!.add(entrada);
      }
    }

    // Create a list of points for the chart
    List<ChartSampleData> chartData = [];
    salidasPorMesYAnio.forEach((keyFecha, salidas) {
      int totalSalidas = salidas.length; // Usar la longitud de la lista
      chartData.add(ChartSampleData(
        x: keyFecha, // Usar la clave (mes y año) como valor de X
        y: totalSalidas.toDouble(), // Convertir el total a double
      ));
    });

    return SfCartesianChart(
      backgroundColor: Colors.black12,
      title: const ChartTitle(text: 'ENTRADAS', alignment: ChartAlignment.near),
      plotAreaBackgroundColor: Colors.black,
      primaryXAxis: const CategoryAxis(), // Cambiar a CategoryAxis para fechas
      series: <CartesianSeries<ChartSampleData, String>>[
        LineSeries<ChartSampleData, String>(
          dataSource: chartData..sort((a, b) => a.x.compareTo(b.x)),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          color: Colors.green, // Puedes cambiar el color de la línea aquí
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}

