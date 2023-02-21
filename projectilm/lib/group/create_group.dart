import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import 'package:projectilm/app_bars/user_app_bar.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/global.dart';

class Group_Create extends StatefulWidget {
  const Group_Create({super.key});
  @override
  State<Group_Create> createState() => _StateGroup_Create();
}

class _StateGroup_Create extends State<Group_Create> {
  final TextEditingController invite_code_controller = TextEditingController();
  final TextEditingController name_controller = TextEditingController();
  final TextEditingController desc_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Gruppe erstellen"),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Gruppe Betreten",
                  style: TextStyle(
                      color: secondaryTextColor, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                child: TextFormField(
                  style: TextStyle(color: primaryTextColor),
                  controller: invite_code_controller,
                  decoration: InputDecoration(
                    hintText: 'Einladungscode',
                    hintStyle: TextStyle(color: primaryTextColor),
                    floatingLabelStyle: TextStyle(color: variationColor),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    use_code();
                  },
                  child: Text('Betreten'),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 60, 8, 16),
              child: Text("Gruppe Erstellen",
                  style: TextStyle(
                      color: secondaryTextColor, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Form(
                child: TextFormField(
                  style: TextStyle(color: primaryTextColor),
                  controller: name_controller,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Name der Gruppe',
                    hintStyle: TextStyle(color: primaryTextColor),
                    floatingLabelStyle: TextStyle(color: variationColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Form(
                child: TextFormField(
                  style: TextStyle(color: primaryTextColor),
                  controller: desc_controller,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Beschreibung',
                    hintStyle: TextStyle(color: primaryTextColor),
                    floatingLabelStyle: TextStyle(color: variationColor),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: create_group,
                  child: Text('Erstellen'),
                )),
          ],
        )));
  }

  void create_group() async {
    if (me == null) {
      return;
    }
    var val = await me_create_group(name_controller.text, desc_controller.text);
    if (val == null) {
      showAlertDialog(context, "Fehler", "Gruppe Konnte nicht Erstellt werden");
      return;
    }
    current_group = val;
    AppHandler("groupWidget", context, []);
  }

  void use_code() {
    me_use_invitation_code(invite_code_controller.text).then((val) {
      if (val == null) {
        showAlertDialog(context, "Fehler", "Der Einladungscode ist ungültig");
        return;
      }
      current_group = val;
      AppHandler("groupWidget", context, []);
    });
  }
}
