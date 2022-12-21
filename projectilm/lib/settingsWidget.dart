import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groupWidget.dart';
import 'main.dart';
import 'global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key, required this.title});

  final String title;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  AppHandler("mainWidget", context, []);
                },
              ),
              Text("Einstellungen", style: TextStyle(color: backgroundColor))
            ],
          ),
          backgroundColor: WidgetColor,
        ),
        body: Scrollbar(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Material(
                child: Column(
                  children: [
                    SizedBox(
                      child: settingCathegories[index],
                    ),
                  ],
                ),
              );
            },
            itemCount: settingCathegories.length,
          ),
        ),
      ),
    );
  }
}

List<Widget> settingCathegories = <Widget>[
  generalSettings(),
  themeSettings(),
  securitySettings()
];

Widget generalSettings() {
  return (Container(
      child: Column(
        children: [
          //headline
          Text("Allgemein"),
          ElevatedButton(
            child: Container(
              child: Text("...",
                  style: TextStyle(
                      color: secondaryTextColor, fontSize: SecondfontOfWidget)),
            ),
            onPressed: () {},
          )
        ],
      ),
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: WidgetColor));
}

Widget themeSettings() {
  return (Container(
      child: Column(
        children: [
          //headline
          Text("Design"),
          ElevatedButton(
              child: Text("...",
                  style: TextStyle(
                      color: secondaryTextColor, fontSize: SecondfontOfWidget)),
              onPressed: () {}),
          Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
          ElevatedButton(child: Text("..."), onPressed: () {}),
        ],
      ),
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: WidgetColor));
}

Widget securitySettings() {
  return (Container(
      child: Column(
        children: [
          //headline
          Text("Datenschutz und Sicherheit"),
          ElevatedButton(
              child: Text("...",
                  style: TextStyle(
                      color: primaryTextColor, fontSize: SecondfontOfWidget)),
              onPressed: () {}),
          Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
          ElevatedButton(child: Text("..."), onPressed: () {})
        ],
      ),
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: WidgetColor));
}
