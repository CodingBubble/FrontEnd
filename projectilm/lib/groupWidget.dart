import 'dart:ui';
import 'package:flutter/material.dart';
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
      title: "Deine Gruppen",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Container(
            child: Row(
              children: [
                Builder(builder: (BuildContext context) {
                  return (IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: WidgetColor,
                    onPressed: () => {
                      AppHandler("mainWidget", context, []),
                    },
                  )); // here to add the onPressed-command to search something
                }),
                Builder(builder: (BuildContext context) {
                  return (IconButton(
                    icon: Icon(Icons.search),
                    color: WidgetColor,
                    onPressed: () => {},
                  )); // here to add the onPressed-command to search something
                }),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text("Your Groups",
                        style: TextStyle(color: textColor))),
                Builder(builder: (BuildContext context) {
                  return (IconButton(
                      icon: Icon(Icons.settings),
                      color: WidgetColor,
                      onPressed: () =>
                          {})); //here to add the onPressed-command to navigate to settings
                })
              ],
            ),
          ),
        ),
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
                        AppHandler("chatWidget", context, ["offizieller Chat"])
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
      ),
    );
  }

  Widget eventWidget(Event ev) {
    return Container(
      child: Column(
        children: [
          Text(ev.name,
              style: TextStyle(
                color: textColor,
                fontSize: HeadfontOfWidget,
              )),
          Text(ev.description,
              style: TextStyle(
                  color: backgroundColor, fontSize: SecondfontOfWidget)),
        ],
      ),
      padding: constPadding,
      alignment: Alignment.center,
      margin: constMargin,
      width: double.infinity,
    );
  }

  List<Event> Events = <Event>[];

  void loadEvents() {
    //TODO: make Login used by me

    login("Jakob", "Test1234").then((value) => {
          if (!value)
            {print("Error logging in as Jakob")}
          else
            {
              current_group?.get_events_active().then((events) {
                setState(() {
                  Events = events;
                });
              })
            }
        });
  }

  Widget chat(name) {
    return Container(
      child: Text(
        name,
        style: TextStyle(
          color: textColor,
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
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
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
                            WidgetColor,
                          ),
                        ),
                        child: eventWidget(Events[index]),
                        onPressed: () => {},
                        // first parameter is the keyword to the next widget, other is the context-builder for the nativigator-class, just copy and past it
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: Events.length,
          ),
        ));
  }
}
