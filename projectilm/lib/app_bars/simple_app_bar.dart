import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_simple_app_bar(BuildContext context, title) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryTextColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: discanceBetweenWidgets),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 2),
            child: Text(
              title,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: descriptionfontOfWidget,
              ),
            ),
          ),
        ),
      ],
    ),
    backgroundColor: widgetColor,
  );
}
