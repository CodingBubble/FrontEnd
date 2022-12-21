import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/settingsWidget.dart';
import 'mainWidget.dart';
import 'global.dart';
import 'src/projectillm_bridgelib_base.dart';
import 'groupWidget.dart';

class chatWidget extends StatefulWidget {
  const chatWidget({
    super.key,
    this.title,
    this.titleOfChat,
    this.info,
  });
  final title;
  final titleOfChat;
  final info;

  @override
  State<chatWidget> createState() =>
      _stateChatWidget(this.titleOfChat, this.info);
}

class _stateChatWidget extends State<chatWidget> {
  _stateChatWidget(titleOfChat, this.info) {
    this.titleOfChat = titleOfChat;
  }
  var titleOfChat;
  var info;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
              backgroundColor: WidgetColor,
              title: Container(
                child: Row(
                  children: [
                    Builder(builder: (BuildContext context) {
                      return (IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: WidgetColor,
                        onPressed: () =>
                            {AppHandler("groupWidget", context, [])},
                      )); // here to add the onPressed-command to search something
                    }),
                    Text(
                      titleOfChat,
                      style: TextStyle(
                          color: primaryTextColor, fontSize: HeadfontOfWidget),
                    ),
                    Builder(builder: (BuildContext context) {
                      return (IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () =>
                            AppHandler("settingsWidget", context, []),
                      ));
                    })
                  ],
                ),
              )),
          body: Scrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Material(
                  child: Column(
                    children: [
                      new Padding(
                          padding: EdgeInsets.all(discanceBetweenWidgets)),
                      Container(
                          width: MediaQuery.of(context).size.width *
                              0.9, // the distance to the margin of display
                          child: WidgetmessageDesign(messageshistory[index])),
                    ],
                  ),
                );
              },
              itemCount: messageshistory.length,
            ),
          ),
        ));
  }

  var messageshistory = [
    ["Du bist meine Tinkerbell", true],
    ["Komm wir fliegen um die Welt", false],
    ["Nimmerland ist immer hell", true]
  ];

  var inputMessage = "";
  Widget WidgetmessageDesign(list) {
    var message = list[0];
    var me = list[1];
    var wColor;
    var bubbleCorner;
    if (me == true) {
      wColor = Colors.green;
    } else {
      wColor = WidgetColor;
    }
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: wColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ],
    ));
  }
}
