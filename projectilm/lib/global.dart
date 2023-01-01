import 'package:flutter/material.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:shared_preferences/shared_preferences.dart';

const color_modes = {
  "light" : {
    "background_color": Colors.white,
    "primaryTextColor": Color.fromARGB(255, 76, 76, 76),
    "secondaryTextColor": Color.fromARGB(255, 0, 0, 0),
    "widgetColor": Color.fromARGB(255, 150, 150, 150),
    "variationColor": Color.fromARGB(255, 45, 92, 147),
  },

   "dark" : {
    "background_color":  Color.fromARGB(255, 52, 52, 52),
    "primaryTextColor": Color.fromARGB(255, 191, 191, 191),
    "secondaryTextColor": Color.fromARGB(255, 250, 250, 250),
    "widgetColor": Color.fromARGB(255, 39, 39, 39),
    "variationColor": Color.fromARGB(255, 95, 138, 184),
  },

  
   "color" : {
    "background_color":  Colors.white,
    "primaryTextColor": Color.fromARGB(255, 232, 232, 232),
    "secondaryTextColor": Color.fromARGB(255, 185, 185, 185),
    "widgetColor": Color.fromARGB(255, 0, 99, 212),
    "variationColor": Color.fromARGB(255, 78, 168, 0),
  },
  
};


Color backgroundColor = color_modes["light"]!["background_color"]!;
Color primaryTextColor = color_modes["light"]!["primaryTextColor"]!;
Color secondaryTextColor = color_modes["light"]!["secondaryTextColor"]!;
Color widgetColor = color_modes["light"]!["widgetColor"]!;
Color variationColor = color_modes["light"]!["variationColor"]!;

Future set_color_variation(String mode) async
{
  backgroundColor = color_modes[mode]!["background_color"]!;
  primaryTextColor = color_modes[mode]!["primaryTextColor"]!;
  secondaryTextColor = color_modes[mode]!["secondaryTextColor"]!;
  widgetColor = color_modes[mode]!["widgetColor"]!;
  variationColor = color_modes[mode]!["variationColor"]!;
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("mode", mode);
}


Future get_saved_mode() async {
  final prefs = await SharedPreferences.getInstance();
  String mode = await prefs.getString("mode") ?? "";
  if (mode!="")
    set_color_variation(mode);
}




// padding and margin
const constPadding = EdgeInsets.all(10);
const constMargin = EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10);
const discanceBetweenWidgets = 8.0;

// Size of different fonts
const GigafontOfWidget = 40.0;
const HeadfontOfWidget = 30.0;
const SecondfontOfWidget = 20.0;

Group? current_group;
Event? current_event;