// ignore_for_file: avoid_print

import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/provider/provider_v_inventario_general_productos.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:flutter/material.dart';

class SourceDatatable extends DataTableSource {
  SourceDatatable(
      {required this.filterListacompra,
      required this.listaCompraProvider,
      required this.context,
      required this.indexcopy,
      required this.updateParentState,
      required this.psetState});

  final ViewInventarioGeneralProductosProvider listaCompraProvider;
  final List<ViewInventarioGeneralProductosModel> filterListacompra;
  final BuildContext context;
  int indexcopy;
  final VoidCallback? updateParentState;
  final VoidCallback? psetState;

  @override
  DataRow getRow(int index) {
    final e = filterListacompra[index];
    final int dataIndex = listaCompraProvider.listInventario.indexOf(e);

    return DataRow(
      color: MaterialStatePropertyAll(getColorBasedOnStockAndExpiration(e)),
      selected: convertirADatoBooleano(e.estadoStock),
      onSelectChanged: (isSelected) {
        bool estado = e.stock != 0;
        convertirADatoBooleano(estado);
        estado = isSelected!;

        indexcopy = dataIndex;

        updateParentState?.call();
        updateParentState?.call();
        print('ID DEL ELEMENTO:  ${e.id}');
      },
      cells: <DataCell>[
        // IMAGE
        DataCell(
          IconButton(onPressed: () {

          }, icon: const Icon(Icons.image)),
        ),
        //OPRODUCTO
        DataCell(
          H2Text(
            text: e.producto,
            textAlign: TextAlign.center,
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            maxLines: 5,
          ),
        ),
        //STOCK
        DataCell(
          H1Text(
            text: e.stock.toString(),
            textAlign: TextAlign.center,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            maxLines: 5,
            color: getColorStock(e),
          ),
        ),
        //FECHA VENCIMIENTO
        DataCell(
          H2Text(
            text: formatFecha(e.fechaVencimiento!),
            textAlign: TextAlign.center,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            maxLines: 5,
            color: getColorfechav(e),
          ),
        ),

        //UBICACION
        DataCell(H2Text(
          text: e.nombreUbicacion,
          textAlign: TextAlign.center,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          maxLines: 5,
        )),

        //CATEGORY
        DataCell(H2Text(
          text: e.categoria,
          textAlign: TextAlign.center,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          maxLines: 5,
        )),

        //IMAGEN
        DataCell(H2Text(
          text: e.nombreEmpresaProveedor,
          textAlign: TextAlign.center,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          maxLines: 5,
        )),

        DataCell(
          H2Text(
            text: e.tipoProducto,
            textAlign: TextAlign.center,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            maxLines: 5,
          ),
        ),

        DataCell(
          H2Text(
            text: '${e.estadoFecha}\n${e.estadoStock}',
            // textAlign: TextAlign.center,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            maxLines: 5,
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filterListacompra.length;

  @override
  int get selectedRowCount => 0;

  bool convertirADatoBooleano(dynamic valor) {
    if (valor is bool) {
      return valor;
    } else if (valor is String) {
      if (valor.toLowerCase() == 'true') {
        return true;
      } else if (valor.toLowerCase() == 'false') {
        return false;
      }
    }
    return false;
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
