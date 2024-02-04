import 'package:ausangate_op/utils/text_custom.dart';
import 'package:flutter/material.dart';

class CardCustomFom extends StatelessWidget {
  const CardCustomFom({
    super.key,
    required this.child,
    required this.label,
  });

  final Widget child;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        H2Text(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w300,
          maxLines: 4,
        ),
        Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 10,
                    color: Colors.black26,
                  )
                ]),
            child: child),
      ],
    );
  }
}

class CardCustomFormOutilne extends StatelessWidget {
  const CardCustomFormOutilne({
    super.key,
    required this.child,
    required this.label,
  });

  final Widget child;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H2Text(
              text: label,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              maxLines: 4,
            ),
            const SizedBox(height: 10,),
            child,
          ],
        ),
      ),
    );
  }
}
