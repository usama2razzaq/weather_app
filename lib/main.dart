import 'package:flutter/material.dart';
import 'package:weather_app/User%20Interface/splash_screen.dart';
import 'package:weather_app/User%20Interface/weather_home.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final title = '';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
