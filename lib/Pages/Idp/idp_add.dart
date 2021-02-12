import 'dart:io';
import 'dart:typed_data';

import 'package:cook/Widgets/input.dart';
import 'package:cook/bd/sqlitedb.dart';
import 'package:cook/models/Ciudades.dart';
import 'package:cook/models/Proyectos.dart';
import 'package:cook/services/Service_general.dart';
import 'package:cook/services/Services_idp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:signature/signature.dart';


class IdpAdd extends StatefulWidget {
  IdpAdd({Key key, this.url}) : super(key: key);
  final String title = 'Crear Incidencia';
  final String url;
  @override
  IdpAddState createState() => IdpAddState();
}

class IdpAddState extends State<IdpAdd>{
  final SignatureController _controllerFirma = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black  ,
    exportBackgroundColor: Colors.transparent,
  );

  TextStyle titulos = TextStyle(fontSize: 12,color: Colors.blue, fontWeight: FontWeight.bold);
  MemoDbProvider memoDb = MemoDbProvider();

  String selectedRole = "Writer";

  final _formKey = GlobalKey<FormState>();

  String _titleProgress = "Crear IDP";
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<Ciudades> _ciudades;
  List<Proyectos> _proyectos;



  String _selectedCiudad;
  String _selectedProyectos;

  TextEditingController _incidenciaController = TextEditingController();
  TextEditingController _observacionController = TextEditingController();

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
        DateTime selectedDate1 = DateTime.now();
        String fecha = selectedDate1.toString();
        var data = fecha.split(" ");

        String seleccionada = picked.toString();
        var data1 = seleccionada.split(" ");

        DateTime moonLanding = DateTime.parse(data1[0] +" " +data[1]);  // 8:18pm

        selectedDate = moonLanding;
      });
  }


  @override
  void initState() {
    super.initState();
    _ciudades = [];
    _proyectos = [];

    _controllerFirma.addListener(() => print("Value changed"));
    _getCiudades();
    _getProyectos();

  }//Fin InitState


  _getCiudades() {
    //_showProgress('Loading Employees...');
    Services_general.getCiudades().then((ciudades) {
      setState(() {
        _ciudades = ciudades;
        _selectedCiudad = _ciudades[0].nombre_ciudad;

      });
    });
  }

  _getProyectos() async{
    Future<List> _futureOfList = memoDb.fetchLogin();
    List list = await _futureOfList ;
    String id_empresa = list[0].id_empresa;
    //String id_empresa = "7";

    //_showProgress('Loading Employees...');
    Services_general.getProyectos(id_empresa).then((proyectos) {
      setState(() {
        _proyectos = proyectos;
        _selectedProyectos = _proyectos[0].descripcion_proyecto;
      });
    });
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  _submit() async{
    bool Error = false;
    setState(() {
      //isEnabled = false;
    });


    if (_formKey.currentState.validate()) {
      //=========================LOS DATOS DEL FORMULARIO===============================
      String ciudad = _selectedCiudad;
      String proyecto = _selectedProyectos;

      String fecha  = selectedDate.toString();
      String incidencia   = _incidenciaController.text;
      String observacion  = _observacionController.text;
      var firma;
      if(_controllerFirma.isEmpty) {
        Error = true;
        Alert(
          context: context,
          onWillPopActive:true,
          type: AlertType.error,
          title: "Error",
          desc: "Debe firmar la incidencia.",
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
      else{
        firma = await _controllerFirma.toPngBytes();
      }
      if(!Error){
        Future<List> _futureOfLinieros = memoDb.fetchIdpLinieros();;
        List listLinieros = await _futureOfLinieros;

        //print("Data= "+ lista[0].full_nombre);
        listLinieros.forEach((item) {
           print("Data1= "+ item.liniero);
           print("Data2= "+ item.horas);
           print("Data3= "+ item.vehiculo);

        });

        //Vehiculos
        //Future<List> _futureOfVehiculos = memoDb.fetchIdpVehiculos();
        //List listVehiculos = await _futureOfVehiculos;

        //=========================LOS DATOS DEL USUARIO===============================
        Future<List> _futureOfList = memoDb.fetchLogin();;
        List list = await _futureOfList ;
        String usuario = list[0].usuario;
        String supervisord = list[0].supervisord;
        String supervisore = list[0].supervisore;
        String id_empresa = list[0].id_empresa;
        String bodega = list[0].bodega;



        Services_idp.addIdp(
            fecha,
            ciudad,
            proyecto,
            incidencia,
            observacion,
            bodega,
            supervisord,
            supervisore,
            id_empresa,
            listLinieros,
            firma,
            usuario).then((result) {
          String msj = result.trim();

          if ('Error al crear la Incidencia/idp' != msj &&
              'Error, Ya existe' != msj && msj.length > 0) {
            //isEnabled = true;
            // Refresh the List after adding each employee...
            Alert(
              context: context,
              onWillPopActive: true,
              type: AlertType.success,
              title: "GUARDAR",
              desc: msj,
              buttons: [
                DialogButton(
                  child: Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () =>
                  {
                    //_IrConsumo()
                  },
                  width: 120,
                )
              ],
            ).show();
            //Navigator.pushNamed(context, 'consumos');
          }
          else {
            setState(() {
              //isEnabled = true;
            });
            Alert(
              context: context,
              onWillPopActive: true,
              type: AlertType.error,
              title: "Error",
              desc: msj,
              buttons: [
                DialogButton(
                  child: Text(
                    "Cerrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () =>
                  {
                    //isEnabled = true
                  },
                  width: 120,
                )
              ],
            ).show();
          }
        });
      }
      //Linieros

    }

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
            width: size.width*0.95,
            height: size.height*0.95,
            child: SafeArea(
              child:Padding(
                padding: new EdgeInsets.all(10.0),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Column(
                      children: <Widget>[
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 400,
                              minWidth: 350,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 2,width: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('FECHA',textAlign: TextAlign.right,style: titulos),
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
                                  SizedBox(height: 2.0,width: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('CIUDAD:',textAlign: TextAlign.left,style: titulos),
                                    ],
                                  ),
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('Seleccione ciudad'),
                                    value: _selectedCiudad,
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
                                        _selectedCiudad = newValue;
                                      });
                                    },
                                    items: _ciudades.map((Ciudades map) {
                                      return new DropdownMenuItem<String>(
                                        value: map.nombre_ciudad,
                                        child: new Text(map.nombre_ciudad,
                                            style: new TextStyle(color: Colors.black)),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 2.0,width: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('PROYECTO:',textAlign: TextAlign.left,style: titulos),
                                    ],
                                  ),
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('Seleccione proyecto'),
                                    value:_selectedProyectos,
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
                                        _selectedProyectos = newValue;
                                      });
                                    },
                                    items: _proyectos.map((Proyectos map) {
                                      return new DropdownMenuItem<String>(
                                        value: map.descripcion_proyecto,
                                        child: new Text(map.descripcion_proyecto,
                                            style: new TextStyle(color: Colors.black)),
                                      );
                                    }).toList(),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('INCIDENCIA',textAlign: TextAlign.right,style: titulos),
                                    ],
                                  ),
                                  Input(
                                    //onEditingComplete: _calcularValores(),
                                    textEditingController: _incidenciaController,
                                    inputType: TextInputType.phone,
                                    //label: 'KILOMETRAJE',
                                    validator: (String text){
                                      if(text.isNotEmpty && RegExp(r'^[0-9.]+$').hasMatch(text)){
                                        return null;
                                      }
                                      return 'la incidencia debe contener solo valores numericos.';
                                    },
                                  ),
                                  SizedBox(height: 2.0,width: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('OBSERVACION',textAlign: TextAlign.right,style: titulos),
                                    ],
                                  ),
                                  TextFormField(
                                    controller: _observacionController,
                                    keyboardType: TextInputType.text,
                                    minLines: 3,//Normal textInputField will be displayed
                                    maxLines: 3,// when user presses enter it will adapt to it
                                    validator: (String text){
                                      if(text.isNotEmpty){
                                        return null;
                                      }
                                      return 'Debe digitar una observacion.';
                                    },
                                  ),
                                  SizedBox(height: 2.0,width: 10.0,),
                                  Row(
                                    children: <Widget>[
                                      Text('FIRMA',textAlign: TextAlign.right,style: titulos),
                                    ],
                                  ),
                                  SizedBox(height: 2.0,width: 10.0,),
                                  Signature(
                                    controller: _controllerFirma,
                                    height: 120,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(color: Colors.black),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.clear),
                                          color: Colors.blue,
                                          onPressed: () {
                                            setState(() => _controllerFirma.clear());
                                          },
                                        ),
                                      ],
                                    ),
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


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              enableFeedback:true,
              icon: Icon(Icons.save,color: Colors.white,),
              onPressed: ()=> _submit()
          ),
        ],
      ),
      body: Container(
        child: _dataBody(),
      ),
    );
  }
}
