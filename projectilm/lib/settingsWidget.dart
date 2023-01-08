import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groupWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';

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
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Einstellungen"),
        body: Scrollbar(
          child: ListView.builder(
            itemBuilder: (context, index) {
              var settingCathegories =
                  get_setting_category(update_color, context);
              return Material(
                color: backgroundColor,
                child: Column(
                  children: [
                    SizedBox(
                      child: settingCathegories[index],
                    ),
                  ],
                ),
              );
            },
            itemCount: get_setting_category(update_color, context).length,
          ),
        ),
      ),
    );
  }

  void update_color(String mode) {
    set_color_variation(mode);
    setState(() {});
  }
}

List<Widget> get_setting_category(
    void Function(String mode) update_color, BuildContext context) {
  return <Widget>[
    themeSettings(update_color),
    generalSettings(context),
    // securitySettings()
  ];
}

Widget generalSettings(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController password_controller = TextEditingController();
  return (Container(
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: widgetColor,
      child: Column(
        children: [
          //headline
          Text(
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
                  style: TextStyle(color: primaryTextColor),
                  controller: password_controller,
                  decoration: InputDecoration(
                    hintText: 'Gebe dein neues Passwort ein',
                    hintStyle: TextStyle(color: primaryTextColor),
                    floatingLabelStyle: TextStyle(color: variationColor),
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
                      if (_formKey.currentState!.validate()) {
                        me_change_password(password_controller.text);
                        password = password_controller.text;
                        () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString("password", password);
                        };
                        AppHandler("mainWidget", context, []);
                      }
                    },
                    child: const Text('Passwort ändern'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48.0),
                  child: ElevatedButton(
                    onPressed: () {
                      username = "";
                      password = "";
                      me = null;
                      () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove("username");
                        prefs.remove("password");
                      };
                      AppHandler("logInWidget", context, []);
                    },
                    child: const Text('Abmelden'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48.0),
                  child: ElevatedButton(
                    onPressed: () {
                      username = "";
                      password = "";
                      me = null;
                      () async {
                        await me_delete();
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove("username");
                        prefs.remove("password");
                      };
                      AppHandler("loginInWidget", context, []);
                    },
                    child: const Text('Account Löschen'),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
        ],
      )));
}

Widget themeSettings(void Function(String mode) update_color) {
  return (Container(
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: widgetColor,
      child: Column(
        children: [
          //headline
          Text(
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
                    onPressed: () {
                      update_color("light");
                    },
                    iconSize: 50,
                    icon: const Icon(Icons.sunny, color: Colors.yellow)),
                const Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets),
                ),
                IconButton(
                    onPressed: () {
                      update_color("dark");
                    },
                    iconSize: 50,
                    icon: const Icon(Icons.shield_moon)),
                const Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets),
                ),
                IconButton(
                    onPressed: () {
                      update_color("color");
                    },
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
                        children: [
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
                              color: widgetColor,
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
