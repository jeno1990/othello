import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:othello/bindings.dart';
import 'package:othello/controllers/user_profile_controller.dart';
import 'package:othello/presentation/screens/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitBinding(),
      title: 'Othello',
      theme: ThemeData(
        primaryColor: const Color(0xff18786a),
        primarySwatch: const MaterialColor(0xff38786a, <int, Color>{
          50: Color(0xffe0f2ef),
          100: Color(0xffb3dfd6),
          200: Color(0xff80cbbd),
          300: Color(0xff4db7a4),
          400: Color(0xff26a892),
          500: Color(0xff38786a),
          600: Color(0xff326e61),
          700: Color(0xff295c51),
          800: Color(0xff204a41),
          900: Color(0xff143127),
        }),
      ),
      home: const SplashWrapper(),
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const LandingPage(), // Your actual home
        if (_showSplash) const SplashScreenOverlay(), // Only shows for 3s
      ],
    );
  }
}

class SplashScreenOverlay extends StatefulWidget {
  const SplashScreenOverlay({super.key});

  @override
  State<SplashScreenOverlay> createState() => _SplashScreenOverlayState();
}

class _SplashScreenOverlayState extends State<SplashScreenOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnim = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Image.asset('assets/image/logo_splash.png', width: 150),
        ),
      ),
    );
  }
}
