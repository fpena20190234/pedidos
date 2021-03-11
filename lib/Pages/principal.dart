import 'Package:flutter/material.dart';
import 'package:cook/bd/sqlitedb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../Widgets/sidebar.dart';

import '../Widgets/circle.dart';
import '../Widgets/input.dart';

import 'package:cook/services/Service_general.dart';
import '../models/Menu.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  Future<bool> _onBackPressed() {
    print('Le diste atras.');
    false;
  }

  GlobalKey<ScaffoldState> _scaffoldKey;

  TextEditingController _emailController;
  TextEditingController _nombreController;
  TextEditingController _claveController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _nombreController = TextEditingController();
    _claveController = TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
  }

  _submit() {
    _formKey.currentState.validate();
  }

  _showSnackBar(context, message) {
    var showSnackBar = _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
          // appBar: AppBar(
          //   title: Text("DELTEC"),
          //   backgroundColor: Colors.blue,
          // ),

          drawer: MenuLateral(),
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('DELTEC'), // we show the progress in the title...
            backgroundColor: Colors.blue,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: size.width,
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: -size.width * 0.22,
                    top: -size.width * 0.36,
                    child: Circle(
                      radius: size.width * 0.45,
                      colors: [Colors.blue, Colors.blueAccent],
                    ),
                  ),
                  Positioned(
                    left: -size.width * 0.15,
                    top: -size.width * 0.34,
                    child: Circle(
                      radius: size.width * 0.35,
                      colors: [Colors.lightBlue, Colors.lightBlueAccent],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                        width: size.width,
                        height: size.height,
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Bienvenido',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text('Usuario 1'),
            accountEmail: Text('Email'),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //       image: NetworkImage(
            //           'http://18.223.233.247/prueba/upload/logo/No-logo.jpg'),
            //       fit: BoxFit.cover),
            // ),
          ),
          ListView(
            shrinkWrap: true,
            primary: false,
            children: [
              listItem(title: "See more", icon: Icons.dashboard_rounded),
              listItem(title: "Help & Support", icon: Icons.help_rounded),
              listItem(title: "Setting & Privacy", icon: Icons.settings),
              ListTile(
                leading: Icon(
                  Icons.open_in_new_rounded,
                  size: 30,
                ),
                title: Text(
                  "Share",
                  style: TextStyle(fontSize: 14),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget listItem({int index, String title, IconData icon}) {
  return Material(
    color: Colors.transparent,
    child: Theme(
      data: ThemeData(accentColor: Colors.black),
      child: ExpansionTile(
        leading: Icon(
          icon,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 17),
        ),
        children: <Widget>[for (int i = 0; i < 2; i++) cardWidget()],
      ),
    ),
  );
}

Widget cardWidget() {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0, bottom: 8),
    child: Container(
      // width: MediaQuery.of(context).size.width * 0.91,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 3), color: Colors.grey[300], blurRadius: 5),
            BoxShadow(
                offset: Offset(-1, -3), color: Colors.grey[300], blurRadius: 5)
          ]),
      child: Row(
        children: [
          Icon(
            Icons.image_rounded,
            size: 22,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Title of Card",
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    ),
  );
}
// class MenuLateral extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Drawer(
//       child: Column(
//         children: <Widget>[
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(20),
//             color: Theme.of(context).primaryColor,
//             child: Center(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     width: 150,
//                     height: 150,
//                     margin: EdgeInsets.only(
//                       top: 30,
//                     ),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                           image: (NetworkImage(
//                               "https://versalift.com/wp-content/uploads/2017/05/bucket_truck_versalift_aerial_lift_main_image_VST_36_Large.png")),
//                           fit: BoxFit.fill),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Text("DELTEC DOMINICANA",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500)),
//                   FutureBuilder(
//                     future: function(),
//                     builder:
//                         (BuildContext context, AsyncSnapshot<String> text) {
//                       return new Text(
//                         text.data,
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Ink(
//             color: Colors.white,
//             child: new ListTile(
//               leading: Icon(Icons.local_gas_station),
//               title: Text(
//                 "TANQUEO",
//                 style: TextStyle(color: Colors.blue),
//               ),
//               onTap: () {
//                 Navigator.pushNamed(context, 'consumos');
//               },
//             ),
//           ),
//           Ink(
//             color: Colors.white,
//             child: new ListTile(
//               leading: Icon(Icons.departure_board),
//               title: Text(
//                 "PREOPERACIONAL",
//                 style: TextStyle(color: Colors.blue),
//               ),
//               onTap: () {
//                 Navigator.pushNamed(context, 'preoperacional');
//               },
//             ),
//           ),
//           Ink(
//             color: Colors.white,
//             child: new ListTile(
//               leading: Icon(Icons.addchart_sharp),
//               title: Text(
//                 "IDP",
//                 style: TextStyle(color: Colors.blue),
//               ),
//               onTap: () {
//                 Navigator.pushNamed(context, 'Idps');
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

Future<String> function() async {
  MemoDbProvider memoDb = MemoDbProvider();
  Future<List> _futureOfList = memoDb.fetchLogin();
  List list = await _futureOfList;
  String usuario = list[0].usuario;
  print("Usuario principal $usuario");
  return usuario;
}
// Future<String> functionm() async {
//   //=========================LOS DATOS DEL MENU===============================
//   MemoDbProvider memoDb = MemoDbProvider();
//   Future<List> _futureOfListm = memoDb.fetchLogin();

//   List list = await _futureOfListm;
//   String menu = list[0].menu;
//   print("menu = " + menu);
//   Services_general.getMenu().then((contratos) {
//     // setState(() {
//     //   _menu = menu;
//     //   _selectedContrato = _menu[0].nombre_item;
//     // });
//   });
// }

Future<String> functionm() async {
  MemoDbProvider memoDb = MemoDbProvider();
  Future<List> _futureOfList = memoDb.fetchLogin();
  List list = await _futureOfList;
  String menu = list[0].nombre_item;
  print("menu  $menu");
  return menu;
}

void _moveToSignInScreen(BuildContext context) => null;
