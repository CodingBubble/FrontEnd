import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/src/projectillm_bridgelib_splid.dart';
import 'app_bars/simple_app_bar.dart';
import 'global.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Mitglieder"),
        body: Scrollbar(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Member.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: backgroundColor,
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.all(discanceBetweenWidgets)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.9, // the distance to the margin of display
                            child: Column(
                              children: [
                                get_memberBlock(Member[index], get_members)
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: IconButton(
                      onPressed: () {
                        current_transaction_group = current_group;
                        AppHandler("splid_info_group", context, []);
                      },
                      icon: Icon(
                        Icons.playlist_add_check_circle_sharp,
                        size: 60,
                        color: widgetColor,
                      ),
                    ),
                  ),
                ),
              ),
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            current_transaction_group = current_group;
            AppHandler("create_transaction", context, []);
          },
          backgroundColor: widgetColor,
          child: const Icon(Icons.add_circle),
        ),
      ),
    );
  }

  SizedBox get_memberBlock(member, reload_list) {
    double balance = vals[member.id] ?? 0;
    return SizedBox(
        child: Padding(
            padding: constPadding * 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: widgetColor,
              ),
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    member.username,
                    style: TextStyle(color: primaryTextColor),
                  ),
                  Text(
                    balance.toString() + "€",
                    style: TextStyle(
                      color: get_balance_color(balance),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  IconButton(
                    onPressed: () async {
                      await current_group!.admin_kick_user(member);
                      reload_list();
                      current_group!.send_message("Der Benutzer " +
                          member.name +
                          " wurde aus der Gruppe entfernt");
                    },
                    icon: Icon(Icons.person_remove_rounded,
                        color: backgroundColor),
                    color: primaryTextColor,
                  ),
                ],
              ),
            )));
  }
}

Color get_balance_color(double balance) =>
    balance < 0 ? negativeColor : positiveColor;
