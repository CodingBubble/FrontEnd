import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groupWidget.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_settings_app_bar(context) {
  return AppBar(
    title: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppHandler("mainWidget", context, const []);
          },
        ),
         Text("Einstellungen", style: TextStyle(color: backgroundColor))
      ],
    ),
    backgroundColor: widgetColor,
  );
}
