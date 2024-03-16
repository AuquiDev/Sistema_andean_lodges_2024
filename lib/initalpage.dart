// ignore_for_file: unnecessary_null_comparison

import 'package:ausangate_op/chars/entradas_salidas.dart';
import 'package:ausangate_op/chars/proveedor_alamcenes.dart';
import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/provider/provider_t_detalle_trabajo.dart';
import 'package:ausangate_op/utils/format_fecha.dart';

import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ModuleRoute extends StatelessWidget {
  const ModuleRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 600 && size.width <= 1200;
    final isMobile = size.width <= 600;

    return Scaffold(
      body: ScrollWeb(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isDesktop)
                const Row(
                  children: [
                    Flexible(child: EntradasChasr()),
                    Flexible(child: SalidasChar()),
                    Flexible(child: CharGruposPasajeros()),
                  ],
                )
              else if (isTablet)
                const Row(
                  children: [
                    Flexible(child: EntradasChasr()),
                    Flexible(child: SalidasChar()),
                  ],
                )
              else if (isMobile)
                const Column(
                  children: [
                    EntradasChasr(),
                    SalidasChar(),
                    CharGruposPasajeros(),
                  ],
                ),
              if (isDesktop)
                const Row(
                  children: [
                    Flexible(child: InventarioMapaCalor()),
                    Flexible(child: InventarioMapaCalorUbicacion()),
                    Flexible(child: InventarioMapaCalorUbicacion()),
                  ],
                )
              else if (isTablet)
                const Column(
                  children: [
                    InventarioMapaCalor(),
                    InventarioMapaCalorUbicacion()
                  ],
                )
              else if (isMobile)
                const Column(
                  children: [
                    InventarioMapaCalor(),
                    InventarioMapaCalorUbicacion()
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CharGruposPasajeros extends StatelessWidget {
  const CharGruposPasajeros({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TDetalleTrabajoModel> listaDetalleTrabajo =
        Provider.of<TDetalleTrabajoProvider>(context).listaDetallTrabajo;

    // Organize salidas by month and year
    Map<String, List<TDetalleTrabajoModel>> salidasPorMesYAnio = {};

    for (TDetalleTrabajoModel trabajo in listaDetalleTrabajo) {
      if (trabajo.fechaInicio != null) {
        String keyFecha = fechaFiltrada(trabajo.fechaInicio);

        if (!salidasPorMesYAnio.containsKey(keyFecha)) {
          salidasPorMesYAnio[keyFecha] = [];
        }
        salidasPorMesYAnio[keyFecha]!.add(trabajo);
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
      title: const ChartTitle(
          text: 'GRUPOS',
          alignment: ChartAlignment.center,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
      plotAreaBackgroundColor: Colors.black,
      primaryXAxis: const CategoryAxis(),
      primaryYAxis:
          const NumericAxis(title: AxisTitle(text: 'Cantidad de Grupos')),
      series: <CartesianSeries<ChartSampleData, String>>[
        LineSeries<ChartSampleData, String>(
          dataSource: chartData..sort((a, b) => a.x.compareTo(b.x)),
          xValueMapper: (ChartSampleData data, _) => data.x,
          yValueMapper: (ChartSampleData data, _) => data.y,
          color: Colors.blue, // Puedes cambiar el color de la línea aquí
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
