import 'Package:flutter/material.dart';
// import 'package:cook/Pages/Consumos_add.dart';
import 'package:cook/models/Logina.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Widgets/circle.dart';
import '../Widgets/input.dart';

import '../services/Services_usuarios.dart';
// import '../models/Employee.dart';

import '../bd/sqlitedb.dart';
import '../models/Logina.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  MemoDbProvider memoDb = MemoDbProvider();
  Future<bool> _onBackPressed() {
    return Navigator.pushNamed(context, 'principal');
  }

  TextEditingController _emailController;
  TextEditingController _claveController;

  final logina = null;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = new TextEditingController();
    _claveController = new TextEditingController();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      if (_claveController.text.isNotEmpty ||
          _emailController.text.isNotEmpty) {
        String clv = _claveController.text;
        // print('clave enviada $clv1');

        // String clv = generateMd5(_claveController.text);
        // print('clave enviada $clv1');

        // var key = utf8.encode('AuthorizationKey');
        // var bytes = utf8.encode("Yanneri3103");

        // var hmacSha256 = new Hmac(sha224, key); // HMAC-SHA256
        // var digest = hmacSha256.convert(bytes);

        // // print("HMAC digest as bytes: ${digest.bytes}");
        // print("HMAC digest as hex string: $digest");

        Services_usuarios.loginEmployee(_emailController.text, clv)
            .then((result) {
          // if ('success' == result.trim()) {
          if ('success' == result.trim()) {
            final logina = Logina(
                usuario: _emailController.text,
                fechac: DateTime.now().toString(),
                supervisord: '-',
                supervisore: '-',
                id_empresa: '-',
                bodega: '-');
            memoDb.deleteMemo();
            memoDb.deleteLinieros();
            //memoDb.deleteVehiculos();

            memoDb.addItem(logina);

            //_login =  Login(_emailController.text, DateTime.now().toString());
            Navigator.pushNamed(context, 'default');
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ConsumosAdd(),
            //   ),
            // );
          } else {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Error",
              desc: "Clave o usuario incorrectos.",
              buttons: [
                DialogButton(
                  child: Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
          }
        });
      }
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
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
                                Container(
                                  width: 290,
                                  height: 90,
                                  margin:
                                      EdgeInsets.only(top: size.width * 0.3),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        // scale: 200,
                                        image: NetworkImage(
                                            "http://18.223.233.247/deltec/upload/logo/No-logo.png"),
                                        fit: BoxFit.cover),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 25,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Bienvenido a Deltec Dominicana',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.blue),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 350,
                                      minWidth: 350,
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          Input(
                                            textEditingController:
                                                _emailController,
                                            label: 'Usuario',
                                            validator: (String text) {
                                              if (text.isNotEmpty &&
                                                  text.length > 4) {
                                                return null;
                                              }
                                              return 'La clave debe contener por lo menos 6 caracteres';
                                            },
                                            // inputType:
                                            //     TextInputType.emailAddress,
                                            // validator: (String text) {
                                            //   if (text.contains('@') &&
                                            //       text.contains('.com')) {
                                            //     return null;
                                            //   }
                                            //   return 'Email no valido';
                                            // },
                                          ),
                                          SizedBox(height: 30),
                                          Input(
                                            textEditingController:
                                                _claveController,
                                            label: 'CLAVE',
                                            esOculto: true,
                                            validator: (String text) {
                                              if (text.isNotEmpty &&
                                                  text.length > 4) {
                                                return null;
                                              }
                                              return 'La clave debe contener por lo menos 6 caracteres';
                                            },
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(height: 50),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 350,
                                    minWidth: 350,
                                  ),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.symmetric(vertical: 17),
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4),
                                    onPressed: () => _submit(),
                                    child: Text(
                                      'Ingresar',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
                // Positioned(
                //   left: 15,
                //   top: 5,
                //   child: SafeArea(
                //     child: CupertinoButton(
                //       padding: EdgeInsets.all(10),
                //       borderRadius: BorderRadius.circular(30),
                //       color: Colors.black12,
                //       onPressed: ()=>Navigator.pop(context),
                //       child: Icon(
                //         Icons.arrow_back,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        )));
  }
}
