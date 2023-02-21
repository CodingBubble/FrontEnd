import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/group/mainWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/transactions/splid_info_group.dart';
import 'package:projectilm/src/projectillm_bridgelib_splid.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import 'package:projectilm/global.dart';

class transactionsMeWidget extends StatefulWidget {
  const transactionsMeWidget({super.key});
  @override
  State<transactionsMeWidget> createState() => _transactionsMeWidget();
}

String invitationCode = "";

List<Transaction> transactions = [];

List<DropdownMenuItem<Group>> dropdown_groups = [
  DropdownMenuItem(
      value: null,
      child: Text("Alle", style: TextStyle(color: primaryTextColor))),
];

List<DropdownMenuItem<User>> dropdown_users = [
  DropdownMenuItem(
      value: null,
      child: Text("Alle", style: TextStyle(color: primaryTextColor))),
];

class _transactionsMeWidget extends State<transactionsMeWidget> {
  set textEinstellungsCode(String textEinstellungsCode) {}
  @override
  void initState() {
    super.initState();
    reload_group_options();
    reload_user_options();
    reload_transactions().then((value) => setState(() {}));
  }

  Future reload_user_options() async {
    selected_user1 = me!;
    dropdown_users = [
      DropdownMenuItem(
          value: null,
          child: Text("Alle", style: TextStyle(color: primaryTextColor))),
    ];
    if (current_transaction_group == null) {
      Map<int, User> users = <int, User>{};
      for (var group in groups_actual) {
        for (var member in (await group.get_members())) {
          if (member.id != me!.id && users[member.id] == null) {
            dropdown_users.add(DropdownMenuItem(
              value: member,
              child: Text(
                member.username,
                style: TextStyle(color: primaryTextColor),
              ),
            ));
            users[member.id] = member;
          }
        }
      }
      return;
    }
    for (var member in (await current_transaction_group!.get_members())) {
      dropdown_users.add(DropdownMenuItem(
        value: member,
        child: Text(
          member.username,
          style: TextStyle(color: primaryTextColor),
        ),
      ));
    }
  }

  void reload_group_options() {
    dropdown_groups = [
      DropdownMenuItem(
        value: null,
        child: Text(
          "Alle",
          style: TextStyle(color: primaryTextColor),
        ),
      ),
    ];
    for (var group in groups_actual) {
      dropdown_groups.add(DropdownMenuItem(
        value: group,
        child: Text(
          group.name,
          style: TextStyle(color: primaryTextColor),
        ),
      ));
    }
  }

  Future reload_transactions() async {
    if (current_transaction_group == null) {
      if (selected_user2 == null) {
        transactions = await get_my_transactions();
      } else {
        transactions = await get_my_transactions_with(selected_user2!);
      }
    } else {
      if (selected_user2 == null) {
        transactions =
            await current_transaction_group!.get_transactions_of(me!);
      } else {
        transactions = await current_transaction_group!
            .get_transactions_between(me!, selected_user2!);
      }
    }
  }

  var spaceBetweenTabulatorElements = 3.0;

  double standWidthForTabular(context) {
    return MediaQuery.of(context).size.width * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Meine Transaktionen"),
        body: Scrollbar(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                const Padding(padding: constPadding),
                // Container(
                //     margin: const EdgeInsets.only(left: 20),
                //     width: MediaQuery.of(context).size.width * 0.9,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Container(
                //           width: standWidthForTabular(context),
                //           margin: EdgeInsets.only(
                //               right: spaceBetweenTabulatorElements),
                //           child: Text("Transaktion:",
                //               style: TextStyle(color: primaryTextColor)),
                //         ),
                //         Container(
                //           width: standWidthForTabular(context),
                //           margin: EdgeInsets.only(
                //               right: spaceBetweenTabulatorElements),
                //           child: Text("Bilanz:",
                //               style: TextStyle(color: primaryTextColor)),
                //         ),
                //         SizedBox(
                //             width: standWidthForTabular(context),
                //             child: Text("Löschen:",
                //                 style: TextStyle(color: primaryTextColor))),
                //       ],
                //     )),
                Expanded(
                  flex: 1,
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return Material(
                          color: backgroundColor,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(discanceBetweenWidgets),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.9, // the distance to the margin of display
                                child: Column(
                                  children: [
                                    get_transaction(
                                      transactions[index],
                                      () {
                                        reload_transactions();
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "in:  ",
                      style: TextStyle(color: primaryTextColor),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  Expanded(
                    child: DropdownButton(
                        dropdownColor: widgetColor,
                        value: current_transaction_group,
                        onChanged: (Group? newValue) async {
                          selected_user2 = null;
                          current_transaction_group = newValue;
                          await reload_user_options();
                          await reload_transactions();
                          setState(() {});
                        },
                        items: dropdown_groups),
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  Expanded(
                    child: Text(
                      "mit: ",
                      style: TextStyle(color: primaryTextColor),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  Expanded(
                    child: DropdownButton(
                        dropdownColor: widgetColor,
                        value: selected_user2,
                        onChanged: (User? newValue) async {
                          selected_user2 = newValue;
                          await reload_transactions();
                          setState(() {});
                        },
                        items: dropdown_users),
                  )
                ]),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => AppHandler("create_transaction", context, []),
          backgroundColor: widgetColor,
          child: const Icon(Icons.add_circle),
        ),
      ),
    );
  }

  Dismissible get_transaction(Transaction transaction, reload_list) {
    Color c_color = secondaryTextColor;
    if (transaction.to.id == me!.id) {
      if (transaction.balance > 0) {
        c_color = positiveColor;
      } else {
        c_color = negativeColor;
      }
    } else {
      if (transaction.balance > 0) {
        c_color = positiveColor;
      } else {
        c_color = negativeColor;
      }
    }

    if (transaction.balance < 0) {
      transaction = transaction.flipped();
    }
    return Dismissible(
      key: ValueKey(transaction.id.toString()),
      background: Container(
        color: Colors.redAccent,
        padding: constPadding,
        margin: constPadding, // EdgeInsets.all(10)
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              "Transaktion löschen?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: widgetColor,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text(
                    "Abbrechen",
                    style: TextStyle(fontSize: 8, color: primaryTextColor),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: widgetColor,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(
                    "Löschen",
                    style: TextStyle(fontSize: 8, color: primaryTextColor),
                  ),
                ),
              )
            ],
          ),
        );
      },
      onDismissed: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          await transaction.delete();
          reload_list();
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: constPadding,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: widgetColor,
            ),
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    transaction.title,
                    style: TextStyle(
                        color: primaryTextColor, fontSize: SecondfontOfWidget),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: standWidthForTabular(context) * 5,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: spaceBetweenTabulatorElements,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          "von: ",
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          transaction.from.username,
                                          style: TextStyle(
                                              color: secondaryTextColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: spaceBetweenTabulatorElements),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          "an: ",
                                          style: TextStyle(
                                              color: primaryTextColor),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          transaction.to.username,
                                          style: TextStyle(
                                              color: secondaryTextColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: standWidthForTabular(context) * 2,
                      child: Expanded(
                        child: Text(
                          transaction.balance.toString() + "€",
                          style: TextStyle(color: c_color),
                        ),
                      ),
                    ),
                    /***
                     * löschen durch swipe funktion????
                     */
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
