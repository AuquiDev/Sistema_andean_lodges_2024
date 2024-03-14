import 'package:ausangate_op/models/model_t_detalle_trabajos.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';

class DetailsPagGrupos extends StatelessWidget {
  const DetailsPagGrupos(
      {super.key,
      required this.e,
      required this.diasnoches,
      required this.paxguia,
      required this.restricion,
      required this.tipogasto,
      required this.resgitros});
  final TDetalleTrabajoModel e;
  final String diasnoches;
  final List<String> paxguia;
  final String restricion;
  final String tipogasto;
  final String resgitros;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: H2Text(
          text: 'File: ${e.codigoGrupo}',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            int crossAxisCount = (constraints.maxWidth / 230).floor();
            return GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 1, //espacio ancho
                    mainAxisSpacing: 1, //espacio alto
                    childAspectRatio: 3, //Ver mas reducido al alto
                    crossAxisCount: crossAxisCount),
                children: [
                  CustomCardFile(
                    iconData: Icons.tour,
                    title: 'Programa',
                    subtitle: diasnoches,
                    backGround: Colors.teal,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.groups_2,
                    title: 'Nro. Pasajeros',
                    subtitle: paxguia[0],
                    backGround: Colors.blueAccent,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.person,
                    title: 'Nro. Guía',
                    subtitle: paxguia[1],
                    backGround: Colors.purple,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.format_align_justify_rounded,
                    title: 'Encuesta Pasajeros',
                    subtitle: '2 regs.', //#registros
                    backGround: Colors.deepPurple,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.comment,
                    title: 'Reporte de Guía',
                    subtitle: '1 regs.', //#registros
                    backGround: Colors.deepPurple,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.insert_comment_outlined,
                    title: 'Reporte de incidencias',
                    subtitle: '1 regs.', //#registros
                    backGround: Colors.deepPurple,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.assignment_turned_in_rounded,
                    title: 'Control de asistencia',
                    subtitle: '1 regs.', //#registros
                    backGround: Colors.deepPurple,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.monetization_on,
                    title: 'Gastos Total',
                    subtitle: 'S/. 120.00', //#registros
                    backGround: Colors.deepOrange,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.shopping_cart,
                    title: 'Compras',
                    subtitle: 'S/. 120.00', //#registros
                    backGround: Colors.redAccent,
                    routes: Container(),
                  ),
                  CustomCardFile(
                    iconData: Icons.menu_rounded,
                    title: 'Lista de Compras',
                    subtitle: '125 regs.', //#registros
                    backGround: Colors.pinkAccent,
                    routes: Container(),
                  ),
                ]);
          })
        ],
      ),
    );
  }
}

class CustomCardFile extends StatelessWidget {
  const CustomCardFile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.backGround,
    required this.routes,
  });
  final String title;
  final String subtitle;
  final IconData iconData;
  final Color backGround;
  final Widget routes;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => routes));
      },
      child: Card(
          surfaceTintColor: Colors.transparent,
          color: backGround.withOpacity(.8),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: FittedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H2Text(
                          text: title,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        H2Text(
                          text: subtitle,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Icon(
                  iconData,
                  size: 40,
                  color: Colors.white,
                )
              ],
            ),
          )),
    );
  }
}
