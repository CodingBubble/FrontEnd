import 'package:flutter/material.dart';
import 'package:projectilm/global.dart';

showAlertDialog(BuildContext context, String title_text, String desc_text) {
    Widget okButton = TextButton(
      child: Text("OK", style: TextStyle(color: secondaryTextColor),),
      onPressed: () {Navigator.pop(context);}
    );

  AlertDialog alert = AlertDialog(
    backgroundColor: widgetColor,
    title: Text(title_text, style: TextStyle(color: secondaryTextColor)),
    content: Text(desc_text, style: TextStyle(color: primaryTextColor)),
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


Widget ret_if (bool statement, Widget w)
{
  return statement ? w : Container();
}
