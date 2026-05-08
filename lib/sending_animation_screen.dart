import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:girigoflutter/main.dart';

class SendingAnimationScreen extends StatefulWidget {
  const SendingAnimationScreen({super.key});

  @override
  State<SendingAnimationScreen> createState() => _SendingAnimationScreenState();
}

class _SendingAnimationScreenState extends State<SendingAnimationScreen> {
  late final Timer _timer;

  @override
  void initState() {
    _timer = Timer(Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(
            milliseconds: 300,
          ), // Optional: customize speed
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/sending.gif', height: 400, fit: BoxFit.cover),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset('assets/sending_description.svg'),
            SizedBox(width: 8),
            RepeatingAnimationBuilder<double>(
              animatable: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 900),
              builder: (context, index, _) {
                return SizedBox(
                  width: 38,
                  height: 10,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: 4,
                        width: 4,
                        color: Colors.white,
                      ),
                      index > 0.3
                          ? Padding(
                              padding: EdgeInsetsGeometry.only(left: 4),
                              child: TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 300),
                                tween: Tween(begin: 0, end: 1),
                                builder: (context, index, _) {
                                  return Container(
                                    height: 4,
                                    width: 4,
                                    color: Colors.white.withValues(
                                      alpha: index / 0.3,
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(),
                      index > 0.6
                          ? Padding(
                              padding: EdgeInsetsGeometry.only(left: 4),
                              child: TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 300),
                                tween: Tween(begin: 0, end: 1),
                                builder: (context, index, _) {
                                  return Container(
                                    height: 4,
                                    width: 4,
                                    color: Colors.white.withValues(
                                      alpha: index / 0.6,
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
