import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'alert_fnc.dart';
import 'global.dart';
import 'src/projectillm_bridgelib_base.dart';
import 'package:projectilm/controlWidget.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => register_state();
}

class load_register extends StatelessWidget {
  load_register({super.key});
  final TextEditingController username_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Center(
              child: Text(
                "WILLKOMMEN IN",
                style: TextStyle(
                  fontSize: SecondfontOfWidget,
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: RichText(
              text: TextSpan(
                text: "G",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: GigafontOfWidget * 1.25,
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "rouping",
                    style: TextStyle(
                        color: primaryTextColor,
                        fontSize: HeadfontOfWidget * 1.4,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              child: TextFormField(
                style: TextStyle(color: primaryTextColor),
                controller: username_controller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(color: primaryTextColor),
                  floatingLabelStyle: TextStyle(color: variationColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Form(
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: TextStyle(color: primaryTextColor),
                controller: password_controller,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: 'Passwort',
                  hintStyle: TextStyle(color: primaryTextColor),
                  floatingLabelStyle: TextStyle(color: variationColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: widgetColor),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextButton(
                onPressed: () => evt_register(context),
                child: Text(
                  'Erstelllen',
                  style: TextStyle(color: primaryTextColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: widgetColor),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextButton(
                onPressed: () => AppHandler("logInWidget", context, []),
                child: Text(
                  'Ich habe bereits einen Account',
                  style: TextStyle(color: primaryTextColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void evt_register(con) {
    register(username_controller.text, password_controller.text)
        .then((bool k) async {
      if (!k) {
        showAlertDialog(con, "Fehler", "Account konnte nicht erstellt werden");
        return;
      }
      print("Logged In");
      AppHandler("mainWidget", con, []);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", username_controller.text);
      await prefs.setString("password", password_controller.text);
    });
  }
}

class register_state extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: widgetColor,
        title: const Center(
          child: Text('Account erstellen'),
        ),
      ),
      body: load_register(),
    );
  }

  // buttons and others

  // Widget groups(name, description) {
  //   return Container(
  //     child: Text(name, style: TextStyle(color: fontColor)),
  //     // padding:
  //   );
  // }
}
