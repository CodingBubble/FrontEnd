import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/alert_fnc.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/projectillm_bridgelib.dart';
import 'app_bars/simple_app_bar.dart';
import 'global.dart';

class groupSettingsWidget extends StatefulWidget {
  const groupSettingsWidget({super.key, required this.title});

  final String title;

  @override
  State<groupSettingsWidget> createState() => _groupSettingsWidgetState();
}

String invitationCode = "";

class _groupSettingsWidgetState extends State<groupSettingsWidget> {
  set textEinstellungsCode(String textEinstellungsCode) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: get_simple_app_bar(context, "Einstellungen"),
        body: Scrollbar(
          child: ListView.builder(
            itemCount: get_setting_category(context, generateID).length,
            itemBuilder: (context, index) {
              var settingCathegories =
                  get_setting_category(context, generateID);
              return Material(
                color: backgroundColor,
                child: Column(
                  children: [
                    SizedBox(
                      child: settingCathegories[index],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void generateID() {
    current_group!.admin_create_key().then((key) {
      invitationCode = key as String;
      setState(() {});
    });
  }
}

List<Widget> get_setting_category(context, generateID) {
  return <Widget>[
    ret_if(current_group!.admin_id == me!.id, themeSettings(generateID)),
    ret_if(current_group!.admin_id == me!.id, configSettings(context)),
    ret_if(current_group!.admin_id != me!.id, leave_settings(context)),
    // securitySettings()
  ];
}

void get_values(
    TextEditingController t_controller, TextEditingController d_controller) {
  t_controller.text = current_group!.name;
  d_controller.text = current_group!.description;
}

void update_values(
    TextEditingController t_controller, TextEditingController d_controller) {
  current_group!
      .admin_update(t_controller.text, d_controller.text)
      .then((value) => {
            if (!value) {print("error while changing data")}
          });
}

Widget configSettings(BuildContext context) {
  final GlobalKey<FormState> _formTitlteKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formTextKey = GlobalKey<FormState>();

  final change_title_controller = TextEditingController();
  final change_desc_controller = TextEditingController();
  get_values(change_title_controller, change_desc_controller);

  return (Container(
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: widgetColor,
      ),
      child: Column(
        children: [
          //headline
          Text(
            "Konfiguration",
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: SecondfontOfWidget + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
          Form(
            key: _formTitlteKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Gruppenname",
                  style: TextStyle(
                      color: secondaryTextColor, fontSize: SecondfontOfWidget),
                ),
                TextFormField(
                  style: TextStyle(color: primaryTextColor),
                  controller: change_title_controller,
                  decoration: InputDecoration(
                    hintText: 'Gebe einen neuen Gruppennamen ein',
                    hintStyle: TextStyle(color: primaryTextColor),
                    floatingLabelStyle: TextStyle(color: variationColor),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gebe einen neunen Grupppennamem ein';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(2 * discanceBetweenWidgets)),
          Form(
            key: _formTextKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Gruppebeschreibung",
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: SecondfontOfWidget,
                  ),
                ),
                TextFormField(
                  style: TextStyle(color: primaryTextColor),
                  controller: change_desc_controller,
                  decoration: InputDecoration(
                    hintText: 'Gebe eine neue Gruppenbeschreibung ein',
                    hintStyle: TextStyle(color: primaryTextColor),
                    floatingLabelStyle: TextStyle(color: variationColor),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gebe einen neunen Grupppennamem ein';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      update_values(
                          change_title_controller, change_desc_controller);
                    },
                    child: const Text('Gruppeneinstellungen ändern'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      current_group!.admin_delete().then((value) {
                        if (!value) {
                          showAlertDialog(context, "Fehler",
                              "Gruppe konnte nicht gelöscht werden");
                          return;
                        }
                        AppHandler("mainWidget", context, []);
                      });
                    },
                    child: const Text('Gruppe Löschen'),
                  ),
                ),
              ],
            ),
          ),
        ],
      )));
}

Widget leave_settings(BuildContext context) {
  return Container(
      padding: constPadding,
      margin: constMargin,
      width: double.infinity,
      color: widgetColor,
      child: ElevatedButton(
        onPressed: () {
          current_group!.leave().then((value) {
            if (!value) {
              showAlertDialog(
                  context, "Fehler", "Gruppe konnte nicht verlassen werden");
              return;
            }
            AppHandler("mainWidget", context, []);
          });
        },
        child: const Text('Gruppe Verlassen'),
      ));
}

Widget themeSettings(Function generateID) {
  // print(invitationCode);
  return (Container(
    padding: constPadding,
    margin: constMargin,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: widgetColor,
    ),
    child: Column(
      children: [
        const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Einladungcode",
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: SecondfontOfWidget + 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
              Text(
                invitationCode,
                style: TextStyle(
                    color: primaryTextColor,
                    fontSize: SecondfontOfWidget * 0.75),
              ),
              const Padding(padding: EdgeInsets.all(discanceBetweenWidgets)),
              SizedBox(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Clipboard.setData(
                              ClipboardData(text: invitationCode));
                        },
                        child: const Text('Kopieren'),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(2 * discanceBetweenWidgets)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          generateID();
                        },
                        child: const Text('Generieren'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  ));
}
