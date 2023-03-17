import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/group/settingsWidget.dart';
import 'mainWidget.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/src/projectillm_bridgelib_base.dart';
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1 - 125,
              child: Expanded(
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
                              padding: EdgeInsets.all(discanceBetweenWidgets),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.9, // the distance to the margin of display
                              child: WidgetmessageDesign(
                                messageshistory[index],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: messageshistory.length,
                  ),
                ),
              ),
            ),
            // button to enter a message to the chat
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                padding: constPadding * 0.5,
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.image),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: TextFormField(
                            style: TextStyle(color: primaryTextColor),
                            controller: inputMessageController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "chat . . .",
                              hintStyle: TextStyle(
                                color: primaryTextColor,
                                fontSize: 13,
                              ),
                              floatingLabelStyle:
                                  TextStyle(color: variationColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () => {send_message()},
                          icon: Icon(Icons.send, color: secondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
        messageshistory.add(
            [msg.text, msg.author.id == me!.id, msg.author.username, msg.time]);
      });
      setState(() {});
    });
  }

  void send_message() async {
    if (me == null) {
      return;
    }
    if (current_group == null) {
      return;
    }
    if (inputMessageController.text.trim() == "") {
      return;
    }

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
    var msgTime = list[3];
    var wColor;
    var bubbleCorner;
    // var date = msgTime.split(' ');
    msgTime = msgTime.toString().split(' ');

    // date of message
    var date = msgTime[0].split("-");
    // hour minute secound
    var HMS = msgTime[1].split(":");

    var finalTimeString =
        "${date[2]}/${date[1]}/${date[0]} ${HMS[0]}:${HMS[1]}";

    Widget MessageInp = Text(
      message,
      style: const TextStyle(
          color: Colors.white, fontSize: descriptionfontOfWidget),
    );
    if (message.startsWith(image_signalizer)) {
      int id = int.parse(message.substring(image_signalizer.length));
      MessageInp = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Image.network(get_image_url(id), fit: BoxFit.contain),
            ),
          ],
        ),
      );
    }

    if (_me == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(19),
                  topLeft: Radius.circular(19),
                  bottomLeft: Radius.circular(19),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        author,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: SecondfontOfWidget - 2,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          finalTimeString.toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: descriptionfontOfWidget - 2,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                  MessageInp
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: widgetColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(19),
                  topRight: Radius.circular(19),
                  bottomRight: Radius.circular(19),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        author,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: SecondfontOfWidget - 2,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          finalTimeString.toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: descriptionfontOfWidget - 2,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                  MessageInp
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
