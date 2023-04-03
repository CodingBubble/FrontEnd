import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/group/mainWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/app_bars/event_app_bar.dart';
import 'package:projectilm/src/projectillm_bridgelib_lists.dart';
import 'package:intl/intl.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/app_bars/simple_app_bar.dart';
import 'package:projectilm/src/projectillm_bridgelib_vote.dart';

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
bool has_unvoted_poll = false;

class _EventWidget extends State<EventWidget> {
  int state;
  final ImagePicker picker = ImagePicker();
  _EventWidget(this.state);

  @override
  void initState() {
    super.initState();
    update_joined();
    switch (state) {
      case -1:
        has_unvoted_poll = false;
        get_last_announcement();
        get_last_chat();
        get_last_listitems();
        get_unvoted_polls();
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
    var AppBar = get_simple_app_bar(context, "");
    AppBar = get_event_app_bar(context, toggle_join, state);

    void t() => {};
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: "Dein Event",
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar,
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
            unvote_for,
            getImage),
      ),
    );
  }

  void update_joined() {
    current_event!.am_member().then((value) {
      joined_event = value;
      setState(() {});
    });
  }

  void toggle_join() async {
    if (joined_event) {
      await current_event!.leave();
    } else {
      await current_event!.join();
    }
    update_joined();
  }

  void get_last_chat() {
    current_event!.get_messages_gen(0).then((value) {
      if (value.length > 0) {
        lastChat = value[0].text.substring(0, min(value[0].text.length, 50));
        if (lastChat.startsWith(image_signalizer)) {
          lastChat = "Bild";
        }
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

  void get_unvoted_polls() async {
    List<Poll> polls = await current_event!.get_polls();
    polls.forEach((poll) async {
      List<VoteOption> options = await poll.get_my_voted_options();
      has_unvoted_poll = has_unvoted_poll || options.length == 0;
      setState(() {});
    });
  }

  void load_members() {
    current_event!.get_members().then((mbrs) {
      event_data_list = [];
      mbrs.forEach((mbr) {
        event_data_list.add([mbr.username, mbr]);
        membersList.add([mbr.username, mbr]);
      });
      setState(() {});
    });
  }

  void load_message_history() {
    current_event!.get_messages().then((msgs) {
      event_data_list = [];
      msgs.forEach((msg) {
        event_data_list.add(
            [msg.text, msg.author.id == me!.id, msg.author.username, msg.time]);
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

  void load_list_items() async {
    var msgs = await current_event!.get_list_items();
    event_data_list = [];
    msgs.forEach((msg) {
      event_data_list.add([msg.title, msg]);
    });
    setState(() {});
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
        event_data_list.add([msg.text, msg.time]);
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
          "Es wurde eine neue Umfrage erstellt: ${inputMessageController.text.trim()}");
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
    p.creator_create_option(c.text.trim()).then((value) {
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

  Future getImage() async {
    var img = await picker.pickImage(source: ImageSource.gallery);
    var uploaded = await current_group!.upload_image(File(img!.path));
    await current_event!.send_message(image_signalizer + uploaded.toString());
    load_message_history();
  }
}

// var Einkaufsliste;
// void checkIfEinkaufslisteIsEmpty() {
//   if (list_items[0] == "") {
//     Einkaufsliste = "Keine Sachen fehlen";
//   } else {}
// }

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
  void Function(VoteOption p) unvote_for,
  Future Function() getImage,
) {
  switch (i) {
    case -1:
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      "Ort:  ${current_event!.description}",
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: SecondfontOfWidget - 2,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      "Zeit: ${formatter.format(current_event!.time)}",
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: SecondfontOfWidget - 2,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
            ),
            Column(
              children: [
                get_home_item("Ankündigungen", Icons.info_outline, 0,
                    lastAnnouncement, context),
                get_home_item(
                    "Chat", Icons.chat_bubble_outline, 1, lastChat, context),
                get_home_item("Einkaufsliste", Icons.list_alt_outlined, 2,
                    "${list_items[0]}\n${list_items[1]}", context),
                get_home_item("Umfragen", Icons.how_to_vote_outlined, 3,
                    has_unvoted_poll ? "Neue Umfrage!" : "", context),
                //  get_home_item("Teilnehmer",    Icons.group,                4, "",               context),
              ],
            ),
          ],
        ),
      );

    case 0:
      ///////////////////////////// EVENT ANNOUNCEMENTS ///////////////////////////////
      ///
      ///
      // String getMemberList() {
      //   String o = "Admin";
      //   // List leer weil -
      //   print(membersList);
      //   membersList.forEach((mbr) {
      //     if (current_event!.creator_id == mbr.username) {
      //       // ignore: void_checks
      //       o = mbr.username;
      //     }
      //   });
      //   return o;
      // }

      var c = Column(
        children: [
          Container(
            padding: constPadding,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95 - 120,
            child: Scrollbar(
              child: ListView.builder(
                reverse: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Material(
                    color: backgroundColor,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(discanceBetweenWidgets),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child:
                              AnnouncentsData(event_data_list[index], "Admin"),
                        ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: primaryTextColor),
                            controller: inputMessageController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Rundnachricht",
                              hintStyle: TextStyle(
                                color: primaryTextColor,
                                fontSize: descriptionfontOfWidget,
                              ),
                              floatingLabelStyle: TextStyle(
                                color: variationColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () => {send_announcement()},
                      icon: Icon(Icons.send, color: secondaryTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95 - 125,
            child: Scrollbar(
              child: ListView.builder(
                reverse: false,
                shrinkWrap: true,
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
                          child: WidgetmessageDesign(
                            event_data_list[index],
                            context,
                          ),
                        ),
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
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: constPadding * 0.5,
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
                            fontSize: descriptionfontOfWidget,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: variationColor,
                          ),
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
        ],
      );
    case 2:
      ///////////////////////////// EVENT LIST ITEMS ///////////////////////////////
      if (event_data_list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
              ),
              Column(
                children: [
                  Text(
                    "Noch keine Einträge!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: SecondfontOfWidget,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30),
                  ),
                  Text(
                    current_event!.creator_id == me!.id
                        ? "Erstelle einen Eintrag, wenn noch Sachen benötigt werden."
                        : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: SecondfontOfWidget,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ret_if(
                current_event!.creator_id == me!.id,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    padding: constPadding * 0.5,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  style: TextStyle(color: primaryTextColor),
                                  controller: inputMessageController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Neuer Eintrag",
                                    hintStyle: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: descriptionfontOfWidget,
                                    ),
                                    floatingLabelStyle:
                                        TextStyle(color: variationColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () => {create_list_item()},
                            icon: Icon(Icons.add, color: secondaryTextColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1 - 125,
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Material(
                    color: backgroundColor,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(discanceBetweenWidgets),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListData(
                            event_data_list[index],
                            bring_list_item,
                            unbring_list_item,
                            delete_list_item,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: event_data_list.length,
              ),
            ),
          ),
          ret_if(
            current_event!.creator_id == me!.id,
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: constPadding * 0.5,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: constPadding * 0.15,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: primaryTextColor),
                              controller: inputMessageController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Neuer Eintrag",
                                hintStyle: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: descriptionfontOfWidget,
                                ),
                                floatingLabelStyle:
                                    TextStyle(color: variationColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () => {create_list_item()},
                        icon: Icon(Icons.add, color: secondaryTextColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]);
      }
    case 3:
      ///////////////////////////// EVENT POLLS ///////////////////////////////
      if (event_data_list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
              ),
              Column(
                children: [
                  Text(
                    "Noch keine Umfrage!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: SecondfontOfWidget,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30),
                  ),

                  ///////////// Noch keine Zusatztext der Sinvoll ist, ist mir eingefallen
                  // Text(
                  //   "Erstelle eine Umfrage, wenn noch Sachen benötigt werden.",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: primaryTextColor,
                  //     fontSize: SecondfontOfWidget,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
              ret_if(
                current_event!.creator_id == me!.id,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  style: TextStyle(color: primaryTextColor),
                                  controller: inputMessageController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Neue Umfrage",
                                    hintStyle: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: descriptionfontOfWidget,
                                    ),
                                    floatingLabelStyle:
                                        TextStyle(color: variationColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () => {create_poll()},
                            icon:
                                Icon(Icons.add_box, color: secondaryTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 125,
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Material(
                      color: backgroundColor,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets * 3),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: PollData(
                              event_data_list[index],
                              create_voteoption,
                              delete_voteoption,
                              delete_poll,
                              vote_for,
                              unvote_for,
                              context,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(discanceBetweenWidgets * 5),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: event_data_list.length,
                ),
              ),
            ),
            ret_if(
              current_event!.creator_id == me!.id,
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(color: primaryTextColor),
                                controller: inputMessageController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Neue Umfrage",
                                  hintStyle: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: descriptionfontOfWidget,
                                  ),
                                  floatingLabelStyle:
                                      TextStyle(color: variationColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () => {create_poll()},
                          icon: Icon(Icons.add_box, color: secondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }
    case 4:
      ///////////////////// EVENT MEMBERS ///////////////////////////////////////
      return SizedBox(
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
                    const Padding(
                      padding: EdgeInsets.all(discanceBetweenWidgets),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.9, // the distance to the margin of display
                      child: MemberData(
                        event_data_list[event_data_list.length - index - 1],
                      ),
                    ),
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
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.18,
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 15),
              child: Icon(
                icon,
                color: primaryTextColor,
                size: min(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height) *
                    0.14,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.fromLTRB(2, 5, 0, 1),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: SecondfontOfWidget - 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      additional,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: descriptionfontOfWidget,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onPressed: () => AppHandler("eventWidget", context, [keyD]),
      ),
    ),
  );
}

Widget ListData(item, add_me, remove_me, delete_item) {
  var icon = Icon(Icons.circle, color: secondaryTextColor);
  Widget del_button = Container();
  if (current_event!.creator_id == me!.id) {
    del_button = IconButton(
        icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
        onPressed: () => {delete_item(item[1])});
  }
  if (item[1].runtimeType.toString() != (ListItem).toString()) {
    return Container();
  }
  if (item[1].bringer != "") {
    icon = Icon(Icons.check, color: variationColor);
  }
  return Row(
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
          Text(
            item[0],
            style: TextStyle(
              color: primaryTextColor,
              fontSize: descriptionfontOfWidget,
            ),
          ),
          Text(
            item[1].bringer,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: descriptionfontOfWidget,
            ),
          ),
        ],
      ),
      del_button
    ],
  );
}

Widget MemberData(member) {
  IconData icon = Icons.person;
  Color iconColor = secondaryTextColor;
  if (member[1].id == current_event!.creator_id) {
    icon = Icons.star_rounded;
    iconColor = Colors.yellow;
  }
  return Padding(
    padding: constPadding,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: widgetColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: constPadding,
            child: Text(
              member[0],
              style: TextStyle(color: primaryTextColor),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: constPadding,
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Row AnnouncentsData(list, admin) {
  var message = list[0];
  var msgTime = list[1];
  // var date = msgTime.split(' ');
  msgTime = msgTime.toString().split(' ');

  // date of message
  var date = msgTime[0].split("-");
  // hour minute secound
  var HMS = msgTime[1].split(":");

  var finalTimeString = "${date[2]}/${date[1]}/${date[0]} ${HMS[0]}:${HMS[1]}";

  // größter Bubatz => nicht dynamisch => gibt nur einen creator => bei einführung von Admins => bitte änder => Announcements haben keinen Autor => danke GOTT
  Widget MessageInp = Text(
    message,
    style: const TextStyle(color: Colors.white, fontSize: 15),
  );

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
                    admin,
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

@override
Widget PollData(
  item,
  add_item,
  remove_item,
  delete_this,
  vote,
  unvote,
  context,
) {
  final controller = TextEditingController();
  Widget del_button = Container();
  if (current_event!.creator_id == me!.id) {
    del_button = IconButton(
      icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
      onPressed: () => {delete_this(item[1])},
    );
  }
  var c = Column(
    children: [
      Center(
        child: Text(
          item[0],
          style: TextStyle(
            color: secondaryTextColor,
            fontWeight: FontWeight.w500,
            fontSize: SecondfontOfWidget,
          ),
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Material(
            color: backgroundColor,
            child: VoteOptionData(
              item[3][index],
              item[4][index],
              item[5],
              remove_item,
              vote,
              unvote,
              context,
              index,
            ),
          );
        },
        itemCount: item[3].length,
      ),
      // Anzahl der Stimmen
      Container(
        margin: constMargin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Stimmen: ${item[2].toString()}",
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: descriptionfontOfWidget,
                fontWeight: FontWeight.w500,
              ),
            ),
            del_button,
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(discanceBetweenWidgets),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: widgetColor),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => {add_item(item[1], controller)},
              icon: Icon(Icons.add_box, color: secondaryTextColor),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                controller: controller,
                style: TextStyle(color: secondaryTextColor),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Neue Option",
                  hintStyle: TextStyle(
                    color: secondaryTextColor,
                    fontSize: descriptionfontOfWidget,
                  ),
                  floatingLabelStyle: TextStyle(color: primaryTextColor),
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );

  if (current_event!.creator_id != me!.id) {
    c.children.removeAt(2);
  }
  return Container(child: c);
}

bool voted_for(List<VoteOption> l, VoteOption o) {
  for (var o1 in l) {
    if (o.id == o1.id) {
      return true;
    }
  }
  return false;
}

Dismissible VoteOptionData(
  VoteOption data,
  int num,
  List<VoteOption> my_opts,
  delete,
  vote,
  unvote,
  context,
  index,
) {
  Widget del_button = Container();

  Widget vote_btn = IconButton(
    onPressed: () => vote(data),
    icon: const Icon(Icons.check_box_outline_blank),
    color: secondaryTextColor,
  );

  if (voted_for(my_opts, data)) {
    vote_btn = IconButton(
      onPressed: () => unvote(data),
      icon: const Icon(Icons.check_box),
      color: positiveColor,
    );
  }

  return Dismissible(
    key: Key(data.title),
    direction: DismissDirection.endToStart,
    confirmDismiss: (direction) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            "Option löschen?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: descriptionfontOfWidget - 3,
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
                  style: TextStyle(
                      fontSize: descriptionfontOfWidget - 6,
                      color: primaryTextColor),
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
                  style: TextStyle(
                      fontSize: descriptionfontOfWidget - 6,
                      color: primaryTextColor),
                ),
              ),
            )
          ],
        ),
      );
    },
    background: Container(
      color: Colors.redAccent,
      padding: constPadding,
      margin: const EdgeInsets.fromLTRB(30, 10, 10, 10), // EdgeInsets.all(10)
      child: const Icon(Icons.remove_circle_outline, color: Colors.white),
    ),
    onDismissed: (direction) {
      if (direction == DismissDirection.endToStart) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => () {
            my_opts.removeAt(index);
          },
        );
        delete(data);
      }
    },
    child: Padding(
      padding: constPadding * 1.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data.title,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: descriptionfontOfWidget,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                num.toString(),
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: descriptionfontOfWidget,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5),
              ),
              vote_btn,
            ],
          ),
        ],
      ),
    ),
  );
}

var event_data_list = [];
var membersList = [];

var inputMessage = "";
Widget WidgetmessageDesign(list, context) {
  var message = list[0];
  var _me = list[1];
  var author = list[2];
  var msgTime = list[3];
  var wColor;
  var bubbleCorner;

  msgTime = msgTime.toLocal().toString().split(' ');

  // date of message
  var date = msgTime[0].split("-");
  // hour minute secound
  var HMS = msgTime[1].split(":");

  var finalTimeString = "${date[2]}/${date[1]}/${date[0]} ${HMS[0]}:${HMS[1]}";

  Widget MessageInp = Text(
    message,
    style: const TextStyle(color: Colors.white, fontSize: 15),
  );
  if (message.startsWith(image_signalizer)) {
    int id = int.parse(
      message.substring(image_signalizer.length),
    );
    MessageInp = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
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
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Row(
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
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Row(
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
