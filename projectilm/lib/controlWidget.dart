import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projectilm/chatWidget.dart';
import 'package:projectilm/settingsWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainWidget.dart';
import 'global.dart';
import 'login.dart';
import 'src/projectillm_bridgelib_base.dart';
import 'groupWidget.dart';

class controlWidget extends StatelessWidget {
  const controlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Grouping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: widgetColor,
        ),
        home: const logInWidget(title: "Grouping")
        //const mainWidget(title: "grouping"),
        );
  }
}

class AppHandler extends controlWidget {
  AppHandler(widgetPath, Context, info) {
    callingWidget(widgetPath, Context, info);
  }

  callingWidget(widgetPath, context, info) {
    //

    if (widgetPath == "mainWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const mainWidget(title: "Grouping"),
        ),
      );
    }
    if (widgetPath == "groupWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const GroupWidget(title: "Grouping"),
        ),
      );
    }
    if (widgetPath == "logInWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const logInWidget(title: "Grouping"),
        ),
      );
    }
    if (widgetPath == "settingsWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SettingsWidget(title: "Grouping"),
        ),
      );
    }
    if (widgetPath == "chatWidget") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => chatWidget(
                title: info[0],
                titleOfChat: info[1],
              )));
    } else {
      print("ERROR: False route paramaeter");
    }
  }

  void printSomething() {
    // only for testing
    print("Is working");
  }
}

class ControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold();
  }
}



/*
class appHandler extends StatelessWidget {
 
 
 
  static const String title = 'Grouping';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        // routeInformationProvider: _router.routeInformationProvider,
      );

  final GoRouter _router = GoRouter(
    // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    routes: <GoRoute>[
      GoRoute(
        routes: <GoRoute>[
          // GoRoute(
          //   path: 'passwordResetWidget',
          //   pageBuilder: (BuildContext context, GoRouterState state) =>  MaterialPage<void>(child: ,  key: ValueKey<String>(state.location +
          //                   DateTime.now().millisecondsSinceEpoch.toString(),),
          //       const passwordResetWidget(),
          // ),),
        ],
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const controlWidget(),
      ),
    ],
  );
}
// routes: {
//   '/': (context) => controlWidget(),
//   '/passwordResetWidget': (context) => passwordResetWidget(),
// },


//   GoRoute(
//     routes: <GoRoute>[
//       GoRoute(
//         path: 'passwordResetWidget',
//         builder: (BuildContext context, GoRouterState state) {
//           return const passwordResetWidget();
//         },
//       ),
//     ],
//     path: '/',
//     builder: (BuildContext context, GoRouterState state) {
//       return const controlWidget();
//     },
//   ),
// ],
*/