// ignore_for_file: avoid_print, unnecessary_null_comparison, use_build_context_synchronously

import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/pages2/t_productos_editing_page.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/widgets/custom_app_bar_entra_salid.dart';
import 'package:ausangate_op/widgets/list_image_path_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class SourceDatatable extends DataTableSource {
  SourceDatatable({
    required this.filterListacompra,
    required this.context,
    required this.indexcopy,
  });

  final List<TProductosAppModel> filterListacompra;
  final BuildContext context;
  int indexcopy;

  @override
  DataRow getRow(int index) {
    final e = filterListacompra[index];
    return DataRow(
      color: MaterialStatePropertyAll(getColorBasedOnStockAndExpiration(e)),
      selected: e.estado,
      onSelectChanged: (isSelected) {
        //SELECTED PRODUCTO SET
        final dataprovider =
            Provider.of<TProductosAppProvider>(context, listen: false);
        dataprovider.seleccionarProducto(e);

        showProductDetailsDialog(e);
      },
      cells: <DataCell>[
        // IMAGE
        DataCell(
          ImageView(e: e),
        ),
        //OPRODUCTO
        DataCell(
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            child: H2Text(
              text:
                  '${e.nombreProducto} - ${e.marcaProducto} - ${e.unidMedida}',
              textAlign: TextAlign.start,
              fontSize: 11.0,
              fontWeight: FontWeight.w400,
              // maxLines: 5,
            ),
          ),
        ),
        //STOCK
        DataCell(
          H1Text(
            text: e.stock.toString(),
            textAlign: TextAlign.center,
            fontSize: 11.0,
            fontWeight: FontWeight.w400,
            maxLines: 5,
            color: getColorStock(e),
          ),
        ),
        //FECHA VENCIMIENTO
        DataCell(
          H2Text(
            text: formatFecha(e.fechaVencimiento),
            textAlign: TextAlign.center,
            fontSize: 11,
            maxLines: 5,
            color: getColorfechav(e),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton.outlined(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPageProductosApp(e: e)));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.green,
                  )),
              IconButton.outlined(
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      width: 300,
                      type: QuickAlertType.warning,
                      text: '¿Está seguro de que desea eliminar este registro?',
                      onConfirmBtnTap: () async {
                        await context
                            .read<TProductosAppProvider>()
                            .deleteTProductosApp(e.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ],
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

  void showProductDetailsDialog(TProductosAppModel selectedProduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CustomAppBarPRoductos(
            e: selectedProduct,
          ),
        );
      },
    );
  }
}

Color getColorBasedOnStockAndExpiration(TProductosAppModel e) {
  // Si el stock está agotado o la fecha de vencimiento ha pasado
  if (e.stock == 0 ||
      (e.fechaVencimiento != null &&
          e.fechaVencimiento.isBefore(DateTime.now()))) {
    return Colors.red.withOpacity(
        0.05); // Color más pronunciado para stock agotado o producto vencido
  }

  // Si el stock es menor a 10 o la fecha de vencimiento está próxima
  else if (e.stock! < 10 ||
      (e.fechaVencimiento != null &&
          e.fechaVencimiento.difference(DateTime.now()).inDays <= 7)) {
    return Colors.blue.withOpacity(
        0.1); // Color más pronunciado para stock bajo o producto próximo a vencer/agotar
  }

  // En cualquier otro caso
  return Colors.white; // Color predeterminado
}

Color getColorStock(TProductosAppModel e) {
  double stockTotal = e.stock!;

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

Color getColorfechav(TProductosAppModel e) {
  if (e.fechaVencimiento != null) {
    DateTime now = DateTime.now();
    DateTime startOfMonthNextMonth = DateTime(now.year, now.month + 2, 1);
    DateTime startOfMonthThisMonth = DateTime(now.year, now.month, 1);

    if (e.fechaVencimiento.isBefore(now)) {
      return Colors.red.withOpacity(0.9); // Vencido
    } else if (e.fechaVencimiento.isAtSameMomentAs(startOfMonthThisMonth)) {
      return Colors.blue; // Por vencer este mes
    } else if (e.fechaVencimiento.isAtSameMomentAs(startOfMonthNextMonth)) {
      return const Color.fromARGB(255, 14, 138, 5); // Por vencer el próximo mes
    }
  }

  return Colors.black; // No vencido
}
