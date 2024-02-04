import 'package:ausangate_op/models/model_v_inventario_general_producto.dart';
import 'package:ausangate_op/pages/tabla_source.dart';
import 'package:ausangate_op/provider/provider_v_inventario_general_productos.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/decoration_form.dart';
import 'package:ausangate_op/utils/scroll_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlmacenGestionPage extends StatelessWidget {
  const AlmacenGestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Elige la lista temporal según la categoría
    final vistaInventario =
        Provider.of<ViewInventarioGeneralProductosProvider>(context);
    List<ViewInventarioGeneralProductosModel> inventario =
        vistaInventario.listInventario;
    return ListTempralTableState(
      inventario: inventario,
    );
  }
}

class ListTempralTableState extends StatefulWidget {
  const ListTempralTableState({
    super.key,
    required this.inventario,
  });
  final List<ViewInventarioGeneralProductosModel> inventario;
  @override
  State<ListTempralTableState> createState() => _ListTempralTableStateState();
}

class _ListTempralTableStateState extends State<ListTempralTableState> {
  bool isvisibleSeachField =
      false; //VARIBLE que pemrite visulaizar el campo de buscador
  bool isVisibleFormEditing =
      false; //VARIABLE que permite visualizar el formulario

  int indexcopy = 0;

  //PRODUCTOS BUSCAR
  // Creamos un Buscador de datos en la tabla
  late TextEditingController _searchControllerProductos;
  late List<ViewInventarioGeneralProductosModel> filterListacompraProductos;

  bool isClear = false;
  //MOTOR DE BUSQUEDA DE PRODUCTOS DE LA TABLA
  _filterProductCompraProductos(String searchtext) {
    setState(() {
      filterListacompraProductos = widget.inventario
          .where((e) =>
              e.producto.toLowerCase().contains(searchtext.toLowerCase()) ||
              e.marcaProducto.toLowerCase().contains(searchtext.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    //PRODUCTOS FILTER
    filterListacompraProductos = widget.inventario;
    _searchControllerProductos =
        TextEditingController(); //Inicializamos el buscador en campo de busqueda

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //este metodo lo creamos para llamar al estado
  //SETSTATE funcion que pasamos como pararemtro el setstate
  void updateState() {
    setState(() {
      // Actualiza el estado del widget padre aquí según tus requisitos
      isVisibleFormEditing = !isVisibleFormEditing;
    });
  }

  //creamos este emtodo para controlar el estado de un widget.
  void psetState() {
    setState(() {
      //PRODUCTOS
      _filterProductCompraProductos('');
    });
  }

  //PAGINACION de tabla, mostrarl os datos
  List<int> rowsPerPageOptions = [
    10,
    15,
    20,
    25,
    30,
    40,
    50,
  ];

  int selectedRowsPerPage = 10; // Valor predeterminado inicial

  @override
  Widget build(BuildContext context) {
    final listaCompraProvider =
        Provider.of<ViewInventarioGeneralProductosProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //TABINDEX PRODUCTOS
            Column(
              children: [
                Expanded(
                  child: ScrollWeb(
                    child: ListView(
                      children: [
                        Card(
                          surfaceTintColor: Colors.transparent,
                          color: Colors.transparent,
                          elevation: 10,
                          child: PaginatedDataTable(
                            header: const H1Text(
                                text: 'Lista General | Categoria x'),
                            actions: [
                              Container(
                                  height: 50,
                                  width: 300,
                                  constraints:
                                      const BoxConstraints(maxWidth: 300),
                                  child: TextField(
                                    onChanged: (value) {
                                      _filterProductCompraProductos(value);
                                    },
                                    controller: _searchControllerProductos,
                                    decoration: decorationTextField(
                                        hintText: 'Buscar',
                                        labelText: 'Buscar Articulo',
                                        prefixIcon: _searchControllerProductos
                                                .text.isNotEmpty
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _searchControllerProductos
                                                        .text = '';
                                                    _filterProductCompraProductos(
                                                        _searchControllerProductos
                                                            .text);
                                                  });
                                                },
                                                icon: const Icon(Icons.clear))
                                            : const Icon(
                                                Icons.search,
                                              )),
                                  )),
                              rowStateColor(),
                              //FILTRADOPAGE : filtra datos por pagina
                              numberRowPaginated(),
                            ],
                            // dataRowHeight: 40, // Altura de las filas de datos
                            headingRowHeight:
                                50, // Altura de la fila de encabezado
                            horizontalMargin: 10, // Margen horizontal
                            columnSpacing: 1, // Espacio entre columnas
                            showCheckboxColumn:
                                false, // Mostrar columna de casilla de verificación
                            showFirstLastButtons:
                                true, // Mostrar botones de primera/última página
                            initialFirstRowIndex:
                                0, // Índice de la primera fila visible inicialmente
                            dragStartBehavior: DragStartBehavior
                                .start, // Comportamiento del arrastre
                            checkboxHorizontalMargin:
                                10, // Margen horizontal de la casilla de verificación
                            sortAscending:
                                false, // Orden ascendente o descendente
                            primary:
                                true, // Marcar como primario si es el Widget superior en la jerarquía
                            rowsPerPage:
                                selectedRowsPerPage, // Número de filas por página
                            columns: listColumn,
                            source: SourceDatatable(
                                listaCompraProvider: listaCompraProvider,
                                context: context,
                                indexcopy: indexcopy,
                                updateParentState: updateState,
                                filterListacompra: filterListacompraProductos,
                                psetState: psetState),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton<int> numberRowPaginated() {
    return DropdownButton<int>(
      iconSize: 30,
      elevation: 40,
      value: selectedRowsPerPage,
      onChanged: (newValue) {
        setState(() {
          selectedRowsPerPage = newValue!;
        });
      },
      items: rowsPerPageOptions.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget rowStateColor() {
    final size = MediaQuery.of(context).size;
   
    return size.width > 1200 ? Row(
      children: [
        _stateIndicator(color: Colors.red, text: 'Agotado\nVencido'),
        _stateIndicator(
            color: Colors.orange,
            text: 'stock es menor a 10\nvencimiento esta próxima'),
        _stateIndicator(color: Colors.white, text: 'suficiente\nFecha válida')
      ],
    ) : const SizedBox();
  }

  TextButton _stateIndicator({Color? color, String? text}) {
    return TextButton.icon(
        onPressed: null,
        icon: Icon(
          Icons.circle,
          color: color,
        ),
        label: H2Text(
          text: text!,
          fontSize: 10,
          maxLines: 3,
        ));
  }
}

List<DataColumn> listColumn = [
  DataColumn(
      label: H2Text(
    text: 'Image'.toUpperCase(),
    fontSize: 12,
    color: Colors.black,
  )),
  DataColumn(
      label: H2Text(
    text: 'Producto'.toUpperCase(),
    fontSize: 12,
    color: Colors.black,
  )),
  DataColumn(
      label: H2Text(
    text: 'Stock'.toUpperCase(),
    fontSize: 12,
    color: Colors.black,
  )),
  DataColumn(
      label: H2Text(
    text: 'Fecha Vencimiento'.toUpperCase(),
    fontSize: 12,
    color: Colors.black,
  )),
  DataColumn(
      label: H2Text(
    text: 'Ubicación'.toUpperCase(),
    fontSize: 12,
  )),
  DataColumn(
      label: H2Text(
    text: 'Categoria'.toUpperCase(),
    fontSize: 12,
  )),
  DataColumn(
      label: H2Text(
    text: 'Proveedor'.toUpperCase(),
    fontSize: 12,
    color: Colors.black,
  )),
  DataColumn(
      label: H2Text(
    text: 'Tipo'.toUpperCase(),
    fontSize: 12,
    color: Colors.black,
  )),
  DataColumn(
      label: H2Text(
    text: 'Estatus'.toUpperCase(),
    fontSize: 12,
    color: Colors.black,
  )),
];
