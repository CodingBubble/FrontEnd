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
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            widgetColor,
                          ),
                        ),
                        child: groups(groups_glob[index], pinned[index]),
                        onPressed: () {
                          current_group = groups_glob[index];
                          AppHandler("groupWidget", context, []);
                        },
                        // first parameter is the keyword to the next widget, other is the context-builder for the nativigator-class, just copy and past it
                      ),
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
            AppHandler("create_group", context, []);
          },
          backgroundColor: positiveColor,
          child: const Icon(Icons.add_circle),
        ),
      ),
    );
  }

  List<Event> Groups = <Event>[];

  // buttons and others

  Widget groups(Group g, bool b) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Wofür ist das Icon??

          // Icon(
          //   Icons.group,
          //   color: backgroundColor,
          //   size: MediaQuery.of(context).size.width * 0.1,
          // ),
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
