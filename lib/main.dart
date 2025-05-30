import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:othello/bindings.dart';
import 'package:othello/presentation/screens/home_page.dart';
import 'package:othello/presentation/screens/landing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitBinding(),
      title: 'Othello',
      theme: ThemeData(
        primaryColor: Color(0xff18786a),
        primarySwatch: MaterialColor(0xff38786a, <int, Color>{
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
      home: LandingPage(),
    );
  }
}
