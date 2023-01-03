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
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                child: TextFormField(
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () => evt_register(context),
                  child: Text('Einloggen'),
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () => AppHandler("register", context, []),
                  child: Text('Ich habe bereits einen Account'),
                )
              )

              
          ],
        )
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
