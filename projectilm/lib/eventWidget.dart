import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/app_bars/event_app_bar.dart';
import 'package:projectilm/src/projectillm_bridgelib_lists.dart';
import 'package:intl/intl.dart';
import 'src/projectillm_bridgelib_vote.dart';

class EventWidget extends StatefulWidget {
  final int state;
  const EventWidget({super.key, required this.state});
  @override
  State<EventWidget> createState() => _EventWidget(state);
}

String lastChat = "";
String lastAnnouncement = "";
List<String> list_items = ["", ""];
final DateFormat formatter = DateFormat('dd. MM. yyyy HH:mm');
bool joined_event = false;

class _EventWidget extends State<EventWidget> {
  int state;
  _EventWidget(this.state);
  void initState() {
    super.initState();
    update_joined();
    switch (state) {
      case -1:
        get_last_announcement();
        get_last_chat();
        get_last_listitems();
        break;
      case 0:
        load_announcement_history();
        break;
      case 1:
        load_message_history();
        break;
      case 2:
        load_list_items();
        break;
      case 3:
        load_poll_history();
        break;
      case 4:
        load_members();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    void t() => {};
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: "Dein Event",
      home: Scaffold(
          backgroundColor: backgroundColor,
          appBar: get_event_app_bar(context, toggle_join),
          body: get_body(
              state,
              context,
              send_message,
              send_announcement,
              create_list_item,
              bring_list_item,
              unbring_list_item,
              delete_list_item,
              create_poll,
              delete_poll,
              create_voteoption,
              delete_voteoption,
              vote_for,
              unvote_for)),
    );
  }

  void update_joined() {
    current_event!.am_member().then((value) {
      joined_event = value;
      setState(() {});
    });
  }

  void toggle_join() {
    if (joined_event) {
      current_event!.leave();
    } else {
      current_event!.join();
    }
    setState(() {});
  }

  void get_last_chat() {
    current_event!.get_messages_gen(0).then((value) {
      if (value.length > 0) {
        lastChat = value[0].text.substring(0, min(value[0].text.length, 50));
        setState(() {});
      }
    });
  }

  void get_last_announcement() {
    current_event!.get_announcements_gen(0).then((value) {
      if (value.length > 0) {
        lastAnnouncement =
            value[0].text.substring(0, min(value[0].text.length, 50));
        setState(() {});
      }
    });
  }

  void get_last_listitems() {
    current_event!.get_list_items().then((msgs) {
      list_items = ["", ""];
      msgs.forEach((msg) {
        if (msg.bringer == "") {
          list_items.add(msg.title);
        }
      });
      list_items = list_items.reversed.toList();
      setState(() {});
    });
  }

  void load_members() {
    current_event!.get_members().then((mbrs) {
      event_data_list = [];
      mbrs.forEach((mbr) {
        event_data_list.add([mbr.username, mbr]);
      });
      setState(() {});
    });
  }

  void load_message_history() {
    current_event!.get_messages().then((msgs) {
      event_data_list = [];
      msgs.forEach((msg) {
        event_data_list.add([msg.text, msg.author.id != me!.id, msg.author.username]);
      });
      setState(() {});
    });
  }

  void send_message() {
    if (inputMessageController.text.trim() == "") {
      return;
    }
    current_event!
        .send_message(inputMessageController.text.trim())
        .then((value) {
      if (value == null) {
        return;
      }
      inputMessageController.text = "";
      load_message_history();
    });
  }

  void load_list_items() {
    current_event!.get_list_items().then((msgs) {
      event_data_list = [];
      msgs.forEach((msg) {
        event_data_list.add([msg.title, msg]);
      });
      setState(() {});
    });
  }

  void create_list_item() {
    if (inputMessageController.text.trim() == "") {
      return;
    }
    current_event!
        .creator_list_add_item(inputMessageController.text.trim())
        .then((value) {
      if (value == null) {
        return;
      }
      inputMessageController.text = "";
      load_list_items();
    });
  }

  void bring_list_item(ListItem item) {
    item.bring_me().then((value) {
      if (value) {
        load_list_items();
      }
    });
  }

  void unbring_list_item(ListItem item) {
    item.unbring_me().then((value) {
      if (value) {
        load_list_items();
      }
    });
  }

  void delete_list_item(ListItem item) {
    item.creator_delete().then((value) {
      if (value) {
        load_list_items();
      }
    });
  }

  void load_announcement_history() {
    current_event!.get_announcements().then((msgs) {
      event_data_list = [];
      msgs.forEach((msg) {
        event_data_list.add([msg.text]);
      });
      setState(() {});
    });
  }

  void send_announcement() {
    if (inputMessageController.text.trim() == "") {
      return;
    }
    current_event!
        .creator_send_announcement(inputMessageController.text.trim())
        .then((value) {
      if (value == null) {
        return;
      }
      inputMessageController.text = "";
      load_announcement_history();
    });
  }

  void load_poll_history() async {
    event_data_list = [];
    var polls = await current_event!.get_polls();
    for (Poll poll in polls) {
      var my_opts = await poll.get_my_voted_options();
      var options = await poll.get_options();
      var vote_nums = [];
      for (var o in options) {
        vote_nums.add(await o.get_vote_count());
      }
      var count = await poll.get_vote_count();
      event_data_list
          .add([poll.title, poll, count, options, vote_nums, my_opts]);
    }
    setState(() {});
  }

  void create_poll() {
    if (inputMessageController.text.trim() == "") {
      return;
    }
    current_event!
        .creator_create_poll(inputMessageController.text.trim())
        .then((value) {
      if (value == null) {
        return;
      }
      current_event!.creator_send_announcement(
          "Es wurde eine neue Umfrage erstellt: " +
              inputMessageController.text.trim());
      inputMessageController.text = "";
      load_poll_history();
    });
  }

  void delete_poll(Poll p) {
    p.creator_delete().then((value) {
      if (!value) {
        return;
      }
      load_poll_history();
    });
  }

  void create_voteoption(Poll p, TextEditingController c) {
    if (c.text.trim() == "") {
      return;
    }
    p!.creator_create_option(c.text.trim()).then((value) {
      if (value == null) {
        return;
      }
      c.text = "";
      load_poll_history();
    });
  }

  void delete_voteoption(VoteOption p) {
    if (me == null) {
      return;
    }
    p.creator_delete().then((value) {
      if (!value) {
        return;
      }
      load_poll_history();
    });
  }

  void vote_for(VoteOption p) {
    p.vote_for().then((value) {
      if (!value) {
        return;
      }
      load_poll_history();
    });
  }

  void unvote_for(VoteOption p) {
    p.unvote_for().then((value) {
      if (!value) {
        return;
      }
      load_poll_history();
    });
  }
}

var inputMessageController = TextEditingController();
Widget get_body(
    int i,
    BuildContext context,
    Function() send_message,
    Function() send_announcement,
    void Function() create_list_item,
    void Function(ListItem item) bring_list_item,
    void Function(ListItem item) unbring_list_item,
    void Function(ListItem item) delete_list_item,
    void Function() create_poll,
    void Function(Poll p) delete_poll,
    void Function(Poll, TextEditingController) create_voteoption,
    void Function(VoteOption p) delete_voteoption,
    void Function(VoteOption p) vote_for,
    void Function(VoteOption p) unvote_for) {
  switch (i) {
    case -1:
      return SingleChildScrollView(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Ort:  " + current_event!.description,
            style: TextStyle(color: primaryTextColor, fontSize: 20),
          ),
          Text(
            "Zeit: " + formatter.format(current_event!.time.toLocal()),
            style: TextStyle(color: primaryTextColor, fontSize: 20),
          ),
          Column(children: [
            get_home_item("Ankündigungen", Icons.info_outline, 0,
                lastAnnouncement, context),
            get_home_item(
                "Chat", Icons.chat_bubble_outline, 1, lastChat, context),
            get_home_item("Einkaufsliste", Icons.list_alt_outlined, 2,
                list_items[0] + "\n" + list_items[1], context),
            get_home_item(
                "Umfragen", Icons.how_to_vote_outlined, 3, "", context),
            //  get_home_item("Teilnehmer",    Icons.group,                4, "",               context),
          ]),
        ],
      ));

    case 0:
<<<<<<< HEAD
      ///////////////////////////// EVENT ANNOUNCEMENTS ///////////////////////////////
      var c = Column(children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Scrollbar(
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Material(
                  child: Column(
                    children: [
                      new Padding(
                          padding: EdgeInsets.all(discanceBetweenWidgets)),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: AnnouncentsData(event_data_list[index])),
                    ],
                  ),
                );
              },
              itemCount: event_data_list.length,
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
      ]);
=======
    ///////////////////////////// EVENT ANNOUNCEMENTS ///////////////////////////////
      var c = Column(
          children: [
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
                        children: [
                          new Padding(
                              padding: EdgeInsets.all(discanceBetweenWidgets)),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9, 
                              child: AnnouncentsData(event_data_list[index])),
                        ],
                      ),
                    );
                  },
                  itemCount: event_data_list.length,
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
                          style: TextStyle(color: primaryTextColor),
                          controller: inputMessageController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Rundnachricht",
                            hintStyle: TextStyle(color: primaryTextColor),
                            floatingLabelStyle: TextStyle(color: variationColor),
                          ),
                        ),
                      ),
                    IconButton(
                        onPressed: () => {send_announcement()},
                        icon: Icon(Icons.send, color: secondaryTextColor))
                  ],
                )),
              ),
            ),
          ]
      );
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
      if (current_event!.creator_id != me!.id) {
        c.children.removeAt(1);
      }
      return c;
    case 1:
      /////////////////////// EVENT CHAT WIDGET ///////////////////////////////
<<<<<<< HEAD
      return Column(children: [
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
                  child: Column(
                    children: [
                      new Padding(
                          padding: EdgeInsets.all(discanceBetweenWidgets)),
                      Container(
                          width: MediaQuery.of(context).size.width *
                              0.9, // the distance to the margin of display
                          child: WidgetmessageDesign(event_data_list[index])),
                    ],
                  ),
                );
              },
              itemCount: event_data_list.length,
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
=======
      return Column(
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
                        children: [
                          new Padding(
                              padding: EdgeInsets.all(discanceBetweenWidgets)),
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  0.9, // the distance to the margin of display
                              child: WidgetmessageDesign(event_data_list[index])),
                        ],
                      ),
                    );
                  },
                  itemCount: event_data_list.length,
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
                        style: TextStyle(color: primaryTextColor),
                        controller: inputMessageController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Schreibe eine Nachricht",
                          hintStyle: TextStyle(color: primaryTextColor),
                          floatingLabelStyle: TextStyle(color: variationColor),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => {send_message()},
                        icon: Icon(Icons.send, color: secondaryTextColor))
                  ],
                )),
              ),
            ),
          ]
      );
    case 2:
       ///////////////////////////// EVENT LIST ITEMS ///////////////////////////////
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
                      color: backgroundColor,
                      child: Column(
                        children: [
                          new Padding(
                              padding: EdgeInsets.all(discanceBetweenWidgets)),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9, 
                              child: ListData(event_data_list[index], bring_list_item, unbring_list_item, delete_list_item)),
                        ],
                      ),
                    );
                  },
                  itemCount: event_data_list.length,
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
                ),
                IconButton(
                    onPressed: () => {send_message()}, icon: Icon(Icons.send))
              ],
            )),
          ),
        ),
      ]);
    case 2:
      ///////////////////////////// EVENT LIST ITEMS ///////////////////////////////
      var c = Column(children: [
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
                          child: ListData(
                              event_data_list[index],
                              bring_list_item,
                              unbring_list_item,
                              delete_list_item)),
                    ],
                  ),
                );
              },
              itemCount: event_data_list.length,
            ),
<<<<<<< HEAD
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
                      hintText: "Neuer Eintrag",
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => {create_list_item()},
                    icon: Icon(Icons.add))
              ],
            )),
          ),
        ),
      ]);
=======
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
                        style: TextStyle(color: primaryTextColor),
                        controller: inputMessageController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Neuer Eintrag",
                          hintStyle: TextStyle(color: primaryTextColor),
                          floatingLabelStyle: TextStyle(color: variationColor),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => {create_list_item()},
                        icon: Icon(Icons.add, color: secondaryTextColor))
                  ],
                )),
              ),
            ),
          ]
      );
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
      if (current_event!.creator_id != me!.id) {
        c.children.removeAt(1);
      }
      return c;
    case 3:
<<<<<<< HEAD
      ///////////////////////////// EVENT POLLS ///////////////////////////////
      var c = Column(children: [
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
                          padding: EdgeInsets.all(discanceBetweenWidgets * 3)),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: PollData(
                              event_data_list[index],
                              create_voteoption,
                              delete_voteoption,
                              delete_poll,
                              vote_for,
                              unvote_for,
                              context)),
                      new Padding(
                          padding: EdgeInsets.all(discanceBetweenWidgets * 5)),
                    ],
                  ),
                );
              },
              itemCount: event_data_list.length,
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
                      hintText: "Neue Umfrage",
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => {create_poll()}, icon: Icon(Icons.add_box))
              ],
            )),
          ),
        ),
      ]);
=======
     ///////////////////////////// EVENT POLLS ///////////////////////////////
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
                      color: backgroundColor,
                      child: Column(
                        children: [
                          new Padding(
                              padding: EdgeInsets.all(discanceBetweenWidgets * 3)),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.9, 
                              child: PollData(event_data_list[index], create_voteoption, delete_voteoption, delete_poll, vote_for, unvote_for, context)),
                          new Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets * 5)),
                        ],
                          
                      ),
                    );
                  },
                  itemCount: event_data_list.length,
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
                        style: TextStyle(color: primaryTextColor),
                        controller: inputMessageController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Neue Frage",
                          hintStyle: TextStyle(color: primaryTextColor),
                          floatingLabelStyle: TextStyle(color: variationColor),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => {create_poll()},
                        icon: Icon(Icons.add_box, color: secondaryTextColor))
                  ],
                )),
              ),
            ),
          ]
      );
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
      if (current_event!.creator_id != me!.id) {
        c.children.removeAt(1);
      }
      return c;

    case 4:
      ///////////////////// EVENT MEMBERS ///////////////////////////////////////
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
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
                        child: MemberData(event_data_list[
                            event_data_list.length - index - 1])),
                  ],
                ),
              );
            },
            itemCount: event_data_list.length,
          ),
        ),
      );
  }
  return Container();
}

Widget get_home_item(String text, IconData icon, int keyD, String additional,
    BuildContext context) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
      child: Container(
<<<<<<< HEAD
          height: MediaQuery.of(context).size.height * 0.18,
          child: TextButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(icon,
                      color: primaryTextColor,
                      size: MediaQuery.of(context).size.width * 0.14),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(text,
                              style: TextStyle(
                                  color: primaryTextColor, fontSize: 19)),
                          Text(additional,
                              style: TextStyle(
                                  color: secondaryTextColor, fontSize: 14))
                        ],
                      ))
                ]),
            onPressed: () => AppHandler("eventWidget", context, [keyD]),
          )));
=======
        height: MediaQuery.sizeOf(context).height*0.18,
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(icon, color: primaryTextColor, size: min(MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height)*0.14),
              Container( 
                width: MediaQuery.sizeOf(context).width * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: TextStyle(color: secondaryTextColor, fontSize: 19)),
                    Text(additional, style: TextStyle(color: primaryTextColor, fontSize: 14))
                  ],
                )
              )
            ]
          ),
          onPressed: ()=>AppHandler("eventWidget", context, [keyD]),
        )
      )
  );
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
}

Widget ListData(item, add_me, remove_me, delete_item) {
  var icon = Icon(Icons.circle, color: secondaryTextColor);
  Widget del_button = Container();
<<<<<<< HEAD
  if (current_event!.creator_id == me!.id) {
    del_button = IconButton(
        icon: Icon(Icons.delete_forever_outlined, color: variationColor),
        onPressed: () => {delete_item(item[1])});
=======
  if (current_event!.creator_id == me!.id){
    del_button = IconButton(icon: Icon(Icons.delete_forever_outlined, color: positiveColor), onPressed: ()=>{delete_item(item[1])});
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
  }
  if (item[1].bringer != "") {
    icon = Icon(Icons.check, color: variationColor);
  }
  return Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
          icon: icon,
          onPressed: () {
            if (item[1].bringer == "") {
              add_me(item[1]);
            } else if (item[1].bringer == me!.username) {
              remove_me(item[1]);
            }
          }),
      Column(
        children: [
          Text(item[0], style: TextStyle(color: primaryTextColor)),
          Text(item[1].bringer, style: TextStyle(color: secondaryTextColor)),
        ],
      ),
      del_button
    ],
  ));
}

Widget MemberData(member) {
  IconData icon = Icons.person;
  if (member[1].id == current_event!.creator_id) {
    icon = Icons.star;
  }
  return Container(
      child: Row(
    children: [
      Icon(icon, color: secondaryTextColor),
      Text(member[0], style: TextStyle(color: primaryTextColor))
    ],
  ));
}

<<<<<<< HEAD
Widget AnnouncentsData(message) {
  return Container(
      child: Text(
    message[0],
    style: TextStyle(color: primaryTextColor),
  ));
=======
Widget AnnouncentsData (message) {
   return Container(
        child: Text(message[0], 
          style: TextStyle(color: secondaryTextColor),
        )
    );
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
}

Widget PollData(
    item, add_item, remove_item, delete_this, vote, unvote, context) {
  final controller = TextEditingController();
  Widget del_button = Container();
<<<<<<< HEAD
  if (current_event!.creator_id == me!.id) {
    del_button = IconButton(
        icon: Icon(Icons.delete_forever_outlined, color: variationColor),
        onPressed: () => {delete_this(item[1])});
  }
  return Container(
      child: Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item[2].toString(), style: TextStyle(color: secondaryTextColor)),
        Text(item[0],
            style: TextStyle(
                color: primaryTextColor, decoration: TextDecoration.underline)),
        del_button,
      ],
    ),
    ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Material(
            child: VoteOptionData(item[3][index], item[4][index], item[5],
                remove_item, vote, unvote, context));
      },
      itemCount: item[3].length,
    ),
    Row(
      children: [
        IconButton(
            onPressed: () => {add_item(item[1], controller)},
            icon: Icon(Icons.add_box)),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Neue Option",
            ),
          ),
        )
      ],
    )
  ]));
=======
  if (current_event!.creator_id == me!.id){
    del_button = IconButton(icon: Icon(Icons.delete_forever_outlined, color: variationColor), onPressed: ()=>{delete_this(item[1])}
    );
  }
  var c=  Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item[2].toString(), style: TextStyle(color: secondaryTextColor)),
              Text(item[0], style: TextStyle(color: secondaryTextColor, decoration: TextDecoration.underline, fontSize: 16)),
              del_button,
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Material(
                color: backgroundColor,
                child: VoteOptionData(item[3][index], item[4][index], 
                    item[5], remove_item, vote, unvote, context)
              ); 
            },
            itemCount: item[3].length,
          ),
          Row(
                children: [
                  IconButton(
                    onPressed: () => {add_item(item[1], controller)},
                    icon: Icon(Icons.add_box, color: secondaryTextColor)
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextFormField(
                        controller: controller,
                        style: TextStyle(color: secondaryTextColor),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Neue Option",
                          hintStyle: TextStyle(color: secondaryTextColor),
                          floatingLabelStyle: TextStyle(color: primaryTextColor),
                        ),
                      ),
                  )
                ],
          )
        ]    
  );
  if (current_event!.creator_id!=me!.id){
    c.children.removeAt(2);
  }
  return Container(child: c);
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
}

bool voted_for(List<VoteOption> l, VoteOption o) {
  for (var o1 in l) {
    if (o.id == o1.id) {
      return true;
    }
  }
  return false;
}

Widget VoteOptionData(VoteOption data, int num, List<VoteOption> my_opts,
    delete, vote, unvote, context) {
  Widget del_button = Container();
<<<<<<< HEAD
  if (current_event!.creator_id == me!.id) {
    del_button = IconButton(
        icon: Icon(Icons.remove, color: variationColor),
        onPressed: () => {delete(data)});
  }
  Widget vote_btn = IconButton(
      onPressed: () => vote(data),
      icon: Icon(Icons.check_box_outline_blank),
      color: primaryTextColor);
  if (voted_for(my_opts, data)) {
    vote_btn = IconButton(
        onPressed: () => unvote(data),
        icon: Icon(Icons.check_box),
        color: primaryTextColor);
  }

  return Container(
=======
  if (current_event!.creator_id == me!.id){
    del_button = IconButton(icon: Icon(Icons.remove, color: variationColor), onPressed: ()=>{delete(data)});
  }
  Widget vote_btn = IconButton(onPressed: () => vote(data), icon: Icon(Icons.check_box_outline_blank), color: secondaryTextColor);
  if ( voted_for(my_opts, data))
  {
     vote_btn = IconButton(onPressed: () => unvote(data), icon: Icon(Icons.check_box), color: positiveColor);
  }
  
    return Container(    
>>>>>>> 08066677ffd7d5286cb645d21ca6e9414df09dd5
      child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(num.toString(), style: TextStyle(color: secondaryTextColor)),
      Text(data.title, style: TextStyle(color: primaryTextColor)),
      Row(
        children: [
          vote_btn,
          del_button,
        ],
      )
    ],
  ));
}

var event_data_list = [];

var inputMessage = "";
Widget WidgetmessageDesign(list) {
  var message = list[0];
  var _me = list[1];
  var author = list[2];
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  author,
                  style: TextStyle(color: secondaryTextColor, fontSize: 10),
                  textAlign: TextAlign.left,
                ),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            )),
        ),
      ],
    ));
  }
}
