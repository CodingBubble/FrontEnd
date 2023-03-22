import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:projectilm/global.dart';

class GroupWidget extends StatefulWidget {
  final String title;
  final bool archived;
  const GroupWidget({super.key, required this.title, required this.archived});
  @override
  State<GroupWidget> createState() => _StateGroup(archived);
}

class _StateGroup extends State<GroupWidget> {
  bool archived;
  _StateGroup(this.archived);

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Deine Gruppe",
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_group_app_bar(context, searchFilter, archived),
        body: Column(
          children: [
            //first widget: official chat
            Column(
              children: [
                const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(negativeColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        "Gruppen Chat",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: HeadfontOfWidget,
                        ),
                      ),
                    ),
                    onPressed: () => {
                      AppHandler("chatWidget", context,
                          ["Grouping", "offizieller Chat"])
                    },
                  ),
                )
              ],
            ),
            //second widget as Scrollbar for all events
            const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
            scrollEvents()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppHandler("create_event", context, []);
          },
          mini: true,
          backgroundColor: positiveColor,
          child: const Icon(
            Icons.add_circle,
          ),
        ),
      ),
    );
  }

  Widget eventWidget(Event ev, int index) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(15)),
          Text(ev.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: HeadfontOfWidget,
              )),
          const Padding(padding: EdgeInsets.all(15)),
          Text(
            ev.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: descriptionfontOfWidget,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 30,
                    icon: Icon(
                      get_icon(index),
                    ),
                    color: get_color(index),
                    onPressed: () => {toggle_join(index)},
                  ),
                  // here to add the onPressed-command to se
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toggle_join(int i) async {
    if (Joined[i]) {
      await Events[i].leave();
    } else {
      await Events[i].join();
    }
    loadEvents();
  }

  List<Event> Events = <Event>[];
  List<Event> Events_actual = <Event>[];
  List<bool> Joined = <bool>[];

  void searchFilter(String s) {
    Events = [...Events_actual];
    Events_actual.forEach((element) {
      if (!element.name.toLowerCase().contains(s.toLowerCase()) &&
          !element.description.toLowerCase().contains(s.toLowerCase())) {
        Events.remove(element);
      }
    });
    setState(() {});
  }

  IconData get_icon(evid) => Joined[evid] ? Icons.check : Icons.close;

  Color get_color(evid) => Joined[evid] ? positiveColor : negativeColor;

  void loadEvents() async {
    //TODO: make Login used by me
    if (me == null) {
      return;
    }
    List<Event> events = await (archived
        ? current_group!.get_events_achieved()
        : current_group!.get_events_active());
    Joined = [];
    for (var event in events) {
      Joined.add(await event.am_member());
    }
    int index = 0;
    for (int i = 0; i < Joined.length; i++) {
      if (Joined[i]) {
        bool save = Joined[index];
        Joined[index] = Joined[i];
        Joined[i] = save;

        var save2 = events[index];
        events[index] = events[i];
        events[i] = save2;

        index++;
      }
    }

    setState(() {
      Events = events;
      Events_actual = events;
    });
  }

  Widget chat(name) {
    return Container(
      padding: constPadding,
      alignment: Alignment.center,
      margin: constMargin,
      width: double.infinity,
      child: Text(
        name,
        style: TextStyle(
          color: secondaryTextColor,
          fontSize: HeadfontOfWidget,
        ),
      ),
    );
  }

  Widget scrollEvents() {
    if (Events.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
            Text(
              "Noch kein Event?",
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
              "Klicke auf das Plus unten rechts um eine Event zu erstellen.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: SecondfontOfWidget,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Scrollbar(
            child: ListView.builder(
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
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              widgetColor,
                            ),
                          ),
                          child: eventWidget(Events[index], index),
                          onPressed: () {
                            current_event = Events[index];
                            AppHandler("eventWidget", context, [-1]);
                          },
                          // first parameter is the keyword to the next widget, other is the context-builder for the nativigator-class, just copy and past it
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: Events.length,
            ),
          ),
        ),
      );
    }
  }
}
