// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:weather_app/API%20Helper/api_helper.dart';
import 'package:weather_app/Model/Get_Weather_Model.dart';

enum Weather_Event {
  GET_CURRENT_WEATHER,
  GET_WEATHER_BY_CITY,
  GET_MULTIPLE_WEATHER,
  GET_WEATHER_FORECAST_5_DAYS
}

class WeatherBloc {
  String? lat, long;
  String? city2;
  final eventStreamController = new StreamController<Weather_Event>.broadcast();

  StreamSink get eventSink => eventStreamController.sink;
  Stream get _eventStream => eventStreamController.stream;

  final stateStreamController = new StreamController<Weather>();

  StreamSink get _stateSink => stateStreamController.sink;
  Stream<Weather> get stateStream => stateStreamController.stream;

  final stateStreamMultipleController = new StreamController<List<Weather>>();

  StreamSink get _stateMutipleSink => stateStreamMultipleController.sink;
  Stream<List<Weather>> get statestateMutipleStream =>
      stateStreamMultipleController.stream;

  final stateUserWalletStreamController = new StreamController<Weather>();

  StreamSink<Weather> get _stateUserWalletSink =>
      stateUserWalletStreamController.sink;
  Stream<Weather> get stateUserWalletStream =>
      stateUserWalletStreamController.stream;
  HashMap<String, dynamic> params = new HashMap<String, dynamic>();
  void initGetCurrentLocation(
    // BuildContext context,
    String lat,
    long,
  ) {
    this.lat = lat;
    this.long = long;

    eventSink.add(Weather_Event.GET_CURRENT_WEATHER);
  }

  List<String> multipleList = [];

  void initMultipleCities(List<String> multipleList) {
    this.multipleList = multipleList;
    eventSink.add(Weather_Event.GET_MULTIPLE_WEATHER);
  }

  void initGetCity(
    String city,
  ) {
    city2 = city;

    eventSink.add(Weather_Event.GET_WEATHER_BY_CITY);
  }

  List<Weather> weatherList = [];

  WeatherBloc() {
    _eventStream.listen((event) async {
      if (event == Weather_Event.GET_CURRENT_WEATHER) {
        // _stateSink.add("load");
        final url =
            'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=28b2d803b67e000c521ab9d983a00cbb&units=metric';
        print(url);
        Response response = await ApiHelper().initGet(url);
        print(response.body);
        if (response.statusCode == 200) {
          Weather weathers = Weather.fromJson(jsonDecode(response.body));

          _stateSink.add(weathers);

          print('sucess');
        } else {
          print('failed');
        }
      } else if (event == Weather_Event.GET_WEATHER_BY_CITY) {
        final url =
            "https://api.openweathermap.org/data/2.5/weather?q=$city2&appid=28b2d803b67e000c521ab9d983a00cbb&units=metric";

        Response response = await ApiHelper().initGet(url);
        print(response.body);
        if (response.statusCode == 200) {
          Weather weathers = Weather.fromJson(jsonDecode(response.body));

          _stateSink.add(weathers);

          print('sucess');
        } else {
          print('failed');
        }
      } else if (event == Weather_Event.GET_MULTIPLE_WEATHER) {
        weatherList.clear();

        int i = 0;

        multipleList.forEach((element) async {
          //   https://api.openweathermap.org/data/2.5/forecast?q= Kuala Lumpur&appid=28b2d803b67e000c521ab9d983a00cbb&units=metric
          final url =
              "https://api.openweathermap.org/data/2.5/weather?q=$element&appid=28b2d803b67e000c521ab9d983a00cbb&units=metric";
          Response response = await ApiHelper().initGet(url);

          if (response.statusCode == 200) {
            weatherList.add(Weather.fromJson(jsonDecode(response.body)));

            print('sucess');
          } else {
            print('failed');
          }

          if (weatherList.length == multipleList.length) {
            _stateMutipleSink.add(weatherList);
          }

          i += 1;
        });
      }
    });
  }

  void dispose() {}
}
