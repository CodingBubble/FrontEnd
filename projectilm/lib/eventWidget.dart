import 'package:flutter/material.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/app_bars/event_app_bar.dart';

class EventWidget extends StatefulWidget {
  final String title;
  const EventWidget({super.key, required this.title});
  @override
  State<EventWidget> createState() => _EventWidget(this.title);
}

class _EventWidget extends State<EventWidget> {
  var title;
  _EventWidget(title) {
    this.title = title;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dein Event",
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_event_app_bar(context, title),
      ),
    );
  }
}
