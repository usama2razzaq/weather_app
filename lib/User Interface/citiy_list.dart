// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/Stored%20City/stored_file.dart';
import 'package:weather_app/User%20Interface/weather_details.dart';

class CityList extends StatefulWidget {
  final Function refresh;
  const CityList({Key? key, required this.refresh}) : super(key: key);

//constructor
  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  List<CityDataModel> searchResult = [];
  List<CityDataModel> cityDetails = [];

  TextEditingController controller = TextEditingController();
  List<String>? cityList;

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
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in cityDetails) {
      if (userDetail.city!.toLowerCase().contains(text)) {
        searchResult.add(userDetail);
      }
    }
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
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      widget.refresh();
                      Navigator.pop(context);
                    }),
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
                      return searchResult.length != 0 ||
                              controller.text.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchResult.length,
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
                                                  searchResult[index].city!,
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
                                          builder: (context) => WeatherDetails(
                                                ciityName: searchResult[index]
                                                    .city
                                                    .toString(),
                                              )),
                                    );
                                  },
                                );
                              })
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: cityDetails.length,
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
                                                cityDetails[index].city!,
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
                                          builder: (context) => WeatherDetails(
                                                ciityName:
                                                    cityDetails[index].city!,
                                              )),
                                    );
                                  },
                                );
                              });
                    } else {
                      return Container();
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

  Future<List<CityDataModel>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/cities/my.json');
    final list = json.decode(jsondata) as List<dynamic>;
    cityDetails = list.map((e) => CityDataModel.fromJson(e)).toList();

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
