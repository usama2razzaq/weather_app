// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/Stored%20City/stored_file.dart';

class CityList extends StatefulWidget {
  const CityList({Key? key}) : super(key: key);

  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  SharedPref sharedPref = SharedPref();
  List<String>? cityList;
  City? citySave;

  void initState() {
    ReadJsonData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Select City',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              var items = data.data as List<CityDataModel>;
              return ListView.builder(
                  itemCount: items == null ? 0 : items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Card(
                        // ignore: unnecessary_new
                        margin: new EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        color: Colors.black.withOpacity(0.1),
                        elevation: 1,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Expanded(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      items[index].city.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                      ),
                      onTap: () {
                        _add(context, '${items[index].city}');
                      },
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  void showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar((snackBar));
  }

  void _add(BuildContext context, String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cityList?.add(city);

    prefs.setStringList('city', cityList!);
    showSnackBar(context, 'Your city was added');
  }

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
