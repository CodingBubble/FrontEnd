import 'package:flutter/material.dart';
import 'global.dart';

class logInWidget extends StatefulWidget {
  const logInWidget({super.key, required this.title});

  final String title;

  @override
  State<logInWidget> createState() => _logInWidget();
}

class logInForms extends StatelessWidget {
  const logInForms({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Form(
            child: TextFormField(
              keyboardType:
                  TextInputType.name, // Use email input type for emails.
              decoration: InputDecoration(hintText: 'Name'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Form(
            child: TextFormField(
              keyboardType: TextInputType
                  .visiblePassword, // Use email input type for emails.
              decoration: InputDecoration(hintText: 'Passwort'),
            ),
          ),
        ),
      ],
    );
  }
}

class _logInWidget extends State<logInWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Anmeldung'),
        ),
      ),
      body: const logInForms(),
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
