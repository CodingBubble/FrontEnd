import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/notification.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'controlWidget.dart';
import 'login.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() {
  get_saved_mode();
  Noti.initialize(notificationsPlugin);
  runApp(const controlWidget());
  //runApp(const logInWidget(title: "TestApp",  ));
  //runApp(const mainWidget(title: "TestApp",  ));
}
