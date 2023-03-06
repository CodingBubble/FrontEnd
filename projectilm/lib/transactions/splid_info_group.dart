import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/group/mainWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/src/projectillm_bridgelib_splid.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import './../global.dart';

class transactionsWidget extends StatefulWidget {
  const transactionsWidget({super.key});
  @override
  State<transactionsWidget> createState() => _transactionsWidget();
}

String invitationCode = "";

List<Transaction> transactions = [];

User? selected_user1;
User? selected_user2;

List<DropdownMenuItem<Group>> dropdown_groups = [];

List<DropdownMenuItem<User>> dropdown_users = [
  DropdownMenuItem(
      value: null,
      child: Text("Alle", style: TextStyle(color: primaryTextColor))),
  DropdownMenuItem(
      value: me, child: Text("Ich", style: TextStyle(color: primaryTextColor))),
];

class _transactionsWidget extends State<transactionsWidget> {
  set textEinstellungsCode(String textEinstellungsCode) {}
  @override
  void initState() {
    super.initState();
    reload_group_options();
    reload_user_options();
    reload_transactions().then((value) => setState(() {}));
  }

  Future reload_user_options() async {
    dropdown_users = [
      DropdownMenuItem(
          value: null,
          child: Text("Alle", style: TextStyle(color: primaryTextColor))),
      DropdownMenuItem(
          value: me,
          child: Text("Ich", style: TextStyle(color: primaryTextColor))),
    ];
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
    dropdown_groups = [];
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
      return;
    }
    if (selected_user1 == null && selected_user2 == null) {
      transactions = await current_transaction_group!.get_all_transactions();
    } else if (selected_user2 == null) {
      transactions =
          await current_transaction_group!.get_transactions_of(selected_user1!);
    } else if (selected_user1 == null) {
      transactions =
          await current_transaction_group!.get_transactions_of(selected_user2!);
    } else {
      transactions = await current_transaction_group!
          .get_transactions_between(selected_user1!, selected_user2!);
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
        appBar: get_simple_app_bar(context, "Transaktionen"),
        body: Scrollbar(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                const Padding(padding: constPadding),
                // Container(
                //     margin: EdgeInsets.only(left: 20),
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
                //           child: Text("von: ",
                //               style: TextStyle(color: primaryTextColor)),
                //         ),
                //         Container(
                //           width: standWidthForTabular(context),
                //           margin: EdgeInsets.only(
                //               right: spaceBetweenTabulatorElements),
                //           child: Text("an: ",
                //               style: TextStyle(color: primaryTextColor)),
                //         ),
                //         Container(
                //           width: standWidthForTabular(context),
                //           margin: EdgeInsets.only(
                //               right: spaceBetweenTabulatorElements),
                //           child: Text("Kostet:",
                //               style: TextStyle(color: primaryTextColor)),
                //         ),
                //         Container(
                //             width: standWidthForTabular(context),
                //             child: Text("Löschen:",
                //                 style: TextStyle(color: primaryTextColor))),
                //       ],
                //     )),
                Expanded(
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
                                      index,
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
                const Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets * 2),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 2),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "in:  ",
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: SecondfontOfWidget,
                        ),
                      ),
                      DropdownButton(
                          dropdownColor: widgetColor,
                          value: current_transaction_group,
                          isExpanded: true,
                          onChanged: (Group? newValue) async {
                            selected_user2 = null;
                            current_transaction_group = newValue;
                            await reload_user_options();
                            await reload_transactions();
                            setState(() {});
                          },
                          items: dropdown_groups),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 2),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "von:  ",
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: SecondfontOfWidget,
                        ),
                      ),
                      DropdownButton(
                          dropdownColor: widgetColor,
                          value: selected_user1,
                          onChanged: (User? newValue) async {
                            selected_user1 = newValue;
                            await reload_transactions();
                            setState(() {});
                          },
                          isExpanded: true,
                          items: dropdown_users),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(discanceBetweenWidgets),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 2),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "an:  ",
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: SecondfontOfWidget,
                        ),
                      ),
                      DropdownButton(
                          dropdownColor: widgetColor,
                          value: selected_user1,
                          onChanged: (User? newValue) async {
                            selected_user1 = newValue;
                            await reload_transactions();
                            setState(() {});
                          },
                          isExpanded: true,
                          items: dropdown_users),
                    ],
                  ),
                ),
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

  Dismissible get_transaction(Transaction transaction, reload_list, index) {
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
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() async {
            transactions.removeAt(index);

            await transaction.delete();
            print("reload");
            reload_list();
          });
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
