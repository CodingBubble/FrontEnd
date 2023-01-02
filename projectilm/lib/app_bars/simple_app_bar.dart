import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groupWidget.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_simple_app_bar(BuildContext context, title) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color:secondaryTextColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
         Text(title, style: TextStyle(color: primaryTextColor))
      ],
    ),
    backgroundColor: widgetColor,
  );
}
