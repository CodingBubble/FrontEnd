import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/mainWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/splid_info_group.dart';
import 'package:projectilm/src/projectillm_bridgelib_splid.dart';
import 'app_bars/simple_app_bar.dart';
import 'global.dart';

class transactionsMeWidget extends StatefulWidget {
  const transactionsMeWidget({super.key});
  @override
  State<transactionsMeWidget> createState() => _transactionsMeWidget();
}

String invitationCode = "";

List<Transaction> transactions = [];

List<DropdownMenuItem<Group>> dropdown_groups = [
  DropdownMenuItem(child: Text("Alle", style: TextStyle(color: primaryTextColor)),value: null),
];

List<DropdownMenuItem<User>> dropdown_users = [
  DropdownMenuItem(child: Text("Alle", style: TextStyle(color: primaryTextColor)),value: null),
];

class _transactionsMeWidget extends State<transactionsMeWidget> {
  set textEinstellungsCode(String textEinstellungsCode) {}
  @override
  void initState() {
    super.initState();
    reload_group_options();
    reload_user_options();
    reload_transactions().then((value) =>
      setState(() {})
    );
  }


  Future reload_user_options() async {
    selected_user1 = me!;
    dropdown_users = [
      DropdownMenuItem(child: Text("Alle", style: TextStyle(color: primaryTextColor)),value: null),
    ];
    if (current_transaction_group == null) {
      Map<int, User> users = <int, User>{};
      for (var group in groups_actual) {
        for (var member in (await group.get_members())) {
          if (member.id != me!.id && users[member.id] ==null) {
            dropdown_users.add(
              DropdownMenuItem(
                child: Text(member.username, style: TextStyle(color: primaryTextColor),),
                value: member,
              )
            );
            users[member.id] = member;
          }
          
        }
      }
      return;
    }
    for (var member in (await current_transaction_group!.get_members())) {
      dropdown_users.add(
        DropdownMenuItem(
          child: Text(member.username, style: TextStyle(color: primaryTextColor),),
          value: member,
        )
      );
    }
  }

  void reload_group_options(){
    dropdown_groups = [
      DropdownMenuItem(child: Text("Alle", style: TextStyle(color: primaryTextColor)),value: null),
    ];
    for (var group in groups_actual) {
      dropdown_groups.add(
        DropdownMenuItem(
          child: Text(group.name, style: TextStyle(color: primaryTextColor),),
          value: group,
        )
      );
    }
  }

  Future reload_transactions() async
  {
    if(current_transaction_group==null) {
      if (selected_user2==null) {
        transactions = await get_my_transactions();
      } else {
        transactions = await get_my_transactions_with(selected_user2!);
      }
    }
    else {
      if (selected_user2==null) {
        transactions = await current_transaction_group!.get_transactions_of(me!);
      } else {
        transactions = await current_transaction_group!.get_transactions_between(me!, selected_user2!);
      }
    }

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Meine Transaktionen"),
        body: Scrollbar(
          child:Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                    Text("in: ", style: TextStyle(color: primaryTextColor),),
                    DropdownButton(
                      dropdownColor:  widgetColor,
                      value: current_transaction_group,
                      onChanged: (Group? newValue) async {
                        selected_user2 = null;
                        current_transaction_group = newValue;
                        await reload_user_options();
                        await reload_transactions();
                        setState(() {});
                      },
                      items: dropdown_groups
                    )
                  ]
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                    Text("mit: ", style: TextStyle(color: primaryTextColor),),
                    DropdownButton(
                      dropdownColor:  widgetColor,
                      value: selected_user2,
                      onChanged: (User? newValue) async {
                        selected_user2 = newValue;
                        await reload_transactions();
                        setState(() {});
                      },
                      items: dropdown_users
                    )
                  ]
                ),

                TextButton(
                  onPressed: () => AppHandler("create_transaction", context, []), 
                  child: Text("Transaktion hinzufügen", style: TextStyle(color: secondaryTextColor),)
                ),

                Expanded(flex: 1, child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return Material(
                        color: backgroundColor,
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(discanceBetweenWidgets)),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    0.9, // the distance to the margin of display
                                child: 
                                    Column(
                                      children: [
                                        get_transaction(transactions[index], (){reload_transactions(); setState((){});})                          
                                    ],)
                                ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
              ],
            )
          ) 
        ),
      ),
    );
  }  
  
  SizedBox get_transaction(Transaction transaction, reload_list) {

    Color c_color = secondaryTextColor;
    if (transaction.to.id == me!.id ) {
       if (transaction.balance > 0) {
        c_color = positiveColor;
      } else {
        c_color = negativeColor;
      }
    }
    else {
      if (transaction.balance > 0) {
        c_color = positiveColor;
      } else {
        c_color = negativeColor;
      }
    }
    
    if (transaction.balance < 0) {
        transaction=transaction.flipped();
    }

    return SizedBox(
      child: Padding(
        padding: constPadding,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: widgetColor,
          ),
          padding: const EdgeInsets.only(left: 10),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(transaction.title, style: TextStyle(color: primaryTextColor),),
                Text(transaction.from.username, style: TextStyle(color: primaryTextColor),),
                Text(transaction.to.username, style: TextStyle(color: primaryTextColor),),
                Text(transaction.balance.toString() + "€", style: TextStyle(color: c_color),),
                IconButton(
                  onPressed: () async {
                    await transaction.delete();
                    reload_list();
                  },
                  icon: Icon(Icons.delete),
                  color: primaryTextColor,
                ), 
              ],
          ),
        )
    ));
  } 
}


