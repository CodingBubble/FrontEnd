import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
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
  final inputMessageController =
      TextEditingController(); // variable contains the message, the user can write in the chat
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
        appBar: get_group_app_bar(context),
        body: Column(
          children: [
            // history of messages
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Material(
                      child: Column(
                        children: [
                          new Padding(
                              padding: EdgeInsets.all(discanceBetweenWidgets)),
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  0.9, // the distance to the margin of display
                              child:
                                  WidgetmessageDesign(messageshistory[index])),
                        ],
                      ),
                    );
                  },
                  itemCount: messageshistory.length,
                ),
              ),
            ),
            // button to enter a message to the chat
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Container(
                    child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: inputMessageController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Schreibe eine Nachricht",
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => {/* kommt code rein*/},
                        icon: Icon(Icons.send))
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // contains all messages of the chat
  // first element is message, second element decides weather is own message or not (my message = true, others message = false)
  var messageshistory = [
    ["Du bist meine Tinkerbell", true],
    ["Komm wir fliegen um die Welt", false],
    ["Nimmerland ist immer hell", true],
    [
      "Ich kann nicht schlafen weil ich zu viel arbeite weil ich zu wenig schlafe weil ich zu viel arbeite!",
      false
    ],
    ["Du Hurensohn von Flutter!", true],
    ["Du meinst wohl Freudenmädchen von Flutter", false],
    ["Selber...", true]
  ];

  var inputMessage = "";
  Widget WidgetmessageDesign(list) {
    var message = list[0];
    var _me = list[1];
    var wColor;
    var bubbleCorner;
    if (_me == true) {
      return Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(19),
                  topLeft: Radius.circular(19),
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
    } else {
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
                color: WidgetColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(19),
                  topRight: Radius.circular(19),
                  bottomLeft: Radius.circular(19),
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
}




/*

            // Box to write new Message
            Align(
              alignment: Alignment.bottomCenter,
              child: Text("Hello from the dark side!"),
            ),
            */