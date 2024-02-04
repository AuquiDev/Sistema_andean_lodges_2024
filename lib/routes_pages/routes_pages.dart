
import 'package:ausangate_op/home_page.dart';
import 'package:ausangate_op/pages/productos_pages.dart';
import 'package:ausangate_op/pages/t_detalle.trabajo_page.dart';
import 'package:ausangate_op/pages/tabla_paginada.dart';
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
      title: "Inventario",
      path:   const CatalogoProductos(), ),
  PageRoutes(
      icon: const Icon(Icons.settings),
      title: "Almacén",
      path: const AlmacenGestionPage(),),
 PageRoutes(
      icon: const Icon(Icons.groups_2),
      title: "Grupos",
      path:  const GrupoDetalleTrabajoPage(),
     ),
  PageRoutes(
      icon: const Icon(Icons.groups_2),
      title: "Grupos",
      path:  const HomePage(),
     ),
];

