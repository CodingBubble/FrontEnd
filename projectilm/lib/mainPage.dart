import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key, required this.title});

  final String title;

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return const IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
              // onPressed: () {
              //   Scaffold.of(context).openDrawer();
              // },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Form(
          key: this._formKey,
          child: TextFormField(
            keyboardType:
                TextInputType.text, // Use email input type for emails.
            decoration: const InputDecoration(hintText: 'Suche'),
          ),
        ), //title aof appbar
        backgroundColor: const Color(0xFF268223), //background color of appbar
      ),
    );
  }
}
