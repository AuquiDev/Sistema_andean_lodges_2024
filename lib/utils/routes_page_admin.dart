
import 'package:ausangate_op/models/model_t_empleado.dart';
import 'package:ausangate_op/pages2/t_empleado_gestion_page.dart';
import 'package:ausangate_op/pages2/t_ubicaciones_page.dart';

import 'package:ausangate_op/provider/provider_datacahe.dart';
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Routes {
  Routes({required this.titulo, required this.page, required this.widget});

  final String titulo;
  final Widget page;
  final Widget widget;

  void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  Widget buildCard(BuildContext context) {
    TEmpleadoModel? user =  Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return GestureDetector(
      onTap: () {
        if (titulo == 'Empleados') {
          if ( user!.rol == 'admin') {
            print(user.rol);
              navigate(context);    
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Acceso denegado. El usuario no es administrador.'),
              ),
            );
          }
        } else {
          
           navigate(context);    
        }
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: widget,
            ),
            const SizedBox(height: 8),
            Flexible(
              flex: 1,
              child: H2Text(text:
                titulo,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoutesFactory {
  static List<Routes> createRoutes() {   
    return [
      Routes(titulo: 'Empleados', page:  const EmpleadosFormPage(), widget: const Icon(Icons.groups_2_outlined)),
      Routes(titulo: 'Crear Almacén', page: const TPageUbicaciones(), widget: const Icon(Icons.inventory_rounded)),
      Routes(titulo: 'Proveedores', page: Container(), widget:const Icon(Icons.local_shipping)),
      Routes(titulo: 'Categorías', page: Container(), widget: const Icon(Icons.category)),
      Routes(titulo: 'Restriciones alimenticias', page: Container(), widget: const Icon(Icons.local_shipping)),
      // Routes(titulo: 'Grupos Pasajeros', page: Container(), widget: const Icon(Icons.work_history_sharp)),//Esta va en al botonNavigationbar
      Routes(titulo: 'Tipo de gasto', page:  Container(), widget: const Icon(Icons.local_shipping)),
      Routes(titulo: 'Estadísticas', page: Container(), widget: const Icon(Icons.pie_chart)),

    ];
  }
}
