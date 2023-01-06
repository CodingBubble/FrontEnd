import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
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
  }

  void get_members(){
    current_group!.get_members().then((value) { 
        Member = value;
        setState(() { });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Mitglieder"),
        body: Scrollbar(
          child:Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Member.length,
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
                                    get_memberBlock(Member[index], get_members)                          
                                ],)
                            ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ) 
        ),
      ),
    );
  }  
  
  SizedBox get_memberBlock(member, reload_list){
    return SizedBox(
      
      child: Padding(
        padding: constPadding,
        
        child: Container(
           decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: widgetColor,
            ),padding: const EdgeInsets.only(left: 10),
          child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(member.username, style: TextStyle(color: primaryTextColor),),
              IconButton(
                onPressed: () async {
                  await current_group!.admin_kick_user(member);
                  reload_list();
                  current_group!.send_message("Der Benutzer " + member.name+ " wurde aus der Gruppe entfernt");
                },
                icon: Icon(Icons.person_remove_rounded),
                color: primaryTextColor,
                ), 
            ],
          ),
        )
    ));
    } 
}


