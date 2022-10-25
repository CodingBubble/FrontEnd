import 'package:flutter/material.dart';
import 'mainWidget.dart';
import 'global.dart';
import 'login.dart';

class controlWidget extends StatelessWidget {
  const controlWidget({super.key});

  @override
  Widget build(BuildContext context) {

    // unfinished
    if (1 == 0) {
      return MaterialApp(
        title: 'Grouping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const mainWidget(title: 'Grouping'),
      );
    } else {
      return MaterialApp(
        title: 'Grouping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const logInWidget(title: 'Grouping'),
      );
    }
  }
}
