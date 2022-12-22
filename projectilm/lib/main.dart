import 'package:flutter/material.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/mainWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'controlWidget.dart';
import 'login.dart';

void main() {
  get_saved_mode();
  runApp(const controlWidget());
  //runApp(const logInWidget(title: "TestApp",  ));
  //runApp(const mainWidget(title: "TestApp",  ));
}
