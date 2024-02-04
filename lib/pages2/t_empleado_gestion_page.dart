import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/pages2/t_empleado_details_page.dart';
import 'package:ausangate_op/pages2/t_empleado_editing_page.dart';
import 'package:ausangate_op/provider/provider_empleados.rol_sueldo.dart';
import 'package:ausangate_op/provider/provider_t_empleado.dart';
import 'package:ausangate_op/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmpleadosFormPage extends StatefulWidget {
  const EmpleadosFormPage({
    super.key,
  });

  @override
  State<EmpleadosFormPage> createState() => _EmpleadosFormPageState();
}

class _EmpleadosFormPageState extends State<EmpleadosFormPage> {
  //FUNCION PARA BLOQUEAR el giro de pantalla y mantenerla en Vertical.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Bloquear la rotación de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo retrato
    ]);
  }

  @override
  void dispose() {
    // Restaurar las preferencias de orientación cuando la página se destruye
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listaEmpleados =
        Provider.of<TEmpleadoProvider>(context).listaEmpleados
          ..sort(
            (a, b) => a.nombre.compareTo(b.nombre),
          );

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const H2Text(
          text: 'Gestión de Empleados',
          fontWeight: FontWeight.w800,
        ),
        actions: [
          TextButton.icon(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 10))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmpleadosFormEditing()));
            },
            icon: const Icon(
              Icons.add_circle_outlined,
              size: 20,
            ),
            label: const Text('Nuevo '),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 0,
                color: Colors.black12,
                thickness: 1,
              ),
              itemCount: listaEmpleados.length,
              itemBuilder: (BuildContext context, int index) {
                final e = listaEmpleados[index];
                return CardCustomEmpleados(e: e);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardCustomEmpleados extends StatelessWidget {
  const CardCustomEmpleados({
    super.key,
    required this.e,
  });

  final TEmpleadoModel e;

  @override
  Widget build(BuildContext context) {
    final listaRolesSueldo =
        Provider.of<TRolesSueldoProvider>(context).listRolesSueldo;

    List<dynamic> obtenerRolesSueldo(String idrolesSueldo) {
      for (var data in listaRolesSueldo) {
        if (data.id == e.idRolesSueldoEmpleados) {
          return [
            data.cargoPuesto,
            data.sueldoBase,
            data.tipoMoneda,
            data.tipoCalculoSueldo,
          ];
        }
      }
      return ['', '', ''];
    }

    String cargopuesto = obtenerRolesSueldo(e.idRolesSueldoEmpleados)[0];
    double sueldoBase = obtenerRolesSueldo(e.idRolesSueldoEmpleados)[1];
    String tipoMoneda = obtenerRolesSueldo(e.idRolesSueldoEmpleados)[2];
    String tipoCalculoSueldo = obtenerRolesSueldo(e.idRolesSueldoEmpleados)[3];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsEmpleadospage(
                      e: e,
                      cargopuesto: cargopuesto,
                      sueldoBase: sueldoBase,
                      tipoMoneda: tipoMoneda,
                      tipoCalculoSueldo: tipoCalculoSueldo)));
        },
        leading: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmpleadosFormEditing(
                                  e: e,
                                  rolPuesto: cargopuesto,
                                )));
                  },
                  child: _cardButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF047A7E),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    _mostrarDialogoConfirmacion(context);
                  },
                  child: _cardButton(
                      icon:
                          const Icon(Icons.delete, color: Color(0xFFAB3D35)))),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2Text(
              text: '${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}',
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            H2Text(
              text: cargopuesto,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  const H2Text(
                    text: 'cédula',
                    fontWeight: FontWeight.w200,
                    fontSize: 8,
                  ),
                  H2Text(
                    text: e.cedula.toString(),
                    fontWeight: FontWeight.w200,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      H2Text(
                        text: e.estado ? 'Activo' : 'Inactivo',
                        fontWeight: FontWeight.w500,
                        fontSize: 8,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                      H2Text(
                        text: e.rol,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  Switch.adaptive(value: e.estado, onChanged: null)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _cardButton({Icon? icon}) {
    return Card(
      elevation: 5,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(0),
      child: SizedBox(height: double.infinity, width: 45, child: icon),
    );
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
                    .read<TEmpleadoProvider>()
                    .deleteTEmpeladoProvider(e.id!);
                _eliminarElemento(context);
              },
              child: const Text("Eliminar"),
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
