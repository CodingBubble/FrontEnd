import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/group/groupWidget.dart';
import 'package:projectilm/app_bars/user_app_bar.dart';
import 'package:projectilm/main.dart';
import 'package:projectilm/global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mainWidget extends StatefulWidget {
  const mainWidget({super.key, required this.title});

  final String title;

  @override
  State<mainWidget> createState() => _mainWidgetState();
}

List<Group> groups_glob = <Group>[];
List<Group> groups_actual = <Group>[];
List<bool> pinned = <bool>[];

class _mainWidgetState extends State<mainWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    // Screen if no groups yet
    if (groups_glob.isEmpty) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: backgroundColor,
          appBar: get_user_app_bar(context, searchFilter),
          body: Container(
            padding: constPadding,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Center(
                      child: Text(
                        "WILLKOMMEN IN",
                        style: TextStyle(
                          fontSize: SecondfontOfWidget,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: RichText(
                      text: TextSpan(
                        text: "G",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: GigafontOfWidget * 1.25,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "rouping",
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: HeadfontOfWidget * 1.4,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 25),
                  ),
                  Text(
                    "Noch keine Gruppe?",
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
                    "Klicke auf das Plus unten rechts um eine Gruppe hinzuzufügen.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: SecondfontOfWidget,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AppHandler("create_group", context, const []);
            },
            mini: true,
            backgroundColor: positiveColor,
            child: const Icon(Icons.add_circle),
          ),
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: backgroundColor,
          appBar: get_user_app_bar(context, searchFilter),
          body: Scrollbar(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return Material(
                color: backgroundColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(discanceBetweenWidgets),
                      child: Container(
                        color: backgroundColor,
                        width: MediaQuery.of(context).size.width *
                            0.9, // the distance to the margin of display
                        child: groups(groups_glob[index], pinned[index], index),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: groups_glob.length,
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AppHandler("create_group", context, const []);
            },
            mini: true,
            backgroundColor: positiveColor,
            child: const Icon(Icons.add_circle),
          ),
        ),
      );
    }
  }

  List<Event> Groups = <Event>[];

  // buttons and others

  // Widget checkGroups(Group g, bool b, index) {
  //   if (groups_glob.isEmpty) {
  //     {
  //       return Container(
  //         padding: constPadding,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.max,
  //           children: const [
  //             Text("Noch keine Gruppe?"),
  //             Text(
  //                 "Klicke auf das Plus unten rechts um eine Gruppe hinzuzufügen."),
  //           ],
  //         ),
  //       );
  //     }
  //   } else {
  //     return groups(g, b, index);
  //   }
  // }

  Widget groups(Group g, bool b, index) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          widgetColor,
        ),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      g.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: HeadfontOfWidget,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          g.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: descriptionfontOfWidget,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () async {
                            await toggleGroupPinned(g);
                            loadGroups();
                          },
                          icon: Icon(
                            b ? Icons.push_pin : Icons.push_pin_outlined,
                            color: b ? primaryTextColor : backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        current_group = groups_glob[index];
        AppHandler("groupWidget", context, const []);
      },
      // first parameter is the keyword to the next widget, other is the context-builder for the nativigator-class, just copy and past it
    );
  }

  void loadGroups() {
    me_get_groups().then((groups) async {
      pinned = [];
      for (var group in groups) {
        pinned.add(await isGroupPinned(group));
      }
      int index = 0;
      for (int i = 0; i < pinned.length; i++) {
        if (pinned[i]) {
          bool save = pinned[index];
          pinned[index] = pinned[i];
          pinned[i] = save;
          var save2 = groups[index];
          groups[index] = groups[i];
          groups[i] = save2;
          index++;
        }
      }

      setState(() {
        groups_glob = groups;
        groups_actual = groups;
      });
    });
  }

  Future<bool> isGroupPinned(Group g) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("Group_Pinned${g.id}") ?? false;
  }

  Future toggleGroupPinned(Group g) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("Group_Pinned${g.id}", !await isGroupPinned(g));
  }

  void searchFilter(String s) {
    groups_glob = [...groups_actual];
    groups_actual.forEach((element) {
      if (!element.name.toLowerCase().contains(s.toLowerCase()) &&
          !element.description.toLowerCase().contains(s.toLowerCase())) {
        groups_glob.remove(element);
      }
    });
    setState(() {});
  }
}
