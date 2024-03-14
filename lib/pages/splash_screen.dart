import 'dart:math';
import 'dart:ui';

import 'package:ausangate_op/login_page.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class SplahScreen extends StatefulWidget {
  const SplahScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplahScreenState createState() => _SplahScreenState();
}

class _SplahScreenState extends State<SplahScreen>
    with SingleTickerProviderStateMixin {
  final double _targetposition = 0.0;

  AnimationController? _controller;
  Animation<double>? _animation;
  bool _showHomePage = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          // ..repeat(reverse: true);
          ..forward();
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeInOut);

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _showHomePage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.7,
                    colors: [
                      Color(0xFF603D29),
                      Color(0xFF725635),
                      Color(0xFF876443),
                      Color(0xFFA27953),
                      Color(0xFFC7A16E),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ScaleTransition(
              scale: _animation!,
              child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 5000),
                  tween: Tween<double>(begin: 1.0, end: _targetposition),
                  curve: Curves.fastOutSlowIn,
                  // onEnd: () {
                  //   if (_targetposition == 0) {
                  //     setState(() {
                  //       _targetposition = 1;
                  //     });
                  //   } else {
                  //     setState(() {
                  //       _targetposition = 0;
                  //     });
                  //   }
                  // },
                  builder: (context, value, child) {
                    return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, .001)
                          ..rotateY(pi * value),
                        alignment: Alignment.bottomCenter,
                        child:
                            //value < 0.5 ?
                          RippleAnimation(
                            duration: const Duration(milliseconds: 5000),
                            minRadius: 120,
                          delay:  const Duration(seconds: 3),
                          color: const Color(0xFFA27953),
                          child: Image.asset(
                            'assets/img/andeanlodges.png',
                            width: MediaQuery.of(context).size.width * .2,
                            // color: const Color(0xFFC7A16E).withOpacity(.4),
                          ),
                        ));
                  }),
            ),
          ),
          AnimatedOpacity(
            opacity: _showHomePage ? 1.0 : 0.0,
            duration: const Duration(seconds: 5),
            child: const RippleAnimation(
                color: Color(0xFFA27953), child: LoginPage()),
          )
        ],
      ),
    );
  }
}
