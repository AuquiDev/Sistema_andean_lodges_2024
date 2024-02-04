
import 'package:flutter/material.dart';

class DividerCustom extends StatelessWidget {
  const DividerCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: 30,
      child: const Divider(
        thickness: 3,
        height: 0,
      ),
    );
  }
}
