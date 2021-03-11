// import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cook/Pages/login.dart';
import 'package:cook/services/ConnectivityChangeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import '';
// import 'package:network_connectivity/connectivityChangeNotifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

final String assetName = 'images/noWifi.svg';
final Widget svg = SvgPicture.asset(assetName, semanticsLabel: 'Acme Logo');

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          ConnectivityChangeNotifier changeNotifier =
              ConnectivityChangeNotifier();
          //Inital load is an async function, can use FutureBuilder to show loading
          //screen while this function running. This is not covered in this tutorial
          changeNotifier.initialLoad();
          return changeNotifier;
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Network Connectivity',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: SvgPicture.asset("images/noWifi.svg"),
          // SvgPicture.asset(
          //   'images/serverDown.svg',
          //   // 'https://www.svgrepo.com/show/2046/dog.svg',
          //   // placeholderBuilder: (context) => CircularProgressIndicator(),
          //   height: 80.0,
          // ),
          home: MyHomePage(title: 'Network Connectivity'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            brightness: Brightness.light),
        body: Center(
          child: Consumer<ConnectivityChangeNotifier>(builder:
              (BuildContext context,
                  ConnectivityChangeNotifier connectivityChangeNotifier,
                  Widget child) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: SvgPicture.asset(connectivityChangeNotifier.svgUrl,
                        fit: BoxFit.contain)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 100),
                    child: Text(
                      connectivityChangeNotifier.pageText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (connectivityChangeNotifier.connectivity !=
                    ConnectivityResult.wifi)
                  Flexible(
                    child: RaisedButton(
                      child: Text('Open Settings'),
                      // onPressed: () => AppSettings.openAppSettings(),
                    ),
                  )
              ],
            );
          }),
        ));
  }
}
// import 'package:cook/Pages/Inicio/default.dart';
// import 'package:cook/Pages/registrarse.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'Pages/login.dart';
// import 'Pages/registrarse.dart';
// import 'Pages/principal.dart';
// import 'Pages/play_quiz.dart';
// import 'Pages/Inicio/default.dart';
// import 'Widgets/sidebar_layout.dart';
// import '/pages/homepage.dart';
// import 'package:flutter_offline/flutter_offline.dart';

// void main() => runApp(MyApp());



// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: Scaffold(
//           // appBar: AppBar(
//           //   title: Text("Connection"),
//           // ),
//           body: Builder(
//         builder: (BuildContext context) {
//           return OfflineBuilder(
//             connectivityBuilder: (BuildContext context,
//                 ConnectivityResult connectivity, Widget child) {
//               final bool connected = connectivity != ConnectivityResult.none;
//               return Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   child,
//                   Positioned(
//                     top: 24,
//                     left: 0.0,
//                     right: 0.0,
//                     height: 32.0,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 30),
//                       color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
//                       child: connected
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   "EN LÍNEA",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ],
//                             )
//                           : Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   "DESCONECTADO",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 SizedBox(
//                                   width: 8.0,
//                                 ),
//                                 SizedBox(
//                                   width: 12.0,
//                                   height: 12.0,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2.0,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//             child: Center(
//               child: LoginPage(),
//             ),
//           );
//         },
//       )),
//       routes: {
//         'login': (context) => LoginPage(),
//         'register': (context) => RegisterPage(),
//         'principal': (context) => PrincipalPage(),
//         'default': (context) => DefaultPage(),
//       },
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: LoginPage(),
//       routes: {
//         'login': (context) => LoginPage(),
//         'register': (context) => RegisterPage(),
//         'principal': (context) => PrincipalPage(),
//         'default': (context) => DefaultPage(),
//       },
//     );
//   }
// }
