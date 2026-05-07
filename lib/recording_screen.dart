import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:girigoflutter/preview_screen.dart';
import 'package:girigoflutter/recording_controller.dart';
import 'package:provider/provider.dart';

class RecordingScreen extends StatefulWidget {
  final CameraController cameraController;

  const RecordingScreen({required this.cameraController, super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late CurvedAnimation _fadeAnimation;

  // timer countdown

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.cameraController.dispose();
    _fadeAnimation.dispose();
    _fadeAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingController>(
      builder: (context, controller, child) {
        Color buttonBorderColor = controller.isRecording
            ? Colors.grey
            : Colors.white;
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRect(
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: widget.cameraController.value.previewSize!.height,
                    height: widget.cameraController.value.previewSize!.width,
                    child: CameraPreview(widget.cameraController),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsetsGeometry.only(bottom: 80),
                child: GestureDetector(
                  onTap: () async {

                    if (controller.isRecording) {
                      controller.stopRecording();
                      var previewPictureXFile = await widget.cameraController.takePicture();

                      if(mounted){
                        Uint8List previewPicture = await previewPictureXFile.readAsBytes();
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => PreviewScreen(previewPicture: previewPicture),
                            transitionDuration: Duration.zero,
                            ));
                      }

                    } else {
                      controller.startRecording();
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsetsGeometry.all(8),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: BoxBorder.all(
                            color: buttonBorderColor,
                            width: 3,
                            strokeAlign: 0,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: !controller.isRecording
                            ? StartRecordButton()
                            : StopRecordButton(curvedAnimation: _fadeAnimation),
                      ),

                      Container(
                        height: 80,
                        width: 80,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: controller.lastValue,
                            end: controller.currentValue,
                          ),
                          duration: controller.currentValue != 0
                              ? Duration(seconds: 1)
                              : Duration(seconds: 0),
                          builder: (context, value, child) {
                            return CircularProgressIndicator(
                              color: Colors.red,
                              value: value,
                              strokeWidth: 3,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class StartRecordButton extends StatelessWidget {
  const StartRecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/icon_hand.svg');
  }
}

class StopRecordButton extends StatefulWidget {
  final CurvedAnimation curvedAnimation;

  const StopRecordButton({required this.curvedAnimation, super.key});

  @override
  State<StopRecordButton> createState() => _StopRecordButtonState();
}

class _StopRecordButtonState extends State<StopRecordButton> {
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.curvedAnimation,
      child: SvgPicture.asset('assets/icon_hand.svg', color: Colors.red),
    );
  }
}
