import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cook/bd/sqlitedb.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/Consumos.dart';
import '../models/Conductores.dart';

import '../models/Estaciones.dart';
import '../models/Vehiculos.dart';
import '../services/Services_conductores.dart';
import '../services/Services_vehiculos.dart';
import '../services/Services_preoperacional.dart';

import 'dart:async';
import '../Widgets/input.dart';
import 'package:http/http.dart' as http;

import '../data/data.dart';//aqui esta el modelo de question
import '../models/question_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_stepper/cool_stepper.dart';



class PreoperacionalAdd extends StatefulWidget {
  PreoperacionalAdd({Key key, this.url}) : super(key: key);
  final String title = 'Crear Preoperacional';
  final String url;
  @override
  PreoperacionalAddState createState() => PreoperacionalAddState();
}

class PreoperacionalAddState extends State<PreoperacionalAdd> with SingleTickerProviderStateMixin{
  //====================================   STEP   ===============================================
  String selectedRole = "Writer";
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();


//Inicio el cuestionario
  List<QuestionModel> questions = new List<QuestionModel>();
  int index = 0;
  int points = 0;
  int pointsf = 0;
  int correct = 0;
  int incorrect = 0;
  AnimationController controller;
  Animation animation;
  double beginAnim = 0.0;
  double endAnim = 1.0;
  //Fin el cuestionario


  //VER CAMBIOS EN EL FORMULARIO
  bool isEnabled = true ;
  final _focusCantidad = FocusNode();
  final _focusValorg = FocusNode();
  final _focusValor = FocusNode();

  //TRAER LOS DATOS DEL USUARIO GUARDADOS
  MemoDbProvider memoDb = MemoDbProvider();

  //CREAR CAMPO DE FECHA

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  DateTime fecha_licencia = null;
  Future<void> _fecha_licencia(BuildContext context) async {
    fecha_licencia = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fecha_licencia,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != fecha_licencia)
      setState(() {
        fecha_licencia = picked;
      });
  }

  DateTime fecha_seguro = null;
  Future<void> _fecha_seguro(BuildContext context) async {
    fecha_seguro = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fecha_seguro,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != fecha_seguro)
      setState(() {
        fecha_seguro = picked;
      });
  }

  //ID DE CAMPOS

  TextEditingController _kmController;


  String _tieneLicencia = 'SI';
  String _tieneMatricula = 'SI';
  String _tieneSeguroV = 'SI';
  String _tieneSeguroP = 'SI';

  List <String> opc =['SI', 'NO'];
  //FORMULARIO

  final _formKey = GlobalKey<FormState>();

  //LISTAS GENERALES

  List<Conductores> _conductoress;
  List<Consumos> _consumoss;
  List<Estaciones> _estacioness;
  List<Vehiculos> _vehiculos;

  GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the First Name TextField we are going to create.
  //TextEditingController _firstNameController;
  // controller for the Last Name TextField we are going to create.
  //TextEditingController _emailController;
  String _selectedVehiculos;
  String _selectedConductores;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    //Inicio Carga cuestionario
    questions = getQuestions("2");

    //if(questions.length>0) {
    controller =
        AnimationController(
            duration: const Duration(seconds: 1), vsync: this);
    animation = Tween(begin: beginAnim, end: endAnim).animate(controller)
      ..addListener(() {
        setState(() {
          // Change here any Animation object value.
          //stopProgress();
        });
      });

    startProgress();

    animation.addStatusListener((AnimationStatus animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        if (index < questions.length - 1) {
          //index++;
          //resetProgress();
          //startProgress();
        } else {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => Result(
          //               score: points,
          //               totalQuestion: questions.length,
          //               correct: correct,
          //               incorrect: incorrect,
          //             )));
        }
      }
    });

    //Fin cuestionario


    enableButton(){
      setState(() {
        isEnabled = true;
      });

    }

    disableButton(){
      setState(() {
        isEnabled = false;
      });
    }



    _consumoss = [];
    _estacioness = [];
    _vehiculos = [];
    _conductoress = [];

    // _valorGasoil = '0';
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar

    _kmController = TextEditingController();


    // _cantidadController.text = '0';
    // _valorController.text = '0';

    _getVehiculos();
    _getConductores();

   // _cantidadController.addListener( _calcularValores());
  }

  //INICIO CUENTIONARIO
  startProgress() {
    controller.forward();
  }

  stopProgress() {
    controller.stop();
  }

  resetProgress() {
    controller.reset();
  }

  void nextQuestion() {
    if (index < questions.length - 1) {
      index++;
      //resetProgress();
      //startProgress();
    } else {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Result(
      //               score: points,
      //               totalQuestion: questions.length,
      //               correct: correct,
      //               incorrect: incorrect,
      //             )));
    }
  }

  //FIN CUESTIONARIO



  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   super.dispose();
  // }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }
   _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _getConductores() {
    //_showProgress('Loading Employees...');
    Services_conductores.getConductores().then((conductores) {
      setState(() {
        // print(json.encode(consumoss));
        _conductoress = conductores;
        _selectedConductores = _conductoress[0].nombre_conductor;

      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${_conductoress.length}");
    });
  }
  _getVehiculos() {
    //_showProgress('Loading Employees...');
    Services_vehiculos.getVehiculos().then((vehiculos) {
      setState(() {
        // print(json.encode(consumoss));
        _vehiculos = vehiculos;
        _selectedVehiculos = _vehiculos[0].alias;

      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${_estacioness.length}");
    });
  }


  _IrConsumo(){
    Navigator.pushNamed(context, 'preoperacional');
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
  _submit() async {
    //setState(() {
      //isEnabled = false;
    //});

    bool Error = false;

    //=========================LOS DATOS DEL PRIMER FORMULARIO===============================
    String conductor = _selectedConductores;
    String vehiculo = _selectedVehiculos;
    String fecha  = selectedDate.toString();
    String km = _kmController.text;

    // print("conductor " + conductor + ", vehiculo " + vehiculo + ", fecha "  + fecha + ", km " +km);
    //=========================LOS DATOS DEL SEGUNDO FORMULARIO===============================
    String tieneLicencia = _tieneLicencia;
    String tieneMatricula = _tieneMatricula;
    String tieneSeguroV = _tieneSeguroV;
    String tieneSeguroP = _tieneSeguroP;
    String sfecha_seguro  = fecha_seguro.toString();
    String sfecha_licencia  = fecha_licencia.toString();

    // print("tieneLicencia " + tieneLicencia + ", tieneMatricula " + tieneMatricula + ", tieneSeguroV "  + tieneSeguroV + ", tieneSeguroP " +tieneSeguroP);
    // print("sfecha_seguro " + sfecha_seguro + ", sfecha_licencia " + sfecha_licencia );


    // questions.forEach((item) {
    //   print(item.id+" - "+ item.);
    //   // _questionBank.add(Question(0, name: 'Any category'));
    // });

    //=========================LOS DATOS DEL USUARIO===============================
    Future<List> _futureOfList = memoDb.fetchLogin();;
    List list = await _futureOfList ;
    String usuario = list[0].usuario;


      _showProgress('Creando consumo...');
      Services_preoperacional.addPreoperacional(conductor, vehiculo,fecha,km,questions,tieneLicencia,tieneMatricula,tieneSeguroV,tieneSeguroP,sfecha_seguro,sfecha_licencia, usuario).then((result)
      {
        String msj = result.trim();

        if ('Error al crear un preoperacional' != msj &&  'Error, Ya tiene un preoperacional creado para la fecha seleccionada' != msj && msj.length>0 ) {
          //isEnabled = true;
          // Refresh the List after adding each employee...
          Alert(
            context: context,
            onWillPopActive:true,
            type: AlertType.success,
            title: "GUARDAR",
            desc: msj,
            buttons: [
              DialogButton(
                child: Text(
                  "Cerrar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => {
                  _IrConsumo()
                },
                width: 120,
              )
            ],
          ).show();
          //Navigator.pushNamed(context, 'consumos');
        }
        else
          {
            setState(() {
              isEnabled = true;
            });
            Alert(
              context: context,
              onWillPopActive:true,
              type: AlertType.error,
              title: "Error",
              desc: msj,
              buttons: [
                DialogButton(
                  child: Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => {
                  isEnabled = true
                },
                  width: 120,
                )
              ],
            ).show();
          }
      });

    }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    final size = MediaQuery.of(context).size;

    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            width: size.width*0.9,
            height: size.height*0.68,
            child: SafeArea(
              child:Padding(
                padding: new EdgeInsets.all(25.0),
                child:
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

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
                                SizedBox(height: 20.0,width: 10.0,),
                                Row(
                                  children: <Widget>[
                                    Text('CONDUCTOR:',textAlign: TextAlign.left,),
                                  ],
                                ),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Seleccione conductor'),
                                  value: _selectedConductores,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.deepPurple,fontSize: 14),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _selectedConductores = newValue;
                                    });
                                  },
                                  items: _conductoress.map((Conductores map) {
                                    return new DropdownMenuItem<String>(
                                      value: map.nombre_conductor,
                                      child: new Text(map.nombre_conductor,
                                          style: new TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('VEHICULO',textAlign: TextAlign.right),
                                  ],
                                ),

                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Seleccione el vehiculo'),
                                  value: _selectedVehiculos,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.deepPurple,fontSize: 14),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _selectedVehiculos = newValue;
                                      print("v preoperacional"+ newValue);
                                        Services_vehiculos.getVehiculosPreoperacional(newValue).then((preoperacional) {
                                          questions = getQuestions(preoperacional);
                                      });
                                      //questions = getQuestions("1");

                                    });
                                  },
                                  items: _vehiculos.map((Vehiculos map) {
                                    return new DropdownMenuItem<String>(
                                      value: map.alias,
                                      child: new Text(map.alias,
                                          style: new TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('FECHA',textAlign: TextAlign.right),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                                    ),
                                    Expanded(
                                      child:RaisedButton(
                                        onPressed: () => _selectDate(context),
                                        child: Icon(Icons.date_range),
                                      )
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('KILOMETRAJE',textAlign: TextAlign.right),
                                  ],
                                ),
                                Input(
                                  //onEditingComplete: _calcularValores(),
                                  textEditingController: _kmController,
                                  inputType: TextInputType.phone,
                                  //label: 'KILOMETRAJE',
                                  validator: (String text){
                                    if(text.isNotEmpty && RegExp(r'^[0-9.]+$').hasMatch(text)){
                                      return null;
                                    }
                                    return 'El Kilometraje debe contener valores numericos.';
                                  },
                                ),

                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              ),
              ),
            )
        ),
      ),
    );
  }

  SingleChildScrollView _dataBody1() {
    final size = MediaQuery.of(context).size;

    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            width: size.width*.9,
            height: size.height*.68,
            child: SafeArea(
              child: Padding(
                  padding: new EdgeInsets.all(0.0),
                  child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ConstrainedBox(
                          constraints: BoxConstraints(
                            //maxWidth: size.width,
                            //minWidth: 350,
                          ),
                          child:
                          Expanded(
                          child:Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: DataTable(
                                          columns: [
                                            DataColumn(label: Text('Documento')),
                                            DataColumn(label: Text('Numero')),
                                            DataColumn(label: Text('Fecha Venc')),
                                          ],
                                          rows: [
                                            DataRow(cells: [
                                              DataCell(Text('Licencia')),
                                              DataCell(
                                                  DropdownButton<String>(
                                                    value: _tieneLicencia,
                                                    icon: Icon(Icons.arrow_downward),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(color: Colors.deepPurple),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.deepPurpleAccent,
                                                    ),
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        _tieneLicencia = newValue;
                                                      });
                                                    },
                                                    items: opc
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  )
                                              ),
                                              DataCell(
                                                Text((fecha_licencia!=null)?"${fecha_licencia.toLocal()}".split(' ')[0]:'Seleccione'),
                                                onTap: () => _fecha_licencia(context),
                                              ),
                                            ]),
                                            DataRow(cells: [
                                              DataCell(Text('Matricula')),
                                              DataCell(
                                                  DropdownButton<String>(
                                                    value: _tieneMatricula,
                                                    icon: Icon(Icons.arrow_downward),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(color: Colors.deepPurple),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.deepPurpleAccent,
                                                    ),
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        _tieneMatricula = newValue;
                                                      });
                                                    },
                                                    items: opc
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  )
                                              ),
                                              DataCell(
                                                Text('NA',textAlign: TextAlign.center,),
                                              ),
                                            ]),
                                            DataRow(cells: [
                                              DataCell(Text('Seguro Vehiculo')),
                                              DataCell(
                                                  DropdownButton<String>(
                                                    value: _tieneSeguroV,
                                                    icon: Icon(Icons.arrow_downward),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(color: Colors.deepPurple),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.deepPurpleAccent,
                                                    ),
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        _tieneSeguroV = newValue;
                                                      });
                                                    },
                                                    items: opc
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  )
                                              ),
                                              DataCell(
                                                Text((fecha_seguro!=null)?"${fecha_seguro.toLocal()}".split(' ')[0]:'Seleccione'),
                                                onTap: () => _fecha_seguro(context),
                                              ),
                                            ]),
                                            DataRow(cells: [
                                              DataCell(Text('Seguro Conductor')),
                                              DataCell(
                                                  DropdownButton<String>(
                                                    value: _tieneSeguroP,
                                                    icon: Icon(Icons.arrow_downward),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(color: Colors.deepPurple),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.deepPurpleAccent,
                                                    ),
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        _tieneSeguroP = newValue;
                                                      });
                                                    },
                                                    items: opc
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  )
                                              ),
                                              DataCell(
                                                Text('NA',textAlign: TextAlign.center,),
                                              ),
                                            ]),
                                          ],
                                        ),
                                      )
                                    ]),

                              ],
                            ),
                          )
                        )
                      ),
                    ],
                  ),
                ],
              )
              ),
            )
        ),
      ),
    );
  }

  SingleChildScrollView _dataBody2(){
    final size = MediaQuery.of(context).size;

    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            width: size.width*.90,
            height: size.height*0.68,
            child: SafeArea(
              child: Padding(
                  padding: new EdgeInsets.all(5.0),
                  child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              questions.length>0?"${index + 1}/${questions.length}":'X',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Preguntas",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                        Spacer(flex: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "C=$points/",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "NC=$pointsf",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Text(
                            //   "Puntos",
                            //   style: TextStyle(
                            //       fontSize: 17, fontWeight: FontWeight.w300),
                            // )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Tema',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,),
                  ),
                  Text(
                    questions.length>0 ?  questions[index].getQuestion1() + ".":'',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    questions.length>0?questions[index].getQuestion() + "?":'',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Spacer(flex: 1),
                  Container(
                      child: LinearProgressIndicator(
                        value: animation.value,
                      )),
                  CachedNetworkImage(imageUrl: questions.length>0?questions[index].getImageUrl():'',width: size.width*0.70,height: size.height*0.30,),
                  Spacer(flex: 2),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if(index+1< questions.length || (points+pointsf)< questions.length) {
                                  if (questions[index].getAnswer() == "True") {
                                    setState(() {
                                      points = points + 1;
                                      questions[index].setAnswer('True');
                                      nextQuestion();
                                      correct++;
                                    });
                                  } else {
                                    setState(() {
                                      pointsf = pointsf + 1;
                                      questions[index].setAnswer('True');
                                      nextQuestion();
                                      incorrect++;
                                    });
                                  }
                                }

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  "Cumple",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if(index+1< questions.length || (points+pointsf)< questions.length) {
                                  if (questions[index].getAnswer() == "False") {
                                    setState(() {
                                      points = points + 1;
                                      questions[index].setAnswer('False');
                                      nextQuestion();
                                      correct++;
                                    });
                                  } else {
                                    setState(() {
                                      pointsf = pointsf + 1;
                                      questions[index].setAnswer('False');
                                      nextQuestion();
                                      incorrect++;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  "No Cumple",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              )
            ),
            )
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  // UI
  //@override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: DefaultTabController(
  //       length: 3,
  //       child: Scaffold(
  //         key: _scaffoldKey,
  //         appBar: AppBar(
  //           title: Text(_titleProgress),
  //           actions: <Widget>[
  //             IconButton(
  //                 enableFeedback:true,
  //                 icon: Icon(Icons.save),
  //                 onPressed: isEnabled ? ()=> _submit() : null
  //             ),
  //           ],
  //           bottom: TabBar(
  //             tabs: [
  //               Tab(icon: Icon(Icons.account_box)),
  //               Tab(icon: Icon(Icons.blur_linear)),
  //               Tab(icon: Icon(Icons.local_car_wash)),
  //             ],
  //           ),
  //         ),
  //         body: TabBarView(
  //           children: [
  //             _dataBody(),
  //             _dataBody1(),
  //             _dataBody2(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final List<CoolStep> steps = [
      CoolStep(
        title: "INSPECCION PRE-OPERACIONAL VEHICULOS",
        subtitle: "Datos Basicos",
        content: _dataBody(),
        validation: () {
          if (!_formKey.currentState.validate()) {
            return "Fill form correctly";
          }
          return null;
        },
      ),
      CoolStep(
        title: "REVISIÓN DE DOCUMENTOS",
        subtitle: "Seleccione si tiene o no el documento y la fecha de vencimiento",
        content: _dataBody1(),
        validation: () {
          bool Error =false;
          if(fecha_licencia==null)
          {
            Alert(
              context: context,
              onWillPopActive:true,
              type: AlertType.error,
              title: "Error",
              desc: "Seleccione la fecha de la licencia.",
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
            Error = true;
          }
          else if(fecha_seguro==null)
          {
            Alert(
              context: context,
              onWillPopActive:true,
              type: AlertType.error,
              title: "Error",
              desc: "Seleccione la fecha del seguro del vehiculo.",
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
            Error = true;
          }


          if(!Error)
            return null;
          else
            return "-";
        },
      ),
      CoolStep(
        title: "REVISION DEL VEHICULO",
        subtitle: "Califique Cumple o No Cumple",
        content: _dataBody2(),
        validation: () {
          if(index+1< questions.length || (points+pointsf)< questions.length)
          {
            Alert(
              context: context,
              onWillPopActive:true,
              type: AlertType.error,
              title: "Error",
              desc: "Debe contestar todas las preguntas para continuar.",
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
            return '-';

          }
          else
            return null;
        },
      ),
      CoolStep(
        title: "SU INSPECCION HA FINALIZADO.",
        subtitle: "Esta seguro que desea guardar esta inspección?",
        content: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child:CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 17),
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
                onPressed: ()=>_submit(),
                child: Text('Guardar',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              )
            ],
          ),
        ),
        validation: () {
          return null;
        },
      ),
    ];

    final stepper = CoolStepper(
      onCompleted: () {
        print("Pasos completados!");
      },
      steps: steps,
      config: CoolStepperConfig(
        backText: "Anterior",
        nextText: "Siguiente",
        ofText: "de",
        stepText: "Paso",
        finalText: "Fin"
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: stepper,
      ),
    );
  }

  Widget _buildTextField({
    String labelText,
    FormFieldValidator<String> validator,
    TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }

  Widget _buildSelector({
    BuildContext context,
    String name,
  }) {
    bool isActive = name == selectedRole;

    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : null,
          border: Border.all(
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: RadioListTile(
          value: name,
          activeColor: Colors.white,
          groupValue: selectedRole,
          onChanged: (String v) {
            setState(() {
              selectedRole = v;
            });
          },
          title: Text(
            name,
            style: TextStyle(
              color: isActive ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}