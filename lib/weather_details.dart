// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Bloc/weather_bloc.dart';
import 'package:weather_app/Model/Get_Weather_Model.dart';
import 'package:weather_app/Stored%20City/stored_file.dart';

class WeatherDetails extends StatefulWidget {
  String ciityName;

  WeatherDetails({
    Key? key,
    this.ciityName = "",
  }) : super(key: key);

  @override
  _WeatherDetailsState createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  bool? _serviceEnabled = false;
  final currentTime = DateTime.now();

  WeatherBloc? weatherBlock;

  String? error;

  bool checkLoc = false;
  bool checkDay = false;

  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');

  var hour = DateTime.now().hour;
  String? dateFormatted;

  City? cityload;

  @override
  void initState() {
    weatherBlock = WeatherBloc();
    weatherBlock!.initGetCity(widget.ciityName);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
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
            iconTheme: IconThemeData(
              color: Colors.black.withOpacity(0.6),
            ),
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {},
                  child: Center(
                    child: Text(
                      'Add to favorite',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      // ignore: avoid_print
                      print('fave');
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 26.0,
                      color: Colors.black.withOpacity(0.6),
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
                        final DateTime date =
                            DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data!.dt * 1000);

                        var outputFormat =
                            DateFormat('EEE d, MMM ' 'hh:mm aaa');
                        var outputDate = outputFormat.format(date);
                        // ignore: avoid_print
                        print("new date firmatted $outputDate");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingIndicator();
                        }

                        return Container(
                            decoration: BoxDecoration(
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
                                            SizedBox(
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
                        return Container(
                          color: Colors.amber,
                        );
                      }
                    }),
                SizedBox(
                  height: 30,
                ),
                Container(
                  // ignore: unnecessary_new
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.black.withOpacity(0.5)),
                  child: Column(
                    children: [
                      for (int i = 0; i < 6; i++)
                        Container(
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  // ignore: prefer_const_literals_to_create_immutables
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
                  ),
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

  // Future<List<CityDataModel>> ReadJsonData() async {
  //   final jsondata =
  //       await rootBundle.rootBundle.loadString('assets/cities/my.json');
  //   final list = json.decode(jsondata) as List<dynamic>;

  //   return list.map((e) => CityDataModel.fromJson(e)).toList();
  // }
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
