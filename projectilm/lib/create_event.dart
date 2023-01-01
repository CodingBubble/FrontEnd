import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
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
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: get_group_app_bar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Form(
              child: TextFormField(
                controller: name_controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(hintText: 'Titel'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Form(
              child: TextFormField(
                controller: desc_controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(hintText: 'Beschreibung'),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () { 
                  DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(Duration(days: 365)), onChanged: (date) {
                      }, onConfirm: (date) {
                        create_event(date);
                      }, currentTime: DateTime.now(), locale: LocaleType.de);
                },
                child: Text('Erstellen'),
              )),
        ],
      )
    );
  }

  void create_event (DateTime t) async
  {
    if(me==null) {return; }
    var val = await current_group!.create_event(name_controller.text, desc_controller.text, t);
    if(val==null){showAlertDialog(context, "Fehler", "Event konnte nicht erstellt werden."); return; }
    current_event = val;
    AppHandler("eventWidget", context, [0]);
  }
}

