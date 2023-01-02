import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/eventWidget.dart';
import 'package:projectilm/groupWidget.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_event_app_bar(BuildContext context, Function toggle_join) {
  return AppBar(
      backgroundColor: widgetColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: IconButton(
              // go back button
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: IconButton(
                onPressed: () => toggle_join(),
                icon: Icon(Icons.back_hand, color: get_join_button_color(),)),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: IconButton(
                onPressed: () =>
                    {AppHandler("eventWidget", context, [4])},
                icon: Icon(Icons.group)),
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



Color get_join_button_color() => joined_event ? positiveColor:negativeColor; 
