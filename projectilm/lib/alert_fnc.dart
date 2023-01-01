import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title_text, String desc_text) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {Navigator.pop(context);}
    );

  AlertDialog alert = AlertDialog(
    title: Text(title_text),
    content: Text(desc_text),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}