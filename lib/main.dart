import 'package:cook/Pages/Consumos_add.dart';
import 'package:cook/Pages/Idp/idp_add.dart';
import 'package:cook/Pages/Inicio/default.dart';
import 'package:cook/Pages/idp.dart';
import 'package:cook/Pages/preoperacional.dart';
import 'package:cook/Pages/registrarse.dart';
import 'package:cook/models/Preoperacional.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/Preoperacional_add.dart';
import 'Pages/consumos.dart';
import 'Pages/login.dart';
import 'Pages/registrarse.dart';
import 'Pages/principal.dart';
import 'Pages/preoperacional.dart';
import 'Pages/idp.dart';
import 'Pages/Idp/idp_add.dart';
import 'Pages/play_quiz.dart';
import 'Pages/Inicio/default.dart';

import 'Widgets/sidebar_layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: {
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage(),
        'principal': (context) => PrincipalPage(),
        'default': (context) => DefaultPage(),
        'consumos': (context) => DataTableDemo(),
        'consumosadd': (context) => ConsumosAdd(),
        'preoperacional': (context) => Preoperacionales(),
        'PreoperacionalAdd': (context) => PreoperacionalAdd(),
        'Idps': (context) => Idps(),
        'IdpsAdd': (context) => IdpAdd(),
      },
    );
  }
}
