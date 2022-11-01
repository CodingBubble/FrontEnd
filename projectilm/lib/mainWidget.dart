import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: Scaffold(
      appBar: AppBar(
        /*
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
            child: TextFormField(
              keyboardType:
                  TextInputType.text, // Use email input type for emails.
              decoration: const InputDecoration(
                hintText: 'Suche',
              ),
            ),
          ),
        ), //title aof appbar

        backgroundColor: const Color(0xFF268223), //background color of appbar
      ),
      */
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
                      onPressed: () => {
                            /*Navigator.push(context, new MaterialPageRoute(builder: (context) => ))*/
                          }),
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

  List<String> groupNames = <String>[

  ];
  List<String> groupDescription = <String>[

  ];

  void loadGroups()
  {
    login("Jakob", "Test1234").then((value) => {
      if (!value) {
        print("Error logging in as Jakob")
      }
      else {
        me_get_groups().then((groups)  {
          setState(() {
            groups.forEach((group) { 
              print("Group Found: ${group.name}");
              groupNames.add(group.name);
              groupDescription.add(group.description);
            }
           );
          });
        })
      }
    });
  }

}

