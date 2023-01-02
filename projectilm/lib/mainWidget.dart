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
    setState(() { });
    loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_user_app_bar(context),
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
                      width: MediaQuery.of(context).size.width * 0.9, // the distance to the margin of display
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
              style: TextStyle(
                color: primaryTextColor,
                fontSize: HeadfontOfWidget,
              )),
          Text(g.description,
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

  List<Group> groups_glob = <Group>[];

  void loadGroups() {
    me_get_groups().then((groups) {
      setState(() {
        groups_glob = groups;
      });
    });
  }
}
