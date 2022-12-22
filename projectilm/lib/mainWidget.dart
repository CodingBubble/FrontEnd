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

class _mainWidgetState extends State<mainWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: get_user_app_bar(context),
        body: Scrollbar(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return Material(
              child: Column(
                children: [
                  new Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // the distance to the margin of display
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          WidgetColor,
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
                ],
              ),
            );
          },
          itemCount: groups_glob.length,
        )),
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
              style: TextStyle(
                color: primaryTextColor,
                fontSize: HeadfontOfWidget,
              )),
          Text(g.description,
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

  List<Group> groups_glob = <Group>[];

  void loadGroups() {
    me_get_groups().then((groups) {
      setState(() {
        groups_glob = groups;
      });
    });
  }
}
