import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groupWidget.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_event_app_bar(BuildContext context, title) {
  return AppBar(
      backgroundColor: widgetColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: IconButton(
              // go back button
              onPressed: () => {AppHandler("groupWidget", context, [])},
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(title, //title of widget: "This is your event"
                style: TextStyle(
                    color: primaryTextColor, fontSize: HeadfontOfWidget)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: IconButton(
                // button to enter weather enjoying the event or not
                onPressed: () =>
                    {"Give you a Choice weather enjoying the event or not"},
                icon: Icon(Icons.back_hand)),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: IconButton(
                  // button for settings
                  onPressed: () => {AppHandler("eventSettings", context, [])},
                  icon: Icon(Icons.settings))),
        ],
      ));
}
