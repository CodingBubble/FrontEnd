import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/groups-Widget.dart';
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
        appBar: AppBar(
          title: Container(
            child: Row(
              children: [
                Builder(builder: (BuildContext context) {
                  return (IconButton(
                    icon: Icon(Icons.search),
                    color: WidgetColor,
                    onPressed: () => {},
                  )); // here to add the onPressed-command to search something
                }),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Suche",
                    ),
                  ),
                ),
                Builder(builder: (BuildContext context) {
                  return (IconButton(
                      icon: Icon(Icons.settings),
                      color: WidgetColor,
                      onPressed: () =>
                          {})); //here to add the onPressed-command to navigate to settings
                }),
                Builder(builder: (BuildContext context) {
                  return (IconButton(
                      icon: Icon(Icons.edit),
                      color: WidgetColor,
                      onPressed: () =>
                          {})); //here to add the onPressed-command to navigate to settings
                })
              ],
            ),
          ),
          backgroundColor: backgroundColor,
        ),
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
                      child: groups(
                        groupNames[index],
                        groupDescription[index],
                      ),
                      onPressed: () => {AppHandler("groupWidget", context)},
                      // first parameter is the keyword to the next widget, other is the context-builder for the nativigator-class, just copy and past it
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: groupNames.length,
        )),
      ),
    );
  }

  // buttons and others

  Widget groups(name, description) {
    return Container(
      child: Column(
        children: [
          Text(name,
              style: TextStyle(
                color: textColor,
                fontSize: HeadfontOfWidget,
              )),
          Text(description,
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

  List<String> groupNames = <String>["Wandertag", "Afterparty"];
  List<String> groupDescription = <String>[
    "im Unstrut-Hainich",
    "reichlich Alk da"
  ];

  void loadGroups() {

    //TODO: make Login used by me
    login("Jakob", "Test1234").then((value) => {
          if (!value)
            {print("Error logging in as Jakob")}
          else
            {
              me_get_groups().then((groups) {
                setState(() {
                  groups.forEach((group) {
                    print("Group Found: ${group.name}");
                    groupNames.add(group.name);
                    groupDescription.add(group.description);
                  });
                });
              })
            }
        });
  }
}
