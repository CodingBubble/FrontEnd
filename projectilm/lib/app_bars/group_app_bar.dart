import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_group_app_bar(BuildContext context, Function onSearch, bool archived) {
  return AppBar(
    backgroundColor: widgetColor,
    automaticallyImplyLeading: false,
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: secondaryTextColor),
              color: backgroundColor,
              onPressed: () => {
                AppHandler("mainWidget", context, []),
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.groups, color: secondaryTextColor),
              color: backgroundColor,
              onPressed: () => {
                AppHandler("groupMembersWidget", context, []),
              },
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextFormField(
                style: TextStyle(color: secondaryTextColor),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Suche",
                  hintStyle: TextStyle(color: primaryTextColor),
                  floatingLabelStyle: TextStyle(color: variationColor),
                ),
                onChanged: (value) => onSearch(value),
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.settings_sharp, color: secondaryTextColor),
              color: backgroundColor,
              onPressed: () => {
                AppHandler("groupSettingsWidget", context, []),
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(archived?Icons.timer:Icons.archive, color: secondaryTextColor),
              color: backgroundColor,
              onPressed: () => {
                AppHandler("groupWidget", context, [!archived]),
              },
            ),
          ),

        ],
      ),
    ),
  );
}
