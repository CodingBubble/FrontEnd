// ignore_for_file: prefer_const_constructors

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/app_bars/event_app_bar.dart';

class EventWidget extends StatefulWidget {
  final int state;
  const EventWidget({super.key, required this.state});
  @override
  State<EventWidget> createState() => _EventWidget(state);
}

class _EventWidget extends State<EventWidget> {
  int state;
  _EventWidget(this.state);
  @override
  Widget build(BuildContext context) {
    void t()=>{};
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dein Event",
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_event_app_bar(context, current_event!.name),
        drawer: new Drawer(
        backgroundColor: widgetColor,
        width: MediaQuery.of(context).size.width * 0.2,
        child: new ListView(
          children: <Widget> [
            Container(height:  MediaQuery.of(context).size.height * 0.1),
            new ListTile(
              title: new Icon(
                Icons.announcement,
                color: primaryTextColor
              ),
              onTap: () {AppHandler("EventWidget", context, [0]);},
            ),
            new ListTile(
              title: new Icon(
                Icons.chat,
                color: primaryTextColor
              ),
              onTap: () {AppHandler("EventWidget", context, [1]);},
            ),
            new ListTile(
              title: new Icon(
                Icons.list,
                color: primaryTextColor
              ),
              onTap: () {AppHandler("EventWidget", context, [2]);},
            ),
            new ListTile(
              title: new Icon(
                Icons.where_to_vote,
                color: primaryTextColor
              ),
              onTap: () {AppHandler("EventWidget", context, [3]);},
            ),
          ],
        )
      ),
      body: new Center(
        child: get_body(state)
        )
      ),

    );
  }
}

Widget get_body(int i){
  switch (i) {
    case 0:
      return Container();
    case 1:
      return Container();
    case 2:
      return Container();
    case 3:
      return Container();
  }
  return Container();
}