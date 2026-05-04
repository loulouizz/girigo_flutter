import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  bool _isRecording = false;

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
  Widget build(BuildContext context) {
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
              onTap: () {
                setState(() {
                  _isRecording = !_isRecording;
                });
              },
              child: Container(
                padding: EdgeInsetsGeometry.all(8),
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: !_isRecording ? StartRecordButton() : StopRecordButton(curvedAnimation: _fadeAnimation,),
              ),
            ),
          ),
        ),
      ],
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
