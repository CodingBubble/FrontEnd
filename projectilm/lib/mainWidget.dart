import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        leading: Builder(
          builder: (BuildContext context) {
            return const IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: null,
              // onPressed: () {
              //   Scaffold.of(context).openDrawer();
              // },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        title: Container(
          child: Form(
            key: this._formKey,
            child: Container(
              child: TextFormField(
                keyboardType:
                    TextInputType.text, // Use email input type for emails.
                decoration: const InputDecoration(
                  hintText: 'Suche',
                ),
              ),
            ),
          ), //title aof appbar
          ElevatedButton(
            child: Icon(Icons.search),
            onPressed: () => {},
          ),
        ),

        backgroundColor: const Color(0xFF268223), //background color of appbar
      ),
      body: Scrollbar(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return Material(
            child: Column(
              children: [
                new Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
                ElevatedButton(
                    child: groups(groupNames[index], groupDescription[index]),
                    onPressed: () => {
                          /*Navigator.push(context, new MaterialPageRoute(builder: (context) => ))*/
                        })
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
              style: TextStyle(color: fontColor, fontSize: HeadfontOfWidget)),
          Text(description,
              style: TextStyle(
                  color: backgroundColor, fontSize: SecondfontOfWidget)),
        ],
      ),
      padding: constPadding,
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
