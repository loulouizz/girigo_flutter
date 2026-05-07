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
    _timer = Timer(
      Duration(seconds: 8),
      (){
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              HomePage(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(
            milliseconds: 300,
          ), // Optional: customize speed
        ),);
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/sending.gif', height: 400, fit: BoxFit.cover),
        Row(
          children: [
            SvgPicture.asset('assets/sending_description.svg'),

            //adicionar reticência animada
            // 3 containers
          ],
        ),
      ],
    );
  }
}
