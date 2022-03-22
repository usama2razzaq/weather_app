import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/User%20Interface/weather_home.dart';
import 'package:location/location.dart' as CL;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CL.Location location = new CL.Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  CL.LocationData? _locationData;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeWeather()),
        (Route<dynamic> route) => false,
      );
    });
  }

  void getPermissiom() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              gradient: LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.2),
                  Colors.amber.withOpacity(0.7)
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.2),
                radius: 75.0,
                child: Lottie.asset('assets/lottie/61302-weather-icon.json',
                    repeat: false),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
              Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
