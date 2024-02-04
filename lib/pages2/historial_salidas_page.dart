import 'package:ausangate_op/pages2/historial_page_details.dart';
import 'package:flutter/material.dart';
import 'package:ausangate_op/models/model_v_historial_salidas_productos.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:ausangate_op/utils/format_fecha.dart';
import 'package:ausangate_op/widgets/imagen_path_productos.dart';


class HistorialSalidasWidget extends StatefulWidget {
  const HistorialSalidasWidget(
      {super.key,
      required this.listaHistorial,
      required this.codigoGrupo,
      required this.idCodigoGrupo,
      required this.montoTotalInversion
      });
  final List<ViewHistorialSalidasProductosModel> listaHistorial;
  final String codigoGrupo;
  final String idCodigoGrupo;
  final double montoTotalInversion;

  @override
  State<HistorialSalidasWidget> createState() => _HistorialSalidasWidgetState();
}

class _HistorialSalidasWidgetState extends State<HistorialSalidasWidget> {

  //FILTRAR CODIGO DE GRUPO 
  late List<ViewHistorialSalidasProductosModel> filterhistorial;
  //FILTRAR Si el codigo de grupo coincide
  _filterSalidaCodigogrupo(String seachtext) {
    filterhistorial = widget.listaHistorial
        .where((e) =>
            e.idCodigoGrupo.toLowerCase().contains(seachtext.toLowerCase()))
        .toList();
  }

  //BUSCADOR PRODUCTOS SALIDAS
  late TextEditingController _searchSalidasControler;
  late List<ViewHistorialSalidasProductosModel> searchListFilter;
  //BUSQUEDA METODO
  _filterProductosSalidas (String seachText){
    setState(() {
      searchListFilter = filterhistorial.where((e) => 
          e.producto.toLowerCase().contains(seachText.toLowerCase()) ||
          e.cargoPuesto.toLowerCase().contains(seachText.toLowerCase()) || 
          e.nombreEmpleado.toLowerCase().contains(seachText.toLowerCase()) || 
          e.nombreUbicacion.toLowerCase().contains(seachText.toLowerCase()) ||
          e.tipoProducto.toLowerCase().contains(seachText.toLowerCase())
        ).toList();
    });
  }

  @override
  void initState() {
  
    _filterSalidaCodigogrupo(widget.idCodigoGrupo);//FILTRAR CODIGO
      _searchSalidasControler = TextEditingController();//CONTROLLER LISTA PRODUCTOS
    searchListFilter = filterhistorial;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

          return Column(
            children: [
              Container(
                height: 50,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                    offset: Offset.zero,
                    blurRadius: 6,
                    color: Colors.black26,
                  ),
                ], borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _searchSalidasControler,
                  onTap: () {
                    _filterProductosSalidas(_searchSalidasControler.text);
                  },
                  onChanged: (value) {
                     _filterProductosSalidas(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: InkWell(
                        onTap: () {
                          _searchSalidasControler.clear();
                        },
                        child:_searchSalidasControler.text.isEmpty ?  const Icon(Icons.search) : const Icon(Icons.clear)),
                    filled: true,
                    fillColor: const Color(0xFFFFFFFF),
                    hintText: "Buscar grupo",
                    hintStyle: const TextStyle(
                        color: Colors.black26, fontWeight: FontWeight.w500),
                    enabled: true,
                    border: _outlineButton(),
                    focusedBorder: _outlineButton(),
                    enabledBorder: _outlineButton(),
                    errorBorder: _outlineButton(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    H2Text(
                        text: 'Lista de Salidas:  ${widget.codigoGrupo}',
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        H2Text(
                          text: 'Total S/.${widget.montoTotalInversion.toStringAsFixed(2)}',
                          fontSize: 10,
                          color: Colors.blue,
                        ),
                        H2Text(
                          text: '${filterhistorial.length} regs.',
                          fontSize: 10,
                          color: Colors.black38,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              filterhistorial.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchListFilter.length,//filterhistorial.length,
                          itemBuilder: (context, index) {
                            final e = searchListFilter[index];//filterhistorial[index]
                            return Card(
                              elevation: 8,
                              surfaceTintColor: const Color(0xFFB2DDDE),
                              color: const Color(0xFFB2DDDE),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HistorialPageDetails(e: e)));
                                },
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                title: H2Text(
                                  text: e.producto,
                                  fontSize: 14,
                                  maxLines: 3,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ImageDetailsHistorialSalidas(
                                          e: e,
                                          size: 70,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            H2Text(
                                              text: 'Almacén de ${e.nombreUbicacion}',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 9,
                                            ),
                                            H2Text(
                                              text: 'Entregado a ${e.nombreEmpleado}',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 9,
                                            ),
                                            H2Text(
                                              text:
                                                  'quien ocupa el cargo de  ${e.cargoPuesto}',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 9,
                                            ),
                                            const Divider(
                                              color: Color(0x0A000000),
                                            ),
                                            H2Text(
                                              text:
                                                  'Fecha salida :${formatFecha(e.fechaRegistroSalida)}',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 9,
                                              maxLines: 2,
                                            ),
                                            H2Text(
                                              text: 'Itinerario :${e.grupo}',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 9,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0x0A000000),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        PrecioWidgetSalidas(
                                            e: e.codigoGrupo, text: 'Codígo grupo'),
                                        PrecioWidgetSalidas(
                                          e: e.cantidadSalida.toStringAsFixed(2).toString(),
                                          text: '# Salida Und.',
                                        ),
                                        PrecioWidgetSalidas(
                                          e:'S/.${e.precioUnidadSalidaGrupo.toStringAsFixed(2)}',
                                          text: '# precio Und.',
                                        ),
                                        PrecioWidgetSalidas(
                                          e:'S/.${e.montoTotalSalida.toStringAsFixed(2)}',
                                          text: '# monto total.',
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const Text('No se encontro registros.'),
            ],
          );
  }
    OutlineInputBorder _outlineButton() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}

class PrecioWidgetSalidas extends StatelessWidget {
  const PrecioWidgetSalidas({super.key, required this.e, required this.text});

  final String e;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        H2Text(
          text: text,
          fontWeight: FontWeight.w500,
          fontSize: 9,
        ),
        H2Text(
          text: e.toString(),
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ],
    );
  }
}
