import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'mainWidget.dart';
import 'global.dart';
import 'login.dart';
import 'src/projectillm_bridgelib_base.dart';
import "group-Widget.dart";

class controlWidget extends StatelessWidget {
  const controlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //  Real User has to be called here not standard => make it dynamic later
    var realUser = new User(1, 'Jakob', is_me: true); // if it is false, the log-In page will load
    if (realUser.is_me) {
      return MaterialApp(
        title: 'Grouping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: WidgetColor,
        ),
        home: const mainWidget(title: 'Grouping'),
      );
    } else {
      return MaterialApp(
        title: 'Grouping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: WidgetColor,
        ),
        home: const logInWidget(title: 'Grouping'),
      );
    }
  }
}

class AppHandler extends controlWidget {
  var widgetPath;
  var Context;

  AppHandler(widgetPath, Context) {
    this.widgetPath = widgetPath;
    this.Context = Context;
    callingWidget(widgetPath, Context);
  }
  /*
  void textInConsole() {
    print("Does work");
  }
*/
  callingWidget(widgetPath, context) {
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
    } else {
      print("ERROR: False route paramaeter");
    }
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