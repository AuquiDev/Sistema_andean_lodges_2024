import 'package:ausangate_op/pages/productos_pages.dart';
import 'package:ausangate_op/pages/t_detalle.trabajo_page.dart';
import 'package:ausangate_op/pages/t_asistencia_page.dart';
import 'package:ausangate_op/pages2/gastos_page_grupo.dart';
import 'package:ausangate_op/pages2/t_empleado_admin_page.dart';
import 'package:ausangate_op/pages2/t_movimientos_entradas.dart';
import 'package:ausangate_op/pages2/t_movimientos_salidas.dart';
import 'package:ausangate_op/pages2/t_productos_page.dart';
import 'package:ausangate_op/pages3/t_reporte_incidencias_list.dart';
import 'package:ausangate_op/pages3/t_reporte_pasajero_list.dart';
import 'package:flutter/material.dart';

class PageRoutes {
  Icon icon;
  String title;
  Widget path;
  PageRoutes({required this.icon, required this.title, required this.path});
}

List<PageRoutes> routes = [
  PageRoutes(
    icon: const Icon(Icons.local_grocery_store),
    title: "Catalogo Inventario",
    path: const CatalogoProductos(),
  ),

  PageRoutes(
    icon: const Icon(Icons.miscellaneous_services_sharp),
    title: "Gestión de Inventario",
    path: const ProductosPage(),
  ),

  // PageRoutes(
  //     icon: const Icon(Icons.settings),
  //     title: "Almacén",
  //     path: const AlmacenGestionPage(),),

  PageRoutes(
    icon: const Icon(Icons.groups_2),
    title: "Files",
    path: const GrupoDetalleTrabajoPage(),
  ),

  //PENDIENTE
  // PageRoutes(
  //     icon: const Icon(Icons.image),
  //     title: "Image",
  //     path:  const ImageUploadPage(),
  //    ),

  PageRoutes(
    icon: const Icon(Icons.edit_document),
    title: "Control Asistencia",
    path: const FormularioAsistenciapage(),
  ),

  PageRoutes(
    icon: const Icon(Icons.report_problem_rounded),
    title: "Reporte Incidencias",
    path: const ListaReporteIncidencias(),
  ),
  PageRoutes(
    icon: const Icon(Icons.travel_explore_rounded),
    title: "Encuesta Pasajeros",
    path: const ListaReporte(),
  ),

  PageRoutes(
    icon: const Icon(
      Icons.history,
    ),
    title: "Historial de entradas",
    path: const MovimientosPageEntrada(),
  ),
  PageRoutes(
    icon: const Icon(Icons.history),
    title: "Historial de Salidas",
    path: const MovimientosPageSalida(),
  ),
  PageRoutes(
    icon: const Icon(
      Icons.monetization_on,
    ),
    title: "Gastos por Grupo",
    path: const GastosGruposPage(),
  ),
  PageRoutes(
    icon: const Icon(Icons.admin_panel_settings),
    title: "Administración",
    path: const AdministracionPage(),
  ),
];
