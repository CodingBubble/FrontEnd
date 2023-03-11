import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectilm/controlWidget.dart';
import '../main.dart';
import '../global.dart';
import 'package:projectilm/projectillm_bridgelib.dart';

AppBar get_user_app_bar(BuildContext context, Function onSearch) {
  return AppBar(
    backgroundColor: widgetColor,
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: IconButton(
              icon: Icon(Icons.euro, color: secondaryTextColor),
              color: backgroundColor,
              onPressed: () {
                current_transaction_group = null;
                AppHandler("splid_info_me", context, []);
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 2),
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextFormField(
                style: TextStyle(color: secondaryTextColor),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Suche",
                  hintStyle: TextStyle(color: primaryTextColor),
                  floatingLabelStyle: TextStyle(color: variationColor),
                ),
                onChanged: (value) => onSearch(value),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: IconButton(
                icon: Icon(Icons.manage_accounts, color: secondaryTextColor),
                color: backgroundColor,
                onPressed: () => {AppHandler("settingsWidget", context, [])},
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
