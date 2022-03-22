// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WheatherShowcase extends StatefulWidget {
  String ciityName, ciitywheater, ciityIcon;

  WheatherShowcase({
    this.ciityName = "",
    this.ciitywheater = "",
    this.ciityIcon = "",
  });

  @override
  State<StatefulWidget> createState() {
    return _WheatherShowcase();
  }
}

class _WheatherShowcase extends State<WheatherShowcase> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                // ignore: unnecessary_new
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black.withOpacity(0.1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      //  color: Colors.red,
                      child: Image.network(
                        widget.ciityIcon,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(widget.ciitywheater,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 30)),
                    Text("\u00B0C",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 20)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Text(widget.ciityName,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                              fontSize: 12)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
