// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/Stored%20City/stored_file.dart';
import 'package:weather_app/weather_details.dart';

class CityList extends StatefulWidget {
  const CityList({Key? key}) : super(key: key);

  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  List<CityDataModel> _searchResult = [];
  List<CityDataModel> _cityDetails = [];

  SharedPref sharedPref = SharedPref();
  TextEditingController controller = TextEditingController();
  List<String>? cityList;
  City? citySave;
  var hour = DateTime.now().hour;

  void initState() {
    ReadJsonData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _cityDetails.forEach((userDetail) {
      if (userDetail.city!.toLowerCase().contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Select City',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(
                color: Colors.transparent,
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: 'Search City', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.79,
                // padding: EdgeInsets.all(20),
                child: FutureBuilder(
                  future: ReadJsonData(),
                  builder: (context, data) {
                    if (data.hasError) {
                      return Center(child: Text("${data.error}"));
                    } else if (data.hasData) {
                      var items = data.data as List<CityDataModel>;
                      return Expanded(
                          child: _searchResult.length != 0 ||
                                  controller.text.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _searchResult.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Card(
                                        // ignore: unnecessary_new
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 5),
                                        color: Colors.black.withOpacity(0.1),
                                        elevation: 1,
                                        child: Container(
                                            //color: Colors.amber,
                                            padding: EdgeInsets.all(20),
                                            child: Expanded(
                                                child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, right: 8),
                                                    child: Text(
                                                      _searchResult[index]
                                                              .city! +
                                                          ' ' +
                                                          _searchResult[index]
                                                              .city!,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WeatherDetails(
                                                    ciityName: items[index]
                                                        .city
                                                        .toString(),
                                                  )),
                                        );
                                      },
                                    );
                                  })
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _cityDetails.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Card(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 5),
                                          color: Colors.black.withOpacity(0.1),
                                          elevation: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  child: Text(
                                                    _cityDetails[index].city! +
                                                        ' ' +
                                                        _cityDetails[index]
                                                            .city!,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WeatherDetails(
                                                    ciityName: items[index]
                                                        .city
                                                        .toString(),
                                                  )),
                                        );
                                      },
                                    );
                                  }));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
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
    _cityDetails = list.map((e) => CityDataModel.fromJson(e)).toList();

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
