import 'package:flutter/material.dart';
import 'package:weather_app/weather_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Focast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeWeather(),
    );
  }
}