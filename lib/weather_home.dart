// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
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
  Location location = Location();

  bool? loading = false;
  PermissionStatus? permissionGranted;
  LocationData? locationData;
  final currentTime = DateTime.now();

  WeatherBloc? weatherBlock;

  String? error;

  bool checkLoc = false;
  bool checkDay = false;

  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  var locationService = Location().getLocation();

  LocationData? currentLocation;
  var hour = DateTime.now().hour;
  String? dateFormatted;

  SharedPref sharedPref = SharedPref();

  City? cityload;
  refresh() {
    setState(() {
      weatherBlock = WeatherBloc();

      getCityList();

      if (currentLocation == null) {
        weatherBlock!.initGetCurrentLocation(
          lat,
          long,
        );
      } else {
        initPlatformState();
      }
    });
  }

  @override
  Future<void> initPlatformState() async {
    locationData = await location.getLocation();
    currentLocation = await locationService;

    try {
      print('check location ios 1' "${currentLocation?.latitude}");
      print('check location ios 1' "${currentLocation?.longitude}");
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
        '${currentLocation?.latitude}',
        '${currentLocation?.longitude}',
      );
    });
  }

  void getCityList() async {
    cityList = ['Kuala Lumpur', 'Petaling Jaya', 'George Town', 'Shah Alam'];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('city') == null) {
      print('new city list $cityList');
      weatherBlock!.initMultipleCities(cityList!);
    } else {
      print('new city list $cityList');
      cityList = prefs.getStringList('city');
      weatherBlock!.initMultipleCities(cityList!);
    }
  }

  @override
  void initState() {
    weatherBlock = WeatherBloc();

    getCityList();

    if (currentLocation == null) {
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
    return RefreshIndicator(
      onRefresh: () => initPlatformState(),
      child: Scaffold(
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
                  onTap: () async {
                    print('open new page');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CityList(
                                refresh: refresh,
                              )),
                    );
                  },
                ),
                actions: [
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          var _locationService = Location().getLocation();

                          initPlatformState();
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 26.0,
                        ),
                      )),
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
                            weatherBlock!
                                .initGetForecasrCity(snapshot.data!.name);
                            final DateTime date =
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data!.dt * 1000);

                            var outputFormat =
                                DateFormat('EEE d, MMM ' 'hh:mm aaa');
                            var outputDate = outputFormat.format(date);
                            print("new date firmatted $outputDate");
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }

                            return Container(

                                // ignore: unnecessary_new
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.black.withOpacity(0.1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              snapshot.data!.weatherDesc
                                                  .description,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              "${snapshot.data!.getmainWeather.temp_max.round()}/${snapshot.data!.getmainWeather.temp_min.round()} \u00B0C",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              "Feels like ${snapshot.data!.getmainWeather.feels_like.round()}\u00B0C",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
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
                    SizedBox(
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
                              return Container(
                                color: Colors.amber,
                                child: Center(
                                  child: LoadingIndicator(),
                                ),
                              );
                            }
                          }),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black.withOpacity(0.5)),
                      child: StreamBuilder<List<WeatherFocast>>(
                          stream: weatherBlock!.statetWeatherForecastStream,
                          builder: (context, snapshot) {
                            final dateFormated =
                                DateFormat('EEE d,' 'hh:mm aaa');
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingIndicator();
                            }
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      color: Colors.transparent,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Text(
                                                    dateFormated.format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            snapshot.data![i]
                                                                    .dt *
                                                                1000)),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                Text(
                                                    "${snapshot.data![i].getmainWeather.humidity}%",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                Image.network(
                                                  "http://openweathermap.org/img/wn/${snapshot.data![i].weatherDesc.icon}@2x.png",
                                                  height: 20,
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("27/33 \u00B0C",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                SizedBox(
                                                  width: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return Container(
                                color: Colors.amber,
                                child: Center(
                                  child: LoadingIndicator(),
                                ),
                              );
                            }
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cityList = prefs.getStringList('city');
    if (cityList != null) {
      print('city list ${cityList!.length}');
      // for (int i = 0; i < cityList!.length; i++) {}
    } else {
      print('city list is empty');
    }
  }

  Future<List<CityDataModel>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/cities/my.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => CityDataModel.fromJson(e)).toList();
  }
}

class $ {}

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
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        color: Colors.transparent,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getLoadingIndicator(),
            ]));
  }

  Container _getLoadingIndicator() {
    return Container(
        child: Lottie.asset('assets/cities/61302-weather-icon.json'),
        //
        width: 100,
        height: 100);
  }
}
