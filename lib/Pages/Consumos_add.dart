import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cook/bd/sqlitedb.dart';
import 'package:cook/models/Logina.dart';
import 'package:cook/services/Services_usuarios.dart';
import 'package:cook/services/Services_valor_combustibles.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/Consumos.dart';
import '../models/Estaciones.dart';
import '../models/Vehiculos.dart';
import '../models/Logina.dart';
import '../services/Services_tanqueos.dart';
import '../services/Services_estaciones.dart';
import '../services/Services_vehiculos.dart';
import 'dart:async';
import '../Widgets/circle.dart';
import '../Widgets/input.dart';
import 'package:http/http.dart' as http;

class ConsumosAdd extends StatefulWidget {
  ConsumosAdd({Key key, this.url}) : super(key: key);
  final String title = 'Crear Consumo';
  final String url;
  @override
  ConsumosAddState createState() => ConsumosAddState();
}

class ConsumosAddState extends State<ConsumosAdd> {

  bool isEnabled = true ;

  final _focusCantidad = FocusNode();
  final _focusValorg = FocusNode();
  final _focusValor = FocusNode();

  //IMAGEN
  MemoDbProvider memoDb = MemoDbProvider();

  static const ROOT = 'http://18.223.233.247/deltec/webservice/Supervisorn/CrearFotosConsumo.php';
  File _image1;
  File _image2;
  File _image3;

  final picker1 = ImagePicker();
  Future getImage1() async {
    final pickedFile1 = await picker1.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile1 != null) {
        _image1 = File(pickedFile1.path);
      } else {
        print('Seleccione una imagen 1.');
      }
    });
  }

  final picker2 = ImagePicker();
  Future getImage2() async {
    final pickedFile2 = await picker2.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile2 != null) {
        _image2 = File(pickedFile2.path);
      } else {
        print('Seleccione una imagen 2.');
      }
    });
  }

  final picker3 = ImagePicker();
  Future getImage3() async {
    final pickedFile3 = await picker3.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile3 != null) {
        _image3 = File(pickedFile3.path);
      } else {
        print('Seleccione una imagen 3.');
      }
    });
  }

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


  TextEditingController _kmController;
  TextEditingController _cantidadController;
  TextEditingController _valorgController;
  TextEditingController _valorController;

  final _formKey = GlobalKey<FormState>();


  List<Consumos> _consumoss;
  List<Estaciones> _estacioness;
  List<Vehiculos> _vehiculos;
  String _valorGasoil;

  GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the First Name TextField we are going to create.
  //TextEditingController _firstNameController;
  // controller for the Last Name TextField we are going to create.
  //TextEditingController _emailController;
  Consumos _selectedConsumos;
  String _selectedEstaciones;
  String _selectedVehiculos;

  bool _isUpdating;
  String _titleProgress;

  @override
  void initState() {
    super.initState();

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

    _focusCantidad.addListener(() {
      if (_focusCantidad.hasFocus){
        _calcularValores();
      } else {
        _calcularValores();
      }
    },);

    _focusValorg.addListener(() {
      if (_focusValorg.hasFocus){
        _calcularValores();
      } else {
        _calcularValores();
      }
    },);

    _focusValor.addListener(() {
      if (_focusValor.hasFocus){
        _calcularValores();
      } else {
        _calcularValores();
      }
    },);

    final String data =
        '[{"id": 1,"nombre_estacion": "CHARLES DE GOLF"}]';
    print('Login username');
    _consumoss = [];
    _estacioness = [];
    _vehiculos = [];
    // _valorGasoil = '0';
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar

    _kmController = TextEditingController();
    _cantidadController = TextEditingController();
    _valorgController = TextEditingController();
    _valorController = TextEditingController();

    // _cantidadController.text = '0';
    // _valorController.text = '0';

    _getEstaciones();
    _getVehiculos();
    _getValorCombustible();

   // _cantidadController.addListener( _calcularValores());
  }
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
  Future<String> uploadImage(String foto, String url, String id, String numero) async {
    var map = Map<String, dynamic>();
    map['id_combustible'] = id;
    map['foto_numero'] = numero;

    //Enviar foto 1
    var request = http.MultipartRequest('POST', Uri.parse(ROOT));
    request.files.add(await http.MultipartFile.fromPath('picture', foto));
//    request.fields.addAll(map);
    request.fields['id_combustible'] = id;
    request.fields['foto_numero'] = numero;

    var res = await request.send();
    return res.reasonPhrase;
  }
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  _IrConsumo(){
    print('hola');
    Navigator.pushNamed(context, 'consumos');
  }
  _calcularValores() {
    String cantidad = _cantidadController.text;
    String valor = _valorController.text;
    String valorg = _valorgController.text;
    double resultadon = 0;
    double cantidadn = 0;
    double valorn = 0;
    double valorgn = 0;

    if(isNumeric(cantidad) && (isNumeric(valor) || isNumeric(valorg))) {
      if(isNumeric(cantidad))
        cantidadn =  double.parse(cantidad);

      if(isNumeric(valor))
        valorn =  double.parse(valor);

      if(isNumeric(valorg))
        valorgn =  double.parse(valorg);

      if(cantidadn>0){
        if(valorgn>0) {
          resultadon = cantidadn*valorgn;
          _valorController.text = resultadon.toString();
        }
        else if(valorn>0) {
          resultadon = valorn/cantidadn;
          _valorgController.text = resultadon.toString();

        }
      }
    }
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
  _submit() async {
    setState(() {
      isEnabled = false;
    });

    bool Error = false;
    if (_formKey.currentState.validate()) {

      if(_image1==null) {
        setState(() {
          isEnabled = false;
        });
          Error = true;
          Alert(
            context: context,
            onWillPopActive:true,
            type: AlertType.error,
            title: "Error",
            desc: "Debe tomar la foto de la ficha.",
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
      else if(_image2==null) {
        setState(() {
          isEnabled = false;
        });
        Error = true;
        Alert(
          context: context,
          onWillPopActive:true,
          type: AlertType.error,
          title: "Error",
          desc: "Debe tomar la foto de la bomba.",
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
      else if(_image3==null) {
        setState(() {
          isEnabled = false;
        });
        Error = true;
        Alert(
          context: context,
          onWillPopActive:true,
          type: AlertType.error,
          title: "Error",
          desc: "Debe tomar la foto del kilometraje.",
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

      if(Error==false) {
        setState(() {
          isEnabled = false;
        });
        String estacion = _selectedEstaciones;
        String vehiculo = _selectedVehiculos;
        String fecha  = selectedDate.toString();
        String km = _kmController.text;
        String cantidad = _cantidadController.text;
        String valor = _valorController.text;
        //Future<List<Logina>> login = memoDb.fetchLogin();
        Future<List> _futureOfList = memoDb.fetchLogin();;
        List list = await _futureOfList ;
        String usuario = list[0].usuario;


        _showProgress('Creando consumo...');
        Services_tanqueos.addConsumos(estacion,vehiculo,fecha,km,cantidad, valor, usuario)
            .then((result) {
          if ('error' != result.trim()) {
            //isEnabled = true;
            String id = result.trim();
            String foto1 = _image1.path;
            String foto2 = _image2.path;
            String foto3 = _image3.path;

            uploadImage(foto1,ROOT,id,'1');
            uploadImage(foto2,ROOT,id,'2');
            uploadImage(foto3,ROOT,id,'3');

            // Refresh the List after adding each employee...
            Alert(
              context: context,
              onWillPopActive:true,
              type: AlertType.success,
              title: "GUARDADO",
              desc: "Se ha guardado el Tanqueo." + id,
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
                desc: "Error al guardar el consumo.",
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
      else{
        isEnabled = true;
      }
    }
    else {
            isEnabled = true;
      }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }



  _getEstaciones() {
    //_showProgress('Loading Employees...');
    Services_estaciones.getEstaciones().then((estaciones) {
      setState(() {
        // print(json.encode(consumoss));
        _estacioness = estaciones;
        _selectedEstaciones = _estacioness[0].nombre_estacion;

      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${_estacioness.length}");
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

  _getValorCombustible() {
    Services_valor_combustibles.getUltimo()
          .then((result) {
        if ('error' != result.trim()) {
          _valorGasoil = result.trim();
          _valorgController.text = _valorGasoil;
      print("Valor Gasolina " +  _valorGasoil);
    }});
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
            width: size.width,
            height: size.height,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                SizedBox(height: 20.0,),
                                Row(
                                  children: <Widget>[
                                    Text('ESTACION DE SERVICIO',textAlign: TextAlign.left,),
                                  ],
                                ),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('Seleccione la Estacion de servicio'),
                                  value: _selectedEstaciones,
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
                                      _selectedEstaciones = newValue;
                                    });
                                  },
                                  items: _estacioness.map((Estaciones map) {
                                    return new DropdownMenuItem<String>(
                                      value: map.nombre_estacion,
                                      child: new Text(map.nombre_estacion,
                                          style: new TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('FICHA',textAlign: TextAlign.right),
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
                                    Text("${selectedDate.toLocal()}".split(' ')[0]),
                                    SizedBox(width: 20.0,),
                                    RaisedButton(
                                      onPressed: () => _selectDate(context),
                                      child: Icon(Icons.date_range),
                                    ),
                                  ],
                                ),
                                Input(
                                  onEditingComplete: _calcularValores(),
                                  textEditingController: _kmController,
                                  inputType: TextInputType.phone,
                                  label: 'KILOMETRAJE',
                                  validator: (String text){
                                    if(text.isNotEmpty && RegExp(r'^[0-9.]+$').hasMatch(text)){
                                      return null;
                                    }
                                    return 'El Kilometraje debe contener valores numericos.';
                                  },
                                ),
                                Input(
                                  focusNode: _focusCantidad,
                                  onEditingComplete: _calcularValores(),
                                  textEditingController: _cantidadController,
                                  label: 'CANTIDAD DE GALONES',
                                  inputType: TextInputType.phone,
                                  validator: (String text){
                                    if(text.isNotEmpty && RegExp(r'^[0-9.]+$').hasMatch(text) && text!="0"){
                                      return null;
                                    }
                                    return 'La cantidad de galones debe ser mayor a cero.';
                                  },
                                ),
                                Input(
                                  focusNode: _focusValorg,
                                  onEditingComplete: _calcularValores(),
                                  textEditingController: _valorgController,
                                  label: 'VALOR GALON',
                                  inputType: TextInputType.phone,
                                  validator: (String text){
                                    if(text.isNotEmpty && RegExp(r'^[0-9.]+$').hasMatch(text) && text!="0"){
                                      return null;
                                    }
                                    return 'El valor del galon debe contener valores mayores a cero.';
                                  },
                                ),
                                Input(
                                  focusNode: _focusValor,
                                  onEditingComplete: _calcularValores(),
                                  textEditingController: _valorController,
                                  label: 'VALOR TOTAL TANQUEO',
                                  inputType: TextInputType.phone,
                                  validator: (String text){
                                    if(text.isNotEmpty && RegExp(r'^[0-9.]+$').hasMatch(text) && text!="0"){
                                      return null;
                                    }
                                    return 'El valor de la carga debe contener valores mayores a cero.';
                                  },
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Center(
                                            child: _image1 == null
                                                ? Text('Foto Ficha.')
                                                : Column(
                                              children: <Widget>[
                                                Text('Foto Ficha.'),
                                                Image.file(_image1,width: size.width*0.2,height: size.height*0.15,),
                                              ],
                                            )
                                        ),
                                        FloatingActionButton(
                                          heroTag: "btn1",
                                          backgroundColor: Colors.blue,
                                          tooltip: 'Pick Image x',
                                          child: Icon(Icons.add_a_photo),
                                          onPressed: getImage1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10.0,),
                                    Column(
                                      children: <Widget>[
                                        Center(
                                          child: _image2 == null
                                              ? Text('Foto Bomba.')
                                              : Column(
                                            children: <Widget>[
                                              Text('Foto Bomba.'),
                                              Image.file(_image2,width: size.width*0.2,height: size.height*0.15)
                                            ],
                                          ),
                                        ),
                                        FloatingActionButton(
                                          heroTag: "btn2",
                                          backgroundColor: Colors.blue,
                                          tooltip: 'Pick Image',
                                          child: Icon(Icons.add_a_photo),
                                          onPressed: getImage2,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10.0,),
                                    Column(
                                      children: <Widget>[
                                        Center(
                                          child: _image3 == null
                                              ? Text('Foto kilometraje.')
                                              : Column(
                                            children: <Widget>[
                                              Text('Foto kilometraje.'),
                                              Image.file(_image3,width: size.width*0.2,height: size.height*0.15)
                                            ],
                                          ),
                                        ),
                                        FloatingActionButton(
                                          heroTag: "btn3",
                                          backgroundColor: Colors.blue,
                                          tooltip: 'Pick Image',
                                          child: Icon(Icons.add_a_photo),
                                          onPressed: getImage3,
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            enableFeedback:true,
            icon: Icon(Icons.save),
              onPressed: isEnabled ? ()=> _submit() : null
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
    );
  }
}