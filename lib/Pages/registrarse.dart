import 'Package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../Widgets/circle.dart';
import '../Widgets/input.dart';


class RegisterPage extends StatefulWidget{
  @override
  _RegisterPageState createState()=> _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage>{
  TextEditingController _emailController;
  TextEditingController _nombreController;
  TextEditingController _claveController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _emailController = TextEditingController();
    _nombreController = TextEditingController();
    _claveController =TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _submit(){
    _formKey.currentState.validate();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: GestureDetector(
          onTap:(){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: -size.width*0.22,
                  top: -size.width*0.36,
                  child: Circle(
                    radius: size.width*0.45,
                    colors: [
                      Colors.pink,
                      Colors.pinkAccent
                    ],
                  ),
                ),
                Positioned(
                  left: -size.width*0.15,
                  top: -size.width*0.34,
                  child: Circle(
                    radius: size.width*0.35,
                    colors: [
                      Colors.orange,
                      Colors.deepOrange
                    ],
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
                                  'Hola.\nRegistrate es gratis por 15 dias.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),
                                ),
                                Container(
                                  width: 90,
                                  height: 90,
                                  margin: EdgeInsets.only(top: size.width*0.3),
                                  decoration: BoxDecoration(
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
                                SizedBox(height: 30,),

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
                                            textEditingController: _nombreController,
                                            label: 'SU NOMBRE',
                                            validator: (String text){
                                              if(text.isNotEmpty &&  text.length>10 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text)) {
                                                return null;
                                              }
                                              return 'El nombre debe contener por lo menos 10 caracteres';
                                            },
                                          ),
                                          SizedBox(height:10),
                                          Input(
                                            textEditingController: _emailController,
                                            label: 'EMAIL',
                                            inputType: TextInputType.emailAddress,
                                            validator: (String text){
                                              if(text.contains('@') &&  text.contains('.com')){
                                                return null;
                                              }
                                              return 'Email no valido';
                                            },
                                          ),
                                          SizedBox(height:10),
                                          Input(
                                            textEditingController: _claveController,
                                            label: 'CLAVE',
                                            esOculto: true,
                                            validator: (String text){
                                              if(text.isNotEmpty && text.length>5){
                                                return null;
                                              }
                                              return 'La clave debe contener por lo menos 6 caracteres';
                                            },

                                          ),
                                        ],
                                      ),
                                    )
                                ),
                                SizedBox(height: 20),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 350,
                                    minWidth: 350,
                                  ),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.symmetric(vertical: 17),
                                    color: Colors.pinkAccent,
                                    borderRadius: BorderRadius.circular(4),
                                    onPressed: ()=>_submit(),
                                    child: Text('Registrarse',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Ya tienes una cuenta.',
                                      style: TextStyle(fontSize: 16,color: Colors.black54),
                                    ),
                                    CupertinoButton(
                                      onPressed: (){},
                                      child: Text('Ingresar',
                                        style: TextStyle(fontSize: 16,color: Colors.pinkAccent),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: size.height*0.08),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 5,
                  child: SafeArea(
                    child: CupertinoButton(
                      padding: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black12,
                      onPressed: ()=>Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}