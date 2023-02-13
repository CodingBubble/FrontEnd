import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/settingsWidget.dart';
import 'mainWidget.dart';
import 'global.dart';
import 'src/projectillm_bridgelib_base.dart';
import 'groupWidget.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker picker = ImagePicker();

  _stateChatWidget(titleOfChat, this.info) {
    this.titleOfChat = titleOfChat;
  }
  var titleOfChat;
  var info;

  void initState() {
    super.initState();
    load_message_history();
  }

  Future getImage() async {
    var img = await picker.pickImage(source: ImageSource.gallery);
    var uploaded = await current_group!.upload_image(File(img!.path));
    await current_group!.send_message(image_signalizer + uploaded.toString());
    load_message_history();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Gruppenchat"),
        body: Column(
          children: [
            // history of messages
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Scrollbar(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Material(
                      color: backgroundColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                              padding: EdgeInsets.all(discanceBetweenWidgets)),
                          SizedBox(
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
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () {
                          getImage();
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextFormField(
                          style: TextStyle(color: primaryTextColor),
                          controller: inputMessageController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Schreibe eine Nachricht",
                            hintStyle: TextStyle(color: primaryTextColor),
                            floatingLabelStyle:
                                TextStyle(color: variationColor),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () => {send_message()},
                          icon: Icon(Icons.send, color: secondaryTextColor))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // contains all messages of the chat
  // first element is message, second element decides weather is own message or not (my message = true, others message = false)
  var messageshistory = [];

  Future load_message_history() async {
    if (me == null) {
      print("me is null");
      return;
    }
    if (current_group == null) {
      print("cur group is null");
      return;
    }
    current_group!.get_messages().then((msgs) {
      messageshistory = [];
      msgs.forEach((msg) {
        messageshistory
            .add([msg.text, msg.author.id == me!.id, msg.author.username]);
      });
      setState(() {});
    });
  }

  void send_message() async {
    print("p2");
    if (me == null) {
      return;
    }
    if (current_group == null) {
      return;
    }
    if (inputMessageController.text.trim() == "") {
      return;
    }
    print("sendmessage");

    current_group!
        .send_message(inputMessageController.text.trim())
        .then((value) {
      if (value == null) {
        return;
      }
      inputMessageController.text = "";
      load_message_history();
    });
  }

  var inputMessage = "";
  Widget WidgetmessageDesign(list) {
    String message = list[0];
    var _me = list[1];
    var author = list[2];
    var wColor;
    var bubbleCorner;

    Widget MessageInp = Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
    if (message.startsWith(image_signalizer)) {
      int id = int.parse(message.substring(image_signalizer.length));
      MessageInp = Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Image.network(get_image_url(id)));
    }

    if (_me == true) {
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
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(19),
                    topLeft: Radius.circular(19),
                    bottomLeft: Radius.circular(19),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        color: widgetColor,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    MessageInp
                  ],
                )),
          ),
        ],
      ));
    } else {
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
                  color: widgetColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19),
                    topRight: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      author,
                      style: TextStyle(color: secondaryTextColor, fontSize: 10),
                      textAlign: TextAlign.left,
                    ),
                    MessageInp
                  ],
                )),
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
