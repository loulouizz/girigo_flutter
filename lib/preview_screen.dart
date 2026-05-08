import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:girigoflutter/audioplayer_singleton.dart';
import 'package:girigoflutter/sending_animation_screen.dart';

class PreviewScreen extends StatelessWidget {
  final Uint8List previewPicture;

  const PreviewScreen({required this.previewPicture, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: Transform.flip(
              flipX: true,
              child: Image.memory(
                previewPicture,
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsetsGeometry.all(16),
              height: 140,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent.withValues(alpha:  0.4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              '다시 찍기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          var player = AudioplayerSingleton.instance.player;
                          await player.resume();

                          // transição para tela de animação
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                  SendingAnimationScreen(),
                              transitionsBuilder:
                                  (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                  ) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(
                                milliseconds: 300,
                              ), // Optional: customize speed
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              '소원 전송',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
