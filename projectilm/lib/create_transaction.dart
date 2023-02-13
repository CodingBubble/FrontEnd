import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/splid_info_group.dart';
import 'alert_fnc.dart';
import 'global.dart';
import 'mainWidget.dart';

class Transaction_Create extends StatefulWidget {
  const Transaction_Create({super.key});
  @override
  State<Transaction_Create> createState() => _StateTransaction_Create();
}

List<User> users_in_group = [];

class _StateTransaction_Create extends State<Transaction_Create> {
  final TextEditingController title_controller = TextEditingController();
  final TextEditingController balance_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    reload_group_options();
    reload_user_options().then((value) => setState(() {}));
  }

  Future reload_user_options() async {
    if (current_transaction_group == null) {
      current_transaction_group = groups_actual[0];
      selected_user1 = null;
      selected_user2 = null;
    } else {
      if (selected_user1 != null || selected_user2 != null) {
        return;
      }
    }
    dropdown_users = [
      DropdownMenuItem(
          child: Text("Alle", style: TextStyle(color: primaryTextColor)),
          value: null),
      DropdownMenuItem(
          child: Text("Ich", style: TextStyle(color: primaryTextColor)),
          value: me),
    ];
    users_in_group = [];
    for (var member in (await current_transaction_group!.get_members())) {
      users_in_group.add(member);
      dropdown_users.add(DropdownMenuItem(
        child: Text(
          member.username,
          style: TextStyle(color: primaryTextColor),
        ),
        value: member,
      ));
    }
  }

  void reload_group_options() {
    dropdown_groups = [];
    for (var group in groups_actual) {
      dropdown_groups.add(DropdownMenuItem(
        child: Text(
          group.name,
          style: TextStyle(color: primaryTextColor),
        ),
        value: group,
      ));
    }
  }

  DateTime cur_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Transaktion erstellen"),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                child: TextFormField(
                  style: TextStyle(color: primaryTextColor),
                  controller: title_controller,
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
                  controller: balance_controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Wert',
                    hintStyle: TextStyle(color: primaryTextColor),
                    floatingLabelStyle: TextStyle(color: variationColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                child: DropdownButton(
                    dropdownColor: widgetColor,
                    value: current_transaction_group,
                    onChanged: (Group? newValue) async {
                      current_transaction_group = newValue!;
                      selected_user1 = null;
                      selected_user2 = null;
                      await reload_user_options();
                      setState(() {});
                    },
                    items: dropdown_groups),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                child: DropdownButton(
                    dropdownColor: widgetColor,
                    value: selected_user1,
                    onChanged: (User? newValue) async {
                      selected_user1 = newValue;
                      setState(() {});
                    },
                    items: dropdown_users),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                child: DropdownButton(
                    dropdownColor: widgetColor,
                    value: selected_user2,
                    onChanged: (User? newValue) async {
                      selected_user2 = newValue;
                      setState(() {});
                    },
                    items: dropdown_users),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: widgetColor)),
                    child: TextButton(
                      onPressed: () {
                        create_transaction();
                      },
                      child: Text('Transaktion erstellen',
                          style: TextStyle(color: secondaryTextColor)),
                    ))),
          ],
        ));
  }

  void create_transaction() async {
    if (current_transaction_group == null) {
      return;
    }

    if (selected_user1 == null && selected_user2 == null) {
      return;
    }
    double balance = double.parse(balance_controller.text);
    if (selected_user1 == null) {
      for (User u1 in users_in_group) {
        imply_transaction(
            title_controller.text, u1, balance / users_in_group.length);
      }
    } else {
      imply_transaction(title_controller.text, selected_user1!, balance);
    }
  }

  Future imply_transaction(String title, User u1, double balance) async {
    if (selected_user2 == null) {
      for (User u2 in users_in_group) {
        if (u1.id == u2.id) {
          continue;
        }
        do_transaction(
            title_controller.text, u1, u2, balance / users_in_group.length);
      }
    } else {
      do_transaction(title_controller.text, u1, selected_user2!, balance);
    }
  }

  Future do_transaction(String title, User u1, User u2, double balance) async {
    await current_transaction_group!.create_transaction(title, u1, u2, balance);
    selected_user1 = null;
    selected_user2 = null;
    AppHandler("splid_info_group", context, []);
  }
}
