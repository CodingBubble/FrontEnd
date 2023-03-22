import 'package:flutter/material.dart';
import 'package:projectilm/global.dart';

showAlertDialog(BuildContext context, String title_text, String desc_text) {
  Widget okButton = Container(
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: variationColor),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: TextButton(
      child: Text(
        "OK",
        style: TextStyle(color: variationColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: widgetColor,
    title: Text(
      title_text,
      style: TextStyle(color: secondaryTextColor, fontSize: SecondfontOfWidget),
    ),
    content: Text(
      desc_text,
      style:
          TextStyle(color: primaryTextColor, fontSize: descriptionfontOfWidget),
    ),
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

Widget ret_if(bool statement, Widget w) {
  return statement ? w : Container();
}
