import 'package:flutter/material.dart';
import 'global.dart';

class Groups extends StatefulWidget {
  @override
  State<Groups> createState() => _StateGroups();
}

class _StateGroups extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
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
                  width: MediaQuery.of(context).size.width * 0.62,
                  child:
                      Text("Your Groups", style: TextStyle(color: textColor))),
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
          // the searching-button and the chat function
          Row(
            children: [
              Builder(builder: (BuildContext context) {
                return (IconButton(
                  icon: Icon(Icons.chat),
                  color: WidgetColor,
                  onPressed: () => {},
                )); // here to add the onPressed-command to search something
              }),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.62,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Suche",
                  ),
                ),
              ),
            ],

            // The scrollbar within all groups
          ),
          Scrollbar(
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
                          child: eventWidget(
                            eventNames[index],
                            eventDescriptions[index],
                          ),
                          onPressed: () => {
                                /*Navigator.push(context, new MaterialPageRoute(builder: (context) => ))*/
                              }),
                    ),
                  ],
                ),
              );
            },
            itemCount: eventNames.length,
          )),
        ],
      ),
    ));
  }

  Widget eventWidget(name, description) {
    return (Container(
      child: Column(
        children: [
          Text(name,
              style: TextStyle(color: textColor, fontSize: HeadfontOfWidget)),
          Text(description,
              style: TextStyle(color: textColor, fontSize: SecondfontOfWidget))
        ],
      ),
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
    ));
  }

  var eventNames = [
    "Fernsehabend bei Jakob",
    "Kirmes in Helmsdorf",
    "Coding für Ilmenau",
    "Wandern im Eichsfeld",
    "18. Geburtstag Sophia",
    "Tag der offenen Tür FH Jena"
  ];
  var eventDescriptions = [
    "Fluch der Karibik mit Snacks",
    "Kirmes eben",
    "das FrontEnd muss fertig werden",
    "Gelegenheit, neue Projekte zu erfinden",
    "legendärer Abend",
    "Wie viel kann Jena uns bieten?"
  ];
}
