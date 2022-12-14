import 'package:flutter/material.dart';
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
    login(username_controller.text, password_controller.text).then((bool k) {
      if (!k) {
        print("Login failed!!!!");
        return;
      }
      print("Logged In");
      AppHandler("mainWidget", con);
    });
  }
}

class _logInWidget extends State<logInWidget> {
  @override
  Widget build(BuildContext context) {

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

  // buttons and others

  // Widget groups(name, description) {
  //   return Container(
  //     child: Text(name, style: TextStyle(color: fontColor)),
  //     // padding:
  //   );
  // }
}
