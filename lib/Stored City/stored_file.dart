// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class City {
  String name;
  String wheather;

  City({required this.name, required this.wheather});

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(name: parsedJson['name'], wheather: parsedJson['wheather']);
  }

  Map<String, dynamic> toJson() {
    return {"name": this.name, "wheather": this.wheather};
  }
}

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
