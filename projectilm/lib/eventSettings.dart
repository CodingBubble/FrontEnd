// Ort, Zeit, 

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'app_bars/simple_app_bar.dart';
import 'global.dart';

class eventSettingsWidget extends StatefulWidget {
  const eventSettingsWidget({super.key, required this.title});

  final String title;

  @override
  State<eventSettingsWidget> createState() => _eventSettingsWidget();
}

class _eventSettingsWidget extends State<eventSettingsWidget> {
  set textEinstellungsCode(String textEinstellungsCode) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Eventeinstellungen"),
        body: Scrollbar(
          child: ListView.builder(
            itemCount: get_setting_category(context).length,
            itemBuilder: (context, index) {
              var settingCathegories = get_setting_category(context);
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
          ),
        ),
      ),
    );
  }
}

List<Widget> get_setting_category(context) {
  return <Widget>[
    configSettings(context)
  ];
}

Widget configSettings(BuildContext context) {
  final GlobalKey<FormState> _formTitlteKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formOrt = GlobalKey<FormState>();
  final GlobalKey<FormState> _formZeit = GlobalKey<FormState>();

  

  // final change_title_controller = TextEditingController(); 
  // final change_desc_controller = TextEditingController(); 
  // get_values(change_title_controller, change_desc_controller);

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
                "Eckdaten",
                style: TextStyle(
                    color: primaryTextColor, fontSize: HeadfontOfWidget),
              ),const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
          Form(
            key: _formTitlteKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Eventname",
                  style: TextStyle(
                      color: primaryTextColor, fontSize: SecondfontOfWidget),
                ),
                TextFormField(
                  style: TextStyle(color: primaryTextColor),
                  // controller: change_title_controller,
                  decoration: InputDecoration(
                    hintText: 'Gebe einen neuen Eventnamen ein',
                    hintStyle: TextStyle(color: primaryTextColor),
                    floatingLabelStyle: TextStyle(color: variationColor),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gebe einen neunen Eventnamem ein';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
             const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
                Form(
                  key: _formOrt,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Ort",
                        style: TextStyle(
                            color: primaryTextColor, fontSize: SecondfontOfWidget),
                      ),
                      TextFormField(
                        style: TextStyle(color: primaryTextColor),
                        // controller: change_title_controller,
                        decoration: InputDecoration(
                          hintText: 'Gebe einen neuen Ort ein',
                          hintStyle: TextStyle(color: primaryTextColor),
                          floatingLabelStyle: TextStyle(color: variationColor),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte gebe einen neunen Ort ein';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
                Form(
                  key: _formZeit,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Zeit",
                        style: TextStyle(
                            color: primaryTextColor, fontSize: SecondfontOfWidget),
                      ),
                      TextFormField(
                        style: TextStyle(color: primaryTextColor),
                        // controller: change_title_controller,
                        decoration: InputDecoration(
                          hintText: 'Gebe eine neue Zeit ein',
                          hintStyle: TextStyle(color: primaryTextColor),
                          floatingLabelStyle: TextStyle(color: variationColor),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte gebe eine neue Zeit ein';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                  ],
                ),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [ Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('speichern'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: ElevatedButton(
              onPressed: () {current_group!.admin_delete().then((value) {
                if(!value) {showAlertDialog(context, "Fehler", "Event konnte nicht gelöscht werden"); return;}
                AppHandler("mainWidget", context, []);
              });},
              child: const Text('Event löschen'),
            ),
          ),],
          )
         
        ],
      ),
    )
  );
}
