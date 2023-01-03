import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'alert_fnc.dart';
import 'global.dart';


class Event_Create extends StatefulWidget {
  const Event_Create({super.key});
  @override
  State<Event_Create> createState() => _StateEvent_Create();
}

class _StateEvent_Create extends State<Event_Create> {
  final TextEditingController name_controller = TextEditingController();
  final TextEditingController desc_controller = TextEditingController();
  final DateFormat formatter = DateFormat('dd. MM. yyyy HH:mm');

  DateTime cur_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: backgroundColor,
      appBar: get_simple_app_bar(context, "Event erstellen"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              child: TextFormField(
                style: TextStyle(color: primaryTextColor),
                controller: name_controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Titel',
                  hintStyle: TextStyle(color: primaryTextColor),
                  floatingLabelStyle: TextStyle(color: variationColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              child: TextFormField(
                style: TextStyle(color: primaryTextColor),
                controller: desc_controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Ort',
                  hintStyle: TextStyle(color: primaryTextColor),
                  floatingLabelStyle: TextStyle(color: variationColor),
                ),
              ),
            ),
          ),
          
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child:Row(
                children: [
                   IconButton(
                    icon: Icon(Icons.calendar_month, color: secondaryTextColor),
                    onPressed: () { 
                      DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime.now().add(Duration(days: 365)), onChanged: (date) {
                          }, onConfirm: (date) {
                            cur_date=date; setState(() {});
                          }, currentTime: DateTime.now(), locale: LocaleType.de);
                    },
                  ),
                  Text(formatter.format(cur_date), style: TextStyle(color: primaryTextColor),)
                ],
              )
            ),


          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextButton(
                onPressed: () { 
                  create_event();
                },
                child: Text('Event erstellen', style: new TextStyle(color: variationColor)),
              )),
        ],
      )
    );
  }

  void create_event () async
  {
    if(me==null || cur_date==null) {return; }
    var val = await current_group!.create_event(name_controller.text, desc_controller.text, cur_date!);
    if(val==null){showAlertDialog(context, "Fehler", "Event konnte nicht erstellt werden."); return; }
    current_event = val;
    AppHandler("eventWidget", context, [-1]);
  }
}

