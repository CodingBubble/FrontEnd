import 'package:flutter/material.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/app_bars/event_app_bar.dart';

class EventWidget extends StatefulWidget {
  final int state;
  const EventWidget({super.key, required this.state});
  @override
  State<EventWidget> createState() => _EventWidget(state);
}

class _EventWidget extends State<EventWidget> {
  int state;
  _EventWidget(this.state);
  void initState() {
    super.initState();
    switch (state) {
      case 0:
        load_announcement_history();
        break;
      case 1:
        load_message_history();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    void t()=>{};
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dein Event",
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_event_app_bar(context, current_event!.name),
        drawer: new Drawer(
        backgroundColor: widgetColor,
        width: MediaQuery.of(context).size.width * 0.2,
        child: new ListView(
          children: <Widget> [
            Container(height:  MediaQuery.of(context).size.height * 0.1),
            new ListTile(
              title: new Icon(
                Icons.speaker,
                color: primaryTextColor
              ),
              onTap: () {AppHandler("eventWidget", context, [0]);},
            ),
            new ListTile(
              title: new Icon(
                Icons.chat,
                color: primaryTextColor
              ),
              onTap: () {AppHandler("eventWidget", context, [1]);},
            ),
            new ListTile(
              title: new Icon(
                Icons.list,
                color: primaryTextColor
              ),
              onTap: () {AppHandler("eventWidget", context, [2]);},
            ),
            new ListTile(
              title: new Icon(
                Icons.where_to_vote,
                color: primaryTextColor
              ),
              onTap: () {AppHandler("eventWidget", context, [3]);},
            ),
          ],
        )
      ),
      body: new Center(
        child: get_body(state, context,send_message, load_message_history, send_announcement, load_announcement_history)
        )
      ),

    );
  }

  Future load_message_history() async {
    if (me == null) {
      print("me is null");
      return;
    }
    if (current_event == null) {
      print("cur event is null");
      return;
    }
    current_event!.get_messages().then((msgs) {
      event_message_history = [];
      msgs.forEach((msg) {
        event_message_history.add([msg.text, msg.author.id != me!.id]);
      });
      setState(() {});
    });
  }

  void send_message() async {
    if (me == null) {
      return;
    }
    if (current_event == null) {
      return;
    }
    if (inputMessageController.text.trim() == "") {
      return;
    }
    current_event!.send_message(inputMessageController.text.trim()).then((value) {
      if (value == null) {
        return;
      }
      inputMessageController.text = "";
      load_message_history();
    });
  }

  Future load_announcement_history() async {
    if (me == null) {
      print("me is null");
      return;
    }
    if (current_event == null) {
      print("cur event is null");
      return;
    }
    current_event!.get_announcements().then((msgs) {
      event_message_history = [];
      msgs.forEach((msg) {
        event_message_history.add([msg.text]);
      });
      setState(() {});
    });
  }

  void send_announcement() async {
    if (me == null) {
      return;
    }
    if (current_event == null) {
      return;
    }
    if (inputMessageController.text.trim() == "") {
      return;
    }
    current_event!.creator_send_announcement(inputMessageController.text.trim()).then((value) {
      if (value == null) {
        return;
      }
      inputMessageController.text = "";
      load_announcement_history();
    });
  }

}

var inputMessageController = TextEditingController();
Widget get_body(int i, BuildContext context, void Function() send_message, Future Function() load_message_history, void Function() send_announcement, Future Function() load_announcement_history){
  switch (i) {
    case 0:
      var c = Column(
          children: [
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
                              width: MediaQuery.of(context).size.width * 0.9, 
                              child: AnnouncentsData(event_message_history[event_message_history.length - index - 1])),
                        ],
                      ),
                    );
                  },
                  itemCount: event_message_history.length,
                ),
              ),
            ),
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
                          hintText: "Schreibe eine Rundnachricht",
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => {send_announcement()},
                        icon: Icon(Icons.send))
                  ],
                )),
              ),
            ),
          ]
      );
      if (current_event!.creator_id != me!.id) {
        c.children.removeAt(1);
      }
      return c; 
    case 1:
      /////////////////////// EVENT CHAT WIDGET ///////////////////////////////
      return Column(
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
                              child: WidgetmessageDesign(event_message_history[
                                  event_message_history.length - index - 1])),
                        ],
                      ),
                    );
                  },
                  itemCount: event_message_history.length,
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
                        onPressed: () => {send_message()},
                        icon: Icon(Icons.send))
                  ],
                )),
              ),
            ),
          ]
      );
    case 2:
      return Container();
    case 3:
      return Container();
  }
  return Container();
}



Widget AnnouncentsData (message) {
   return Container(
        child: Text(message[0], 
          style: TextStyle(color: primaryTextColor),
        )
    );
}

var event_message_history = [];

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
              color: widgetColor,
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

