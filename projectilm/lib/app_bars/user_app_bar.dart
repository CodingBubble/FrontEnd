import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groupWidget.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_user_app_bar(BuildContext context) {
  return AppBar(
    backgroundColor: widgetColor,
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(builder: (BuildContext context) {
            return (IconButton(
              icon: Icon(Icons.search),
              color: backgroundColor,
              onPressed: () => {},
            )); // here to add the onPressed-command to search something
          }),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Suche",
              ),
            ),
          ),
          Builder(builder: (BuildContext context) {
            return (IconButton(
                icon: Icon(Icons.settings),
                color: backgroundColor,
                onPressed: () => {
                      AppHandler("settingsWidget", context, [])
                    })); //here to add the onPressed-command to navigate to settings
          }),
          Builder(builder: (BuildContext context) {
            return (IconButton(
                icon: Icon(Icons.edit),
                color: backgroundColor,
                onPressed: () =>
                    {})); //here to add the onPressed-command to navigate to settings
          })
        ],
      ),
    ),
  );
}