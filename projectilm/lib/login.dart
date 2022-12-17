import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global.dart';
import 'src/projectillm_bridgelib_base.dart';
import 'package:projectilm/controlWidget.dart';

class logInWidget extends StatefulWidget {
  const logInWidget({super.key, required this.title});
  final String title;

  @override
  State<logInWidget> createState() => _logInWidget();
}

class logInForms extends StatelessWidget {
  logInForms({super.key});
  final TextEditingController username_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Form(
            child: TextFormField(
              controller: username_controller,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(hintText: 'Name'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Form(
            child: TextFormField(
              controller: password_controller,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(hintText: 'Passwort'),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () => evt_login(context),
              child: Text('Einloggen'),
            )),
      ],
    );
  }

  void evt_login(con) {
    login(username_controller.text, password_controller.text).then((bool k) async {
      if (!k) {
        print("Login failed!!!!");
        return;
      }
      print("Logged In");
      AppHandler("mainWidget", con);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", username_controller.text);
      await prefs.setString("password", password_controller.text);
    });
  }
}

class _logInWidget extends State<logInWidget> {
  @override
  Widget build(BuildContext context) {
   login_from_storage();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WidgetColor,
        title: const Center(
          child: Text('Anmeldung'),
        ),
      ),
      body: logInForms(),
    );
  }

  Future login_from_storage() async {
    final prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username") ?? "";
    String password = await prefs.getString("password") ?? "";
    login(username, password).then((value) {
      if(!value){ return; }
      AppHandler("mainWidget", context);
    });
  }

  // buttons and others

  // Widget groups(name, description) {
  //   return Container(
  //     child: Text(name, style: TextStyle(color: fontColor)),
  //     // padding:
  //   );
  // }
}
