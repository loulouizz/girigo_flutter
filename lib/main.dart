import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:girigoflutter/recording_controller.dart';
import 'package:girigoflutter/recording_screen.dart';
import 'package:provider/provider.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
    ),
  );

  _cameras = await availableCameras();

  runApp(
      ChangeNotifierProvider<RecordingController>(
        create: (_) => RecordingController(),
        builder: (context, child){
          return const App();
        },),
      );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home:HomePage(),


    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late CurvedAnimation _fadeAnimation;

  late CameraController _cameraController;

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

    // camera
    _cameraController = CameraController(_cameras[1], ResolutionPreset.medium);
    _cameraController
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fadeAnimation.dispose();
    _fadeAnimationController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _cameraController.value.previewSize!.height,
                height: _cameraController.value.previewSize!.width,
                child: CameraPreview(_cameraController).blurred(
                  colorOpacity: 0.8,
                  blurColor: Colors.black,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(20),
                  ),
                  blur: 10,
                ),
              ),
            ),
          ),
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/front_logo.svg', height: 100),
              SizedBox(height: 10),
              Image.asset('assets/front.gif', height: 400, fit: BoxFit.cover),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(


                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          RecordingScreen(cameraController: _cameraController),
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
                    ),
                  );
                },
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SvgPicture.asset(
                    'assets/front_button.svg',
                    height: 70,
                  ),
                ),
              ),
              /*
            * SvgPicture.asset('assets/front_logo.svg'),
            Image.asset('assets/front.gif'),
            SvgPicture.asset('assets/front_button.svg'),*/
            ],
          ),
        ),
      ],
    );
  }
}
