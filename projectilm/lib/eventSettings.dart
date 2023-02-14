// Ort, Zeit,

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'app_bars/simple_app_bar.dart';
import 'eventWidget.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    get_event_data();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Einstellungen"),
        body: Scrollbar(
          child: ListView.builder(
            itemCount: get_setting_category(context, setState).length,
            itemBuilder: (context, index) {
              var settingCathegories = get_setting_category(context, setState);
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

  void get_event_data() async {
    cur_date = current_event!.time;
    change_title_controller.text = current_event!.name;
    change_desc_controller.text = current_event!.description;
    setState(() {});
  }
}

final change_title_controller = TextEditingController();
final change_desc_controller = TextEditingController();
DateTime cur_date = DateTime.now();

List<Widget> get_setting_category(context, setState) {
  return <Widget>[configSettings(context, setState)];
}

Widget configSettings(BuildContext context, setState) {
  final GlobalKey<FormState> _formTitlteKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formOrt = GlobalKey<FormState>();
  final GlobalKey<FormState> _formZeit = GlobalKey<FormState>();

  // get_values(change_title_controller, change_desc_controller);

  return (Container(
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: widgetColor,
      child: Column(children: [
        const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Eckdaten",
                style: TextStyle(
                    color: primaryTextColor, fontSize: HeadfontOfWidget),
              ),
              const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
              Form(
                key: _formTitlteKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Eventname",
                      style: TextStyle(
                          color: primaryTextColor,
                          fontSize: SecondfontOfWidget),
                    ),
                    TextFormField(
                      style: TextStyle(color: primaryTextColor),
                      controller: change_title_controller,
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
                          color: primaryTextColor,
                          fontSize: SecondfontOfWidget),
                    ),
                    TextFormField(
                      style: TextStyle(color: primaryTextColor),
                      controller: change_desc_controller,
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
              Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.calendar_month,
                            color: secondaryTextColor),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime.now().add(Duration(days: 365)),
                              onChanged: (date) {}, onConfirm: (date) {
                            cur_date = date;
                            setState(() {});
                          }, currentTime: cur_date, locale: LocaleType.de);
                        },
                      ),
                      Text(
                        formatter.format(cur_date),
                        style: TextStyle(color: primaryTextColor),
                      )
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        current_event!
                            .creator_update(change_title_controller.text,
                                change_desc_controller.text, cur_date)
                            .then((value) {
                          if (!value) {
                            showAlertDialog(context, "Fehler",
                                "Event konnte nicht gändert werden");
                            return;
                          }
                          AppHandler("eventWidget", context, [-1]);
                        });
                      },
                      child: const Text('speichern'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        current_event!.creator_delete().then((value) {
                          if (!value) {
                            showAlertDialog(context, "Fehler",
                                "Event konnte nicht gelöscht werden");
                            return;
                          }
                          AppHandler("groupWidget", context, []);
                        });
                      },
                      child: const Text('Event löschen'),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ])));
}
