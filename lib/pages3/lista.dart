import 'package:ausangate_op/pages/t_asistencia_page.dart';
import 'package:ausangate_op/pages3/t_reporte_incidencias_list.dart';
import 'package:ausangate_op/pages3/t_reporte_pasajero_list.dart';
import 'package:flutter/material.dart';

class Card3D {
  const Card3D(
      {required this.description,
      required this.title,
      required this.page});
  final Widget page;
  final String title;
  final String description;
}

 List<Card3D> cardList = [
  Card3D(
    title: 'Informe del Guía',
    page: Container(),
    description:
        'Registra incidentes y reportes del grupo, así como la experiencia general de los pasajeros con el tour. Tu aporte es esencial para mejorar nuestros servicios.',
  ),
    
  const Card3D(
    title: 'Encuesta de Pasajeros',
    page: ListaReporte(),
    description:
        'Participe en nuestra Encuesta y comparta sus comentarios para mejorar nuestros servicios. Su opinión es clave para nosotros mientras trabajamos para hacer que cada viaje sea inolvidable y personalizado para usted.',
  ),
  Card3D(
    title: 'Informe del Cocinero',
    page: Container(),
    description:
        'Evalúa tu experiencia como cocinero. Comparte comentarios sobre el equipo, reporta incidentes en el grupo y notifica cualquier aspecto relevante en nuestros servicios.',
  ),
  Card3D(
    title: 'Informe del Almacén',
    page: Container(),
    description:
        'Registre los incidentes al momento de la recepción y entrega de equipos. Coméntenos cualquier incidente ocurrido durante esta actividad para mejorar nuestros procesos.',
  ),
  const Card3D(
    title: 'Informe de Incidencias',
    page: ListaReporteIncidencias(),//
    description:
        'Registre cualquier requerimiento o incidente durante la coordinación. Sus comentarios son esenciales para mejorar nuestros procesos y ofrecer un servicio más eficiente.',
  ),
  const Card3D(
    title: 'Control de Asistencia',
    page: FormularioAsistenciapage(),
    description:
        'Registra la asistencia de todo el personal involucrado. Asegura una operación sin contratiempos y un servicio turístico de alta calidad.',
  ),
];
