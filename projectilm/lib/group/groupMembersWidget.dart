import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/src/projectillm_bridgelib_splid.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import 'package:projectilm/global.dart';

class groupMembersWidget extends StatefulWidget {
  const groupMembersWidget({super.key, required this.title});

  final String title;

  @override
  State<groupMembersWidget> createState() => _groupMembersWidget();
}

String invitationCode = "";

List<User> Member = [];

class _groupMembersWidget extends State<groupMembersWidget> {
  set textEinstellungsCode(String textEinstellungsCode) {}
  @override
  void initState() {
    super.initState();
    get_members();
    get_transaction_hashmap();
  }

  void get_members() {
    current_group!.get_members().then((value) {
      Member = value;
      setState(() {});
    });
  }

  Map<int, double> vals = <int, double>{};
  void get_transaction_hashmap() async {
    vals = get_group_balances(await current_group!.get_all_transactions());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Mitglieder"),
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Member.length,
                itemBuilder: (context, index) {
                  return Material(
                    color: backgroundColor,
                    child: Container(
                      padding: constPadding,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [get_memberBlock(Member[index], get_members)],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widgetColor,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: constPadding / 2,
                    child: IconButton(
                      onPressed: () {
                        current_transaction_group = current_group;
                        AppHandler("splid_info_group", context, []);
                      },
                      iconSize: 40.0,
                      icon: Icon(
                        Icons.playlist_add_check,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widgetColor,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: constPadding / 2,
                    child: IconButton(
                      onPressed: () {
                        current_transaction_group = current_group;
                        AppHandler("create_transaction", context, const []);
                      },
                      iconSize: 40.0,
                      icon: Icon(
                        Icons.add,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox get_memberBlock(member, reload_list) {
    double balance = vals[member.id] ?? 0;
    return SizedBox(
      child: Padding(
        padding: constPadding / 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: widgetColor,
          ),
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      member.username,
                      style: TextStyle(color: primaryTextColor),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: discanceBetweenWidgets / 2),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "$balance€",
                      style: TextStyle(
                        color: get_balance_color(balance),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              IconButton(
                onPressed: () async {
                  await current_group!.admin_kick_user(member);
                  reload_list();
                  current_group!.send_message(
                    "Der Benutzer ${member.name} wurde aus der Gruppe entfernt",
                  );
                },
                icon: Icon(Icons.person_remove_rounded, color: backgroundColor),
                color: primaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color get_balance_color(double balance) =>
    balance < 0 ? negativeColor : positiveColor;
