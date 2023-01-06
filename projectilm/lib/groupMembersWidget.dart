import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'app_bars/simple_app_bar.dart';
import 'global.dart';

class groupMembersWidget extends StatefulWidget {
  const groupMembersWidget({super.key, required this.title});

  final String title;

  @override
  State<groupMembersWidget> createState() => _groupMembersWidget();
}

String invitationCode = "";

List<String> Member = ["Jakob", "Felix", "Fieser Schliecher", "Deine MUM"];

class _groupMembersWidget extends State<groupMembersWidget> {
  set textEinstellungsCode(String textEinstellungsCode) {}

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
                        new Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets)),
                        Container(
                            width: MediaQuery.of(context).size.width *
                                0.9, // the distance to the margin of display
                            child: 
                                Column(
                                  children: [
                                    get_memberBlock(Member[index])                          
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
  
  SizedBox get_memberBlock(member){
    return SizedBox(
      
      child: Padding(
        padding: constPadding,
        
        child: Container(
           decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(16.0),
              color: widgetColor,
            ),padding: EdgeInsets.only(left: 10),
          child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(member, style: TextStyle(color: primaryTextColor),),
              IconButton(
                onPressed: ()=>{}, 
                icon: Icon(Icons.person_remove_rounded),
                color: primaryTextColor,
                ), 
            ],
          ),
        )
    ));
    } 
}


