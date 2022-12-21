import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectilm/controlWidget.dart';
import 'package:projectilm/settingsWidget.dart';
import 'mainWidget.dart';
import 'global.dart';
import 'src/projectillm_bridgelib_base.dart';
import 'groupWidget.dart';

class chatWidget extends StatefulWidget {
  const chatWidget({
    super.key,
    this.title,
    this.titleOfChat,
  });
  final title;
  final titleOfChat;

  @override
  State<chatWidget> createState() => _stateChatWidget(this.titleOfChat);
}

class _stateChatWidget extends State<chatWidget> {
  _stateChatWidget(titleOfChat) {
    this.titleOfChat = titleOfChat;
  }
  var titleOfChat;
  var info;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
              title: Container(
            child: Row(
              children: [
                Builder(builder: (BuildContext context) {
                  return (IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: WidgetColor,
                    onPressed: () => {AppHandler("groupWidget", context, [])},
                  )); // here to add the onPressed-command to search something
                }),
                /*Text(
                  titleOfChat,
                  style:
                      TextStyle(color: WidgetColor, fontSize: HeadfontOfWidget),
                ),*/
                Builder(builder: (BuildContext context) {
                  return (IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => AppHandler("settingsWidget", context, []),
                  ));
                })
              ],
            ),
          )),
        ));
  }

  WidgetmessageDesign(content) {
    return Container(
      child: SizedBox(
        child: Text(content,
            style: TextStyle(color: textColor, fontSize: SecondfontOfWidget)),
      ),
      color: backgroundColor,
      padding: constPadding,
      margin: constMargin,
    );
  }
}
