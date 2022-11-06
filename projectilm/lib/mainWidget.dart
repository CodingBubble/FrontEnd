import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import 'main.dart';
import 'global.dart';

class mainWidget extends StatefulWidget {
  const mainWidget({super.key, required this.title});

  final String title;

  @override
  State<mainWidget> createState() => _mainWidgetState();
}

class _mainWidgetState extends State<mainWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: () => {AppHandler("groupWidget")}),
                ),
              ],
            ),
          );
        },
        itemCount: groupNames.length,
      )),
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

  List<String> groupNames = <String>[
    "Sauf-Sport-Balance",
    "Bildung für Idioten",
    "Homo-Club",
    "Asoziales Kommunistisches Netzwerk",
    "Verein für effektive Gehirnspende",
  ];
  List<String> groupDescription = <String>[
    "Nur für Trinken",
    "Zielniveau ist Grundschule",
    "Schwul? Dann komm rein",
    "Niemand hat die Abisicht eine Mauer zu errichten",
    "Frau Merker ist Ehrenmitglied"
  ];
}
