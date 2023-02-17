import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/eventWidget.dart';
import 'package:projectilm/groupWidget.dart';
import '../alert_fnc.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_event_app_bar(BuildContext context, Function toggle_join, index) {
  switch (index) {
    case -1:
      {
        return AppBar(
          backgroundColor: widgetColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                  // go back button
                  onPressed: () => {AppHandler("groupWidget", context, [])},
                  icon: Icon(Icons.arrow_back, color: secondaryTextColor),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                    onPressed: () => toggle_join(),
                    icon: Icon(
                      Icons.back_hand,
                      color: get_join_button_color(),
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                    onPressed: () => {
                          AppHandler("eventWidget", context, [4])
                        },
                    icon: Icon(Icons.group, color: secondaryTextColor)),
              ),
              ret_if(
                current_event!.creator_id == me!.id,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: IconButton(
                    // button for settings
                    onPressed: () =>
                        {AppHandler("eventSettingsWidget", context, [])},
                    icon: Icon(Icons.settings, color: secondaryTextColor),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      }
    case 0:
      {
        return AppBar(
          backgroundColor: widgetColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                  // go back button
                  onPressed: () => {
                    AppHandler("eventWidget", context, [-1])
                  },
                  icon: Icon(Icons.arrow_back, color: secondaryTextColor),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: discanceBetweenWidgets),
              ),
              Expanded(
                child: Text(
                    style: TextStyle(color: primaryTextColor), "Ankündigungen"),
              ),
            ],
          ),
        );
        break;
      }
    case 1:
      {
        return AppBar(
          backgroundColor: widgetColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                  // go back button
                  onPressed: () => {
                    AppHandler("eventWidget", context, [-1])
                  },
                  icon: Icon(Icons.arrow_back, color: secondaryTextColor),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: discanceBetweenWidgets),
              ),
              Expanded(
                child: Text(
                    style: TextStyle(color: primaryTextColor), "Event-Chat"),
              ),
            ],
          ),
        );
        break;
      }
    case 2:
      {
        return AppBar(
          backgroundColor: widgetColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                  // go back button
                  onPressed: () => {
                    AppHandler("eventWidget", context, [-1])
                  },
                  icon: Icon(Icons.arrow_back, color: secondaryTextColor),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: discanceBetweenWidgets),
              ),
              Expanded(
                child: Text(
                    style: TextStyle(color: primaryTextColor), "Einkaufsliste"),
              ),
            ],
          ),
        );
        break;
      }
    case 3:
      {
        return AppBar(
          backgroundColor: widgetColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                  // go back button
                  onPressed: () => {
                    AppHandler("eventWidget", context, [-1])
                  },
                  icon: Icon(Icons.arrow_back, color: secondaryTextColor),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: discanceBetweenWidgets),
              ),
              Expanded(
                child:
                    Text(style: TextStyle(color: primaryTextColor), "Umfragen"),
              ),
            ],
          ),
        );
        break;
      }
    case 4:
      {
        return AppBar(
          backgroundColor: widgetColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.15,
                child: IconButton(
                  // go back button
                  onPressed: () => {
                    AppHandler("eventWidget", context, [-1])
                  },
                  icon: Icon(Icons.arrow_back, color: secondaryTextColor),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: discanceBetweenWidgets),
              ),
              Expanded(
                child: Text(
                    style: TextStyle(color: primaryTextColor), "Mitglieder"),
              ),
            ],
          ),
        );
        break;
      }
    default:
      return AppBar();
  }
}

Color get_join_button_color() => joined_event ? positiveColor : negativeColor;
