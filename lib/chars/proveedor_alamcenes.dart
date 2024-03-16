import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/provider/provider_v_inventario_general_productos.dart';
import 'package:ausangate_op/utils/random_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InventarioMapaCalor extends StatelessWidget {
  const InventarioMapaCalor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 600 && size.width <= 1200;
    List<ViewInventarioGeneralProductosModel> listaProductos =
        Provider.of<ViewInventarioGeneralProductosProvider>(context)
            .listInventario;

    // Organizar los productos por proveedor
    Map<String, int> cantidadPorProveedor = {};
    for (var producto in listaProductos) {
      cantidadPorProveedor[producto.nombreEmpresaProveedor] =
          (cantidadPorProveedor[producto.nombreEmpresaProveedor] ?? 0) + 1;
    }

    // Calcular la cantidad total de productos
    int cantidadTotal = cantidadPorProveedor.values
        .fold(0, (total, cantidad) => total + cantidad);

    // Preparar los datos para el gráfico
    List<MapEntry<String, int>> data = cantidadPorProveedor.entries.toList();

    return SfCircularChart(
      title: const ChartTitle(
          text: 'PROVEEDORES',
          alignment: ChartAlignment.center,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
      legend: Legend(
          toggleSeriesVisibility: true,
          isVisible: true,
          isResponsive: true,
          iconHeight: 30.0,
          iconWidth: 30.0,
          overflowMode: LegendItemOverflowMode.wrap,
          position: (isDesktop || isTablet)
              ? LegendPosition.left
              : LegendPosition.bottom),
      series: <CircularSeries>[
        DoughnutSeries<MapEntry<String, int>, String>(
          dataSource: data,
          strokeColor: Colors.black26,
          xValueMapper: (MapEntry<String, int> entry, _) => entry.key,
          yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
          dataLabelMapper: (MapEntry<String, int> data, _) =>
              '${data.key}\n${data.value} (${(data.value / cantidadTotal * 100).toStringAsFixed(2)}%)',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings:
                ConnectorLineSettings(type: ConnectorType.curve),
            // color: Colors.black
          ),
          //  radius: '80%',
          // innerRadius: '60%',
          pointColorMapper: (MapEntry<String, int> data, _) => getRandomColor(),
          explode: true,
          explodeIndex: 0,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}

class InventarioMapaCalorUbicacion extends StatelessWidget {
  const InventarioMapaCalorUbicacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 600 && size.width <= 1200;
    List<ViewInventarioGeneralProductosModel> listaProductos =
        Provider.of<ViewInventarioGeneralProductosProvider>(context)
            .listInventario;

    // Organizar los productos por ubicación
    Map<String, int> cantidadPorUbicacion = {};
    for (var producto in listaProductos) {
      cantidadPorUbicacion[producto.nombreUbicacion] =
          (cantidadPorUbicacion[producto.nombreUbicacion] ?? 0) + 1;
    }

    // Calcular la cantidad total de productos
    int cantidadTotal = cantidadPorUbicacion.values
        .fold(0, (total, cantidad) => total + cantidad);

    // Preparar los datos para el gráfico
    List<MapEntry<String, int>> data = cantidadPorUbicacion.entries.toList();

    return SfCircularChart(
      title: const ChartTitle(
          text: 'ALMACENES',
          alignment: ChartAlignment.center,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
      legend: Legend(
          toggleSeriesVisibility: true,
          isVisible: true,
          isResponsive: true,
          overflowMode: LegendItemOverflowMode.wrap,
          iconHeight: 30.0,
          iconWidth: 30.0,
          position: (isDesktop) ? LegendPosition.left : LegendPosition.bottom),
      series: <CircularSeries>[
        DoughnutSeries<MapEntry<String, int>, String>(
          dataSource: data,
          strokeColor: Colors.black26,
          xValueMapper: (MapEntry<String, int> entry, _) => entry.key,
          yValueMapper: (MapEntry<String, int> entry, _) => entry.value,
          dataLabelMapper: (MapEntry<String, int> data, _) =>
              '${(data.value / cantidadTotal * 100).toStringAsFixed(2)}%',
          // '${data.key}\n${data.value} (${(data.value / cantidadTotal * 100).toStringAsFixed(2)}%)',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings:
                ConnectorLineSettings(type: ConnectorType.curve),
          ),
          // radius: '80%',
          // innerRadius: '20%',
          pointColorMapper: (MapEntry<String, int> data, _) => getRandomColor(),
          explode: true,
          explodeIndex: 0,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
