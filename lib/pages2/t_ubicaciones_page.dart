import 'package:ausangate_op/models/model_t_productos_app.dart';
import 'package:ausangate_op/models/model_t_ubicacion_almacen.dart';
import 'package:ausangate_op/pages2/t_ubicaciones_editing_page.dart';
import 'package:ausangate_op/provider/provider_t_productoapp.dart';
import 'package:ausangate_op/provider/provider_t_ubicacion_almacen.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TPageUbicaciones extends StatelessWidget {
  const TPageUbicaciones({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ubicaiones = Provider.of<TUbicacionAlmacenProvider>(context);
    List<TUbicacionAlmacenModel> listaUbicaciones = ubicaiones.listUbicacion;

    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const H2Text(
            text: 'Almacenes',
            fontWeight: FontWeight.w800,
            color: Color(0xFF210715),
          ),
          actions: [
            ElevatedButton.icon(
              style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 10)),
                  backgroundColor: MaterialStatePropertyAll(Colors.yellow)),
              icon: const Icon(
                Icons.add,
                size: 16,
              ),
              label: const H2Text(
                text: 'Nuevo almacén',
                fontSize: 13,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UbicacionesForm(),
                  ),
                );
              },
            ),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (orientation == Orientation.portrait) ? 2 : 4,
                ),
                itemCount: listaUbicaciones.length,
                itemBuilder: (context, index) {
                  final e = listaUbicaciones[index];
                  return ImageUbicaiones(e: e);
                },
              ),
            )
          ],
        ),
      );
    });
  }
}

class ImageUbicaiones extends StatelessWidget {
  const ImageUbicaiones({
    super.key,
    required this.e,
  });

  final TUbicacionAlmacenModel e;

  @override
  Widget build(BuildContext context) {
    List<TProductosAppModel> obtenerLenghtUbicaciones(String idUbicacion) {
      final listaTProducto =
          Provider.of<TProductosAppProvider>(context, listen: false)
              .listProductos;
      List<TProductosAppModel> filterubicacionProducto =
          listaTProducto.where((a) => a.idUbicacion == e.id).toList();
      return filterubicacionProducto;
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color(0xffF6F3EB),
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.black12,
                    width: .5)),
            width: width,
            height: height,
            child: Image.network(
                e.imagen != null && e.imagen is String && e.imagen!.isNotEmpty
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
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(.3),
                padding: const EdgeInsets.all(5),
                color: const Color(0xBA210715),
                width: width,
                height: height,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        H2Text(
                          text: e.nombreUbicacion,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          maxLines: 2,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              H2Text(
                                text: e.descripcionUbicacion,
                                maxLines: 40,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (obtenerLenghtUbicaciones(e.id!).isEmpty) {
                                    _mostrarDialogoConfirmacion(context);
                                  } else {
                                    showSialogEdicion(context,
                                        'Esta acción conlleva riesgos. Antes de eliminar una ubicación de almacén, asegúrate de que no haya registros asignados a esta ubicación.\n\n(${obtenerLenghtUbicaciones(e.id!).length} registros encontrados)');
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UbicacionesForm(e: e)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.amberAccent,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      );
    });
  }

  void _mostrarDialogoConfirmacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content:
              const Text("¿Está seguro de que desea eliminar este elemento?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<TUbicacionAlmacenProvider>()
                    .deleteTUbicacionesApp(e.id!);
                _eliminarElemento(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
    // Navigator.pop(context);
  }

  void showSialogEdicion(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Alerta de acción No Permitida!'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarElemento(BuildContext context) {
    // Mostrar SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Elemento eliminado correctamente"),
      ),
    );

    Navigator.of(context).pop();
  }
}
