import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groupWidget.dart';
import 'package:projectilm/app_bars/user_app_bar.dart';
import 'main.dart';
import 'global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

class mainWidget extends StatefulWidget {
  const mainWidget({super.key, required this.title});

  final String title;

  @override
  State<mainWidget> createState() => _mainWidgetState();
}

List<Group> groups_glob = <Group>[];
List<Group> groups_actual = <Group>[];

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
                    padding: EdgeInsets.all(discanceBetweenWidgets),
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
                        child: groups(groups_glob[index]),
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

  Widget groups(Group g) {
    return Container(
      child: Column(
        children: [
          Text(g.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: HeadfontOfWidget,
              )),
          Padding(padding: EdgeInsets.all(15)),
          Text(g.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: secondaryTextColor, fontSize: SecondfontOfWidget)),
        ],
      ),
      padding: constPadding,
      alignment: Alignment.center,
      margin: constMargin,
      width: double.infinity,
    );
  }

  void loadGroups() {
    me_get_groups().then((groups) {
      setState(() {
        groups_glob = groups;
        groups_actual = groups;
      });
    });
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
