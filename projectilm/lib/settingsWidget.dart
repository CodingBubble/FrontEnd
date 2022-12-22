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
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  AppHandler("mainWidget", context, const []);
                },
              ),
              const Text("Einstellungen",
                  style: TextStyle(color: backgroundColor))
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
  themeSettings(),
  generalSettings(),
  // securitySettings()
];

Widget generalSettings() {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  return (Container(
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: WidgetColor,
      child: Column(
        children: [
          //headline
          const Text(
            "Account",
            style:
                TextStyle(color: primaryTextColor, fontSize: GigafontOfWidget),
          ),
          const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Gebe dein neues Passwort ein',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gebe ein neues Passwort ein';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        // Process data.
                      }
                    },
                    child: const Text('Passwort ändern'),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
        ],
      )));
}

Widget themeSettings() {
  return (Container(
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: WidgetColor,
      child: Column(
        children: [
          //headline
          const Text(
            "Aussehen",
            style:
                TextStyle(color: primaryTextColor, fontSize: GigafontOfWidget),
          ),
          const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    iconSize: 50,
                    icon: const Icon(Icons.sunny, color: Colors.yellow)),
                const Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets),
                ),
                IconButton(
                    onPressed: () {},
                    iconSize: 50,
                    icon: const Icon(Icons.shield_moon)),
                const Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.color_lens_outlined),
                    iconSize: 50,
                    color: Colors.brown),
                const Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets),
                ),
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(discanceBetweenWidgets),
                  ),
                  ColoredBox(
                    color: variationColor,
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets),
                          ),
                          Text(
                            'Überschrift',
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: SecondfontOfWidget,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets),
                          ),
                          Text(
                            'Text',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: SecondfontOfWidget,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets),
                          ),
                          Text(
                            'Boxen',
                            style: TextStyle(
                              color: WidgetColor,
                              fontSize: SecondfontOfWidget,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets),
                          ),
                          Text(
                            'Hintergrund',
                            style: TextStyle(
                              color: backgroundColor,
                              fontSize: SecondfontOfWidget,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ],
      )));
}

// Widget securitySettings() {
//   return (Container(
//       padding: constPadding,
//       margin: constMargin,
//       width: double.infinity,
//       color: WidgetColor,
//       child: Column(
//         children: [
//           //headline
//           const Text("Datenschutz und Sicherheit"),
//           ElevatedButton(
//               child: const Text("...",
//                   style: TextStyle(
//                       color: textColor, fontSize: SecondfontOfWidget)),
//               onPressed: () {}),
//           const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
//           ElevatedButton(child: const Text("..."), onPressed: () {})
//         ],
//       )));
// }
