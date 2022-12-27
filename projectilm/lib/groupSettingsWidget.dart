import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groupWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/app_bars/settings_app_bar.dart';
import 'package:uuid/uuid.dart';

class groupSettingsWidget extends StatefulWidget {
  const groupSettingsWidget({super.key, required this.title});

  final String title;

  @override
  State<groupSettingsWidget> createState() => _groupSettingsWidgetState();
}

class _groupSettingsWidgetState extends State<groupSettingsWidget> {
  set textEinstellungsCode(String textEinstellungsCode) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: get_settings_app_bar(context),
        body: Scrollbar(
          child: ListView.builder(
            itemCount: get_setting_category(context).length,
            itemBuilder: (context, index) {
              var settingCathegories = get_setting_category(context);
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
          ),
        ),
      ),
    );
  }
}

List<Widget> get_setting_category(context) {
  return <Widget>[
    themeSettings(),
    configSettings(context)
    // securitySettings()
  ];
}

/** Kannst du die momentanen Values reinladen sodass man die bearbeiten kann???
 * 
 *  merci beaucoup
 */

Widget configSettings(BuildContext context) {
  final GlobalKey<FormState> _formTitlteKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formTextKey = GlobalKey<FormState>();

  return (Container(
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: widgetColor,
      child: Column(
        children: [
          //headline
          Text(
            "Konfiguration",
            style:
                TextStyle(color: primaryTextColor, fontSize: GigafontOfWidget),
          ),
          const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
          Form(
            key: _formTitlteKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Gruppenname",
                  style: TextStyle(
                      color: primaryTextColor, fontSize: SecondfontOfWidget),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Gebe einen neuen Gruppennamen ein',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gebe einen neunen Grupppennamem ein';
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
                      if (_formTitlteKey.currentState!.validate()) {
                        // me_change_password(password_controller.text);

                        // password = password_controller.text;
                        () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString("password", password);
                        };
                        AppHandler("mainWidget", context, []);
                      }
                    },
                    child: const Text('Gruppennamen ändern'),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(2 * discanceBetweenWidgets)),
          Form(
            key: _formTextKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Gruppebeschreibung",
                  style: TextStyle(
                      color: primaryTextColor, fontSize: SecondfontOfWidget),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Gebe eine neue Gruppenbeschreibung ein',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gebe einen neunen Grupppennamem ein';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Gruppenbeschreibung ändern'),
                  ),
                ),
              ],
            ),
          ),
        ],
      )));
}

Widget themeSettings() {
  late String invitationCode;

  void generateID() {
    var uuid = Uuid();
    invitationCode = uuid.v4();
  }

  generateID();
  print(invitationCode);
  return (Container(
    padding: constPadding,
    margin: constMargin,
    width: double.infinity,
    color: widgetColor,
    child: Column(
      children: [
        const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Einladungcode",
                style: TextStyle(
                    color: primaryTextColor, fontSize: HeadfontOfWidget),
              ),
              const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
              Text(
                invitationCode,
                style: TextStyle(
                    color: primaryTextColor,
                    fontSize: SecondfontOfWidget * 0.75),
              ),
              const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
              SizedBox(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Kopieren'),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(2 * discanceBetweenWidgets)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // funtioniert nicht => muss mit setState gearbeitet werden => i dunno
                          // url muss erstellt werden

                          generateID();
                        },
                        child: const Text('neu generieren'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  ));
}
