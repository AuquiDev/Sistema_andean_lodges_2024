
import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';

class ResponsiveTitleAppBar extends StatelessWidget {
  const ResponsiveTitleAppBar({
    super.key,
    required this.title, required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
         Image.asset('assets/img/andeanlodges.png', width: 90,color: Colors.black,),
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           H2Text(
            text: title.toUpperCase(), //Movimientos de Inventario
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: const Color(0xFF430E21),
          ),
           H2Text(
            text: subtitle, //Movimientos de Inventario
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: const Color(0xFF0E526B),
          ),
         ],)
        ],
      ),
    );
  }
}