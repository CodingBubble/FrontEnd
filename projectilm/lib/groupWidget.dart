import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projectilm/app_bars/group_app_bar.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'global.dart';

class GroupWidget extends StatefulWidget {
  final String title;
  const GroupWidget({super.key, required this.title});
  @override
  State<GroupWidget> createState() => _StateGroup();
}

class _StateGroup extends State<GroupWidget> {
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
        appBar: get_group_app_bar(context),
        body: Column(
          children: [
            //first widget as official chat
            Container(
              child: Column(
                children: [
                  new Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: chat("offizieller Chat"),
                      onPressed: () => {
                        AppHandler("chatWidget", context,
                            ["Grouping", "offizieller Chat"])
                      },
                    ),
                  )
                ],
              ),
            ),
            //second widget as Scrollbar for all events
            new Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
            scrollEvents()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppHandler("create_event", context, []);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add_circle),
        ),
      ),
    );
  }

  Widget eventWidget(Event ev, int index) {
    return Container(
      child: Column(
        children: [
          Text(ev.name,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: HeadfontOfWidget,
              )),
          Text(ev.description,
              style: TextStyle(
                  color: secondaryTextColor, fontSize: SecondfontOfWidget)),
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: Icon(get_icon(index)),
                      color: get_color(index),
                      onPressed: () => {/*code to insert here for Jakob*/},
                    ),
                    // here to add the onPressed-command to se
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      alignment: Alignment.center,
      width: double.infinity,
    );
  }

  List<Event> Events = <Event>[];

  List<bool> Joined = <bool>[];

  IconData get_icon(evid) => Joined[evid] ? Icons.check:Icons.close;
  

  Color get_color(evid) => Joined[evid] ? positiveColor:negativeColor;
  


  void loadEvents() {
    //TODO: make Login used by me
    if (me==null) {return;}
    current_group?.get_events_active().then((events) async {
      Joined = [];
      for(var event in events)
      {
        Joined.add(await event.am_member());
      }
      setState(() {
        Events = events;
      });
    });
  }



  Widget chat(name) {
    return Container(
      child: Text(
        name,
        style: TextStyle(
          color: primaryTextColor,
          fontSize: HeadfontOfWidget,
        ),
      ),
      padding: constPadding,
      alignment: Alignment.center,
      margin: constMargin,
      width: double.infinity,
    );
  }

  Widget scrollEvents() {
    return Expanded(flex: 1,
         child: Container(
        constraints: BoxConstraints.expand(),
        child: Scrollbar(
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
        )));
  }
}
