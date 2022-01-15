// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/API%20Helper/api_helper.dart';
import 'package:weather_app/Bloc/weather_bloc.dart';
import 'package:weather_app/Model/Get_Weather_Model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Stored%20City/stored_file.dart';
import 'package:weather_app/citiy_list.dart';
import 'package:weather_app/weather_carosell.dart';

class HomeWeather extends StatefulWidget {
  const HomeWeather({Key? key}) : super(key: key);

  @override
  _HomeWeatherState createState() => _HomeWeatherState();
}

class _HomeWeatherState extends State<HomeWeather> {
  Location location = new Location();

  bool? _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final currentTime = DateTime.now();

  WeatherBloc? weatherBlock;

  String? error;
  List<String>? cityList = [
    'Kuala Lumpur',
    'Petaling Jaya',
    'George Town',
    'Shah Alam'
  ];

  bool checkLoc = false;
  bool checkDay = false;

  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  var _locationService = Location().getLocation();

  LocationData? _currentLocation;
  var hour = DateTime.now().hour;
  String? dateFormatted;

  SharedPref sharedPref = SharedPref();

  City? cityload;

  @override
  Future<void> initPlatformState() async {
    _locationData = await location.getLocation();
    _currentLocation = await _locationService;

    try {
      print('check location ios 1' "${_currentLocation?.latitude}");
      print('check location ios 1' "${_currentLocation?.longitude}");
      checkLoc = true;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print(error);
        print('eror osa ' + error!);
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = 'Permission denied';
        print('eror osa ' + error!);
      }
    }
    setState(() {
      weatherBlock!.initGetCurrentLocation(
        '${_currentLocation?.latitude}',
        '${_currentLocation?.longitude}',
      );
    });
  }

  void initState() {
    weatherBlock = WeatherBloc();
    weatherBlock!.initMultipleCities(cityList!);

    if (_currentLocation == null) {
      weatherBlock!.initGetCurrentLocation(
        lat,
        long,
      );
    } else {
      initPlatformState();
    }

    // Future.delayed(Duration(seconds: 2), () {
    // });

    setState(() {
      print("check housr   ${hour}");
      if (hour < 12) {
        checkDay == true;
        print('Morning');
      }
      if (hour < 19) {
        checkDay == true;
        print('Afternoon');
      } else {
        checkDay == false;
        print('night');
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (hour < 19)
              ? AssetImage("assets/images/day_bg.gif")
              : AssetImage("assets/images/night_bg.gif"),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0),
            leading: GestureDetector(
              child: Icon(
                Icons.menu,
              ),
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      print('refresh');

                      var _locationService = Location().getLocation();

                      initPlatformState();
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 26.0,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    print('open new page');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CityList()),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                StreamBuilder<Weather>(
                    stream: weatherBlock!.stateStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data!.dt * 1000);

                        var outputFormat =
                            DateFormat('EEE d, MMM ' 'hh:mm aaa');
                        var outputDate = outputFormat.format(date);
                        print("new date firmatted $outputDate");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingIndicator();
                        }

                        return Container(

                            // ignore: unnecessary_new
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.black.withOpacity(0.1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  //  width: 150,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Icon(
                                              !checkLoc
                                                  ? Icons.location_off
                                                  : Icons.location_on,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(snapshot.data!.name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20)),
                                          ],
                                        ),
                                        Text(outputDate,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              //  color: Colors.red,
                                              child: Image.network(
                                                'http://openweathermap.org/img/wn/${snapshot.data!.weatherDesc.icon}@2x.png',
                                                height: 70,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            // Icons(
                                            //  Image.network('http://openweathermap.org/img/wn/10d@2x.png')
                                            //   // color: Colors.white,
                                            //  // size: 60,
                                            // ),

                                            Text(
                                                "${snapshot.data!.getmainWeather.temp.round()}\u00B0C",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 50)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  color: Colors.transparent,
                                  // width: 80,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          snapshot
                                              .data!.weatherDesc.description,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          "${snapshot.data!.getmainWeather.temp_max.round()}/${snapshot.data!.getmainWeather.temp_min.round()} \u00B0C",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          "Feels like ${snapshot.data!.getmainWeather.feels_like.round()}\u00B0C",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14)),
                                    ],
                                  ),
                                )
                              ],
                            ));
                      } else {
                        return Container();
                      }
                    }),
                SizedBox(
                  height: 30,
                ),

                /* from there */
                Container(
                  width: double.maxFinite,
                  height: 200,
                  child: StreamBuilder(
                      stream: weatherBlock?.stateMutipleStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingIndicator();
                        }

                        if (snapshot.hasData) {
                          List<Weather> weatherList =
                              snapshot.data as List<Weather>;

                          return ListView.builder(
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: weatherList.length,
                              itemBuilder: (context, position) {
                                return WheatherShowcase(
                                    ciityIcon:
                                        "http://openweathermap.org/img/wn/${weatherList[position].weatherDesc.icon}@2x.png",
                                    ciityName: weatherList[position].name,
                                    ciitywheater:
                                        '${weatherList[position].getmainWeather.temp.round()}');
                              });
                        } else {
                          return Container();
                        }
                      }),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  // ignore: unnecessary_new
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.black.withOpacity(0.5)),
                  child: StreamBuilder<WeatherFocast>(
                      stream: weatherBlock!.statetWeatherForecastStream,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            for (int i = 0; i < 6; i++)
                              Container(
                                color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Tuesday",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Image.asset(
                                            "assets/images/icons8-humidity-64.png",
                                            height: 15,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("80%",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.wb_sunny_rounded,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("27/33 \u00B0C",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // void _update() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   cityList = prefs.getStringList('city');
  //   if (cityList != null) {
  //     print('city list' '${cityList!.length}');
  //     for (int i = 0; i < cityList!.length; i++) {}
  //   } else {}
  // }

  Future<List<CityDataModel>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/cities/my.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => CityDataModel.fromJson(e)).toList();
  }
}

class CityDataModel {
  //data Type
  String? city;

// constructor
  CityDataModel({
    this.city,
  });
  //method that assign values to respective datatype vairables
  CityDataModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }
}

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]));
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(strokeWidth: 3),
            width: 32,
            height: 32),
        padding: EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading(context) {
    return Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
