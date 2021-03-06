// ignore_for_file: avoid_print, constant_identifier_names

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
  final eventStreamController = StreamController<Weather_Event>.broadcast();

  StreamSink get eventSink => eventStreamController.sink;
  Stream get _eventStream => eventStreamController.stream;

  final stateStreamController = StreamController<Weather>();

  StreamSink get _stateSink => stateStreamController.sink;
  Stream<Weather> get stateStream => stateStreamController.stream;

  final stateStreamMultipleController = StreamController<List<Weather>>();

  StreamSink get _stateMutipleSink => stateStreamMultipleController.sink;

  Stream<List<Weather>> get stateMutipleStream =>
      stateStreamMultipleController.stream;

  final stateWeatherForecastStreamController =
      StreamController<List<WeatherFocast>>();

  StreamSink<List<WeatherFocast>> get _stateWeatherForecastSink =>
      stateWeatherForecastStreamController.sink;
  Stream<List<WeatherFocast>> get statetWeatherForecastStream =>
      stateWeatherForecastStreamController.stream;

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

  void initGetForecasrCity(
    String city,
  ) {
    city2 = city;

    eventSink.add(Weather_Event.GET_WEATHER_FORECAST_5_DAYS);
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
      } else if (event == Weather_Event.GET_WEATHER_FORECAST_5_DAYS) {
        final url =
            "https://api.openweathermap.org/data/2.5/forecast?q=$city2&appid=28b2d803b67e000c521ab9d983a00cbb&units=metric";

        Response response = await ApiHelper().initGet(url);
        print(response.body);
        if (response.statusCode == 200) {
          List responseData = json.decode(response.body)["list"] as List;

          print('forecast list ${response.body}');

          _stateWeatherForecastSink
              .add(responseData.map((e) => WeatherFocast.fromJson(e)).toList());

          print('sucess');
        } else {
          print('failed');
        }
      }
    });
  }

  void dispose() {}
}

// String extractDateString(String dateTimeString) {
//   DateTime dateTime = DateTime.parse(dateTimeString);
//   String day = dateTime.day.toString().padLeft(2, '0');
//   String month = dateTime.month.toString().padLeft(2, '0');
//   String year = dateTime.year.toString().padLeft(4, '0');
//   return '$day.$month.$year';
// }
