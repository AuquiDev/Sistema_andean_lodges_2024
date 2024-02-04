import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class ScrollWeb extends StatelessWidget {
  ScrollWeb({
    super.key,
    required this.child,
  });
  Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
        child: child);
  }
}
