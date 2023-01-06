import 'package:flutter/material.dart';
import 'package:projectilm/create_event.dart';
import 'package:projectilm/create_group.dart';
import 'package:projectilm/groupChatWidget.dart';
import 'package:projectilm/eventWidget.dart';
import 'package:projectilm/register.dart';
import 'package:projectilm/settingsWidget.dart';
import 'mainWidget.dart';
import 'global.dart';
import 'login.dart';
import 'groupWidget.dart';
import 'groupSettingsWidget.dart';
import 'groupMembersWidget.dart';

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
    else if (widgetPath == "groupWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const GroupWidget(title: "Grouping"),
        ),
      );
    }
    else if (widgetPath == "logInWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const logInWidget(title: "Grouping"),
        ),
      );
    }
    else if (widgetPath == "register") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const RegisterWidget()
        ),
      );
    }
    else if (widgetPath == "settingsWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SettingsWidget(title: "Grouping"),
        ),
      );
    }
    else if (widgetPath == "groupMembersWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const groupMembersWidget(title: "Grouping"),
        ),
      );
    }
    else if (widgetPath == "chatWidget") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => chatWidget(
                title: info[0],
                titleOfChat: info[1],
              )));
    }
    else if (widgetPath == "groupSettingsWidget") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const groupSettingsWidget(title: "Grouping"),
        ),
      );
    }
    else if (widgetPath == "eventWidget") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventWidget(state: info[0])));
    } 
    else if (widgetPath == "create_event") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Event_Create())
      );
    } 
    else if (widgetPath == "create_group") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Group_Create())
      );
    } 
    else {
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