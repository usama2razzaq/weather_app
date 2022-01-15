// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// ignore_for_file: avoid_print

import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String Apiey = "28b2d803b67e000c521ab9d983a00cbb";

const String lat = "3.1431";
const String long = "101.6865";
List<String>? cityList = [];

class ApiHelper {
  Map<String, String> headers = {"Content-Type": "application/json"};

  Future<Response> initGet(String endpoint) async {
    var response = await post(Uri.parse(endpoint), headers: headers);
    print(response.body);

    return response;
  }
}
