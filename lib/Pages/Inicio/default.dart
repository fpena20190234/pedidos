import 'package:cook/Widgets/input.dart';
import 'package:cook/bd/sqlitedb.dart';
import 'package:cook/models/Bodegas.dart';
import 'package:cook/models/Ciudades.dart';
import 'package:cook/models/Contratos.dart';
import 'package:cook/models/Idp_linieros.dart';
import 'package:cook/models/Idp_vehiculos.dart';
import 'package:cook/models/Linieros.dart';
import 'package:cook/models/Logina.dart';
import 'package:cook/models/Supervisor.dart';
import 'package:cook/models/Vehiculos.dart';
import 'package:cook/services/Service_general.dart';
import 'package:cook/services/Services_vehiculos.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomCheckBoxGroup.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:random_color/random_color.dart';

RandomColor _randomColor = RandomColor();

class DefaultPage extends StatefulWidget {
  DefaultPage({Key key, this.url}) : super(key: key);
  final String title = 'Empresas';
  final String url;
  @override
  DefaultPageState createState() => DefaultPageState();
}

class DefaultPageState extends State<DefaultPage> {
  MemoDbProvider memoDb = MemoDbProvider();
  List<CoolStep> _steps = List<CoolStep>();
  TextStyle titulos =
      TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold);

  String selectedRole = "Writer";

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  TextEditingController _horaController = TextEditingController();

  String _titleProgress = "Datos Predeterminados";
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<Supervisor> _supervisord;
  List<Supervisor> _supervisore;
  List<Linieros> _linieros;
  List<Vehiculos> _vehiculos;
  List<Contratos> _contratos;
  List<Bodegas> _bodegas;

  List<IdpLinieros> _idpLineros = List<IdpLinieros>();
  List<IdpVehiculos> _idpVehiculos = List<IdpVehiculos>();

  String _selectedSupervisorD,
      _selectedSupervisorE,
      _selectedLinieros,
      _selectedVehiculo,
      _selectedContrato,
      _selectedBodega;

  @override
  void initState() {
    super.initState();
    _supervisord = [];
    _supervisore = [];
    _linieros = [];
    _idpLineros = [];
    _bodegas = [];

    _vehiculos = [];
    _idpVehiculos = [];
    _contratos = [];
    _horaController.text = "8";
    _getVehiculos();
    _getContratos();
  } //Fin InitState

  // Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(String val) {
    setState(() {
      _selectedContrato = val;
      _getSupervisorDeltec(_selectedContrato);
      _getSupervisorEdeeste(_selectedContrato);
      _getLinieros(_selectedContrato);
      _getBodegas(_selectedContrato);
    });
  }

  _getBodegas(String contrato) {
    //_showProgress('Loading Employees...');
    Services_general.getBodegas(contrato).then((bodegas) {
      setState(() {
        _bodegas = bodegas;
        _selectedBodega = _bodegas[0].full_nombre;
      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${_bodegas.length}");
    });
  }

  _getContratos() async {
    //=========================LOS DATOS DEL USUARIO===============================
    Future<List> _futureOfList = memoDb.fetchLogin();
    ;
    List list = await _futureOfList;
    String usuario = list[0].usuario;
    print("Usuario = " + usuario);
    Services_general.getContratos(usuario).then((contratos) {
      setState(() {
        _contratos = contratos;
        _selectedContrato = _contratos[0].id_empresa;
        _getSupervisorDeltec(_selectedContrato);
        _getSupervisorEdeeste(_selectedContrato);
        _getLinieros(_selectedContrato);
      });
    });
  }

  _getVehiculos() {
    //_showProgress('Loading Employees...');
    Services_vehiculos.getVehiculos().then((vehiculos) {
      setState(() {
        _vehiculos = vehiculos;
        _selectedVehiculo = _vehiculos[0].alias;
      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${_vehiculos.length}");
    });
  }

  _getLinieros(String contrato) {
    //_showProgress('Loading Employees...');
    Services_general.getLinieros(contrato).then((linieros) {
      setState(() {
        // print(json.encode(consumoss));
        _linieros = linieros;
        _selectedLinieros = _linieros[0].full_nombre;
      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${_linieros.length}");
    });
  }

  _getSupervisorDeltec(String contrato) {
    print("contrato" + contrato);
    Services_general.getSupervisorD(contrato).then((supervisord) {
      setState(() {
        // print(json.encode(consumoss));
        _supervisord = supervisord;
        _selectedSupervisorD = _supervisord[0].full_nombre;
      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${_supervisord.length}");
    });
  }

  _getSupervisorEdeeste(String contrato) {
    //_showProgress('Loading Employees...');
    Services_general.getSupervisorE(contrato).then((supervisore) {
      setState(() {
        // print(json.encode(consumoss));
        _supervisore = supervisore;
        _selectedSupervisorE = _supervisore[0].full_nombre;
      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${_supervisore.length}");
    });
  }

  _submit() async {
    //Linieros
    for (int i = 0; i < _idpLineros.length; i++) {
      final liniero = IdpLinieros(
          liniero: _idpLineros[i].liniero,
          vehiculo: _idpLineros[i].vehiculo,
          horas: _idpLineros[i].horas);
      var data = memoDb.addLiniero(liniero);
    }
    /*Vehiculos
    for (int i = 0; i < _idpVehiculos.length; i++) {
      final vehiculo = IdpVehiculos(alias: _idpVehiculos[i].alias);
      memoDb.addVehiculos(vehiculo);
    }*/
    String fecha = DateTime.now().toString();
    //Supervisores
    Future<List> _futureOfList = memoDb.fetchLogin();
    List list = await _futureOfList;
    String usuario = list[0].usuario;
    print("Usuario " +
        usuario +
        ", fecha " +
        fecha +
        ", supervisord" +
        _selectedSupervisorD +
        " , _selectedSupervisorE" +
        _selectedSupervisorE +
        ", _selectedContrato" +
        _selectedContrato);
    final logina = Logina(
        usuario: usuario,
        fechac: DateTime.now().toString(),
        supervisord: _selectedSupervisorD,
        supervisore: _selectedSupervisorE,
        id_empresa: _selectedContrato,
        bodega: _selectedBodega);
    int filasa = await memoDb.updateMemo(usuario, logina);
    print("Filas a " + filasa.toString());
    Navigator.pushNamed(context, 'principal');
  }

  _addListPersonas() async {
    String liniero = _selectedLinieros;
    String vehiculo = _selectedVehiculo;
    String horas = _horaController.text;

    if (_idpLineros.length < 4) {
      if (!_idpLineros.any((IdpLinieros) => IdpLinieros.liniero == liniero)) {
        setState(() {
          _idpLineros.add(
              IdpLinieros(liniero: liniero, vehiculo: vehiculo, horas: horas));
        });
      } else {
        Alert(
          context: context,
          onWillPopActive: true,
          type: AlertType.error,
          title: "Error",
          desc: liniero + ', ya esta en la lista.',
          buttons: [
            DialogButton(
              child: Text(
                "Cerrar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => {Navigator.pop(context)},
              width: 120,
            )
          ],
        ).show();
      }
    } else {
      Alert(
        context: context,
        onWillPopActive: true,
        type: AlertType.error,
        title: "Error",
        desc: 'El limite es de personas es 4.',
        buttons: [
          DialogButton(
            child: Text(
              "Cerrar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => {Navigator.pop(context)},
            width: 120,
          )
        ],
      ).show();
    }
  }

  _addListVehiculos() async {
    String vehiculo = _selectedVehiculo;
    if (_idpVehiculos.length < 4) {
      if (!_idpVehiculos
          .any((IdpVehiculos) => IdpVehiculos.alias == vehiculo)) {
        setState(() {
          _idpVehiculos.add(IdpVehiculos(alias: vehiculo));
        });
      } else {
        Alert(
          context: context,
          onWillPopActive: true,
          type: AlertType.error,
          title: "Error",
          desc: 'El vehiculo ' + vehiculo + ', ya esta en la lista.',
          buttons: [
            DialogButton(
              child: Text(
                "Cerrar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => {Navigator.pop(context)},
              width: 120,
            )
          ],
        ).show();
      }
    } else {
      Alert(
        context: context,
        onWillPopActive: true,
        type: AlertType.error,
        title: "Error",
        desc: 'El limite es de vehiculos es 4.',
        buttons: [
          DialogButton(
            child: Text(
              "Cerrar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => {Navigator.pop(context)},
            width: 120,
          )
        ],
      ).show();
    }

    //print(_idpLineros.contains(IdpLinieros(full_nombre: liniero))); // false;
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
            width: size.width * 0.9,
            height: size.height * 0.68,
            child: SafeArea(
              child: Padding(
                padding: new EdgeInsets.all(5.0),
                child: Column(
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
                                  SizedBox(
                                    height: 5.0,
                                    width: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('BODEGA',
                                          textAlign: TextAlign.right,
                                          style: titulos),
                                    ],
                                  ),
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('Seleccione BODEGA'),
                                    value: _selectedBodega,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.deepPurple, fontSize: 14),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _selectedBodega = newValue;
                                      });
                                    },
                                    items: _bodegas.map((Bodegas map) {
                                      return new DropdownMenuItem<String>(
                                        value: map.full_nombre,
                                        child: new Text(map.full_nombre,
                                            style: new TextStyle(
                                                color: Colors.black)),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                    width: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('SUPERVISOR DELTEC',
                                          textAlign: TextAlign.right,
                                          style: titulos),
                                    ],
                                  ),
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('Seleccione Supervisor Deltec'),
                                    value: _selectedSupervisorD,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.deepPurple, fontSize: 14),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _selectedSupervisorD = newValue;
                                      });
                                    },
                                    items: _supervisord.map((Supervisor map) {
                                      return new DropdownMenuItem<String>(
                                        value: map.full_nombre,
                                        child: new Text(map.full_nombre,
                                            style: new TextStyle(
                                                color: Colors.black)),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                    width: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('SUPERVISOR EDEESTE:',
                                          textAlign: TextAlign.left,
                                          style: titulos),
                                    ],
                                  ),
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text('Seleccione supervisor Edeeste'),
                                    value: _selectedSupervisorE,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.deepPurple, fontSize: 14),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _selectedSupervisorE = newValue;
                                      });
                                    },
                                    items: _supervisore.map((Supervisor map) {
                                      return new DropdownMenuItem<String>(
                                        value: map.full_nombre,
                                        child: new Text(map.full_nombre,
                                            style: new TextStyle(
                                                color: Colors.black)),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            )),
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
            width: size.width * 0.9,
            height: size.height * 0.68,
            child: SafeArea(
              child: Padding(
                padding: new EdgeInsets.all(5.0),
                child: Column(
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
                              key: _formKey1,
                              child: Column(
                                children: <Widget>[
                                  Text('PERSONAL/VEHICULO/HORAS',
                                      textAlign: TextAlign.right),
                                  Column(
                                    children: <Widget>[
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text('Seleccione liniero'),
                                        value: _selectedLinieros,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 14),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _selectedLinieros = newValue;
                                          });
                                        },
                                        items: _linieros.map((Linieros map) {
                                          return new DropdownMenuItem<String>(
                                            value: map.full_nombre,
                                            child: new Text(map.full_nombre,
                                                style: new TextStyle(
                                                    color: Colors.black)),
                                          );
                                        }).toList(),
                                      ),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text('Seleccione el vehiculo'),
                                        value: _selectedVehiculo,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 14),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _selectedVehiculo = newValue;
                                          });
                                        },
                                        items: _vehiculos.map((Vehiculos map) {
                                          return new DropdownMenuItem<String>(
                                            value: map.alias,
                                            child: new Text(map.alias,
                                                style: new TextStyle(
                                                    color: Colors.black)),
                                          );
                                        }).toList(),
                                      ),
                                      Input(
                                        textEditingController: _horaController,
                                        inputType: TextInputType.phone,
                                        label: 'HORAS',
                                        validator: (String text) {
                                          if (text.isNotEmpty &&
                                              RegExp(r'^[0-9.]+$')
                                                  .hasMatch(text)) {
                                            return null;
                                          }
                                          return 'Solo valores numericos.';
                                        },
                                      ),
                                      RaisedButton(
                                        onPressed: () => _addListPersonas(),
                                        textColor: Colors.white,
                                        padding: const EdgeInsets.all(0.0),
                                        color: Colors.blue,
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          child: const Text('Agregar',
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 5.0,
                          width: 10.0,
                        ),
                        Text('LISTA LINIEROS/VEHICULOS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w900)),
                        _idpLineros.length > 0
                            ? Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(1.0),
                                      itemCount: _idpLineros.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Table(
                                          children: <TableRow>[
                                            TableRow(
                                              children: <Widget>[
                                                Container(
                                                  width: 1200,
                                                  height: 30,
                                                  child: Text(
                                                    _idpLineros[index].liniero,
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Container(
                                                  width: 1,
                                                  height: 15,
                                                  child: Text(
                                                    _idpLineros[index].vehiculo,
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Container(
                                                  width: 1,
                                                  height: 15,
                                                  child: Text(
                                                    _idpLineros[index].horas,
                                                    style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                ],
                              )
                            : Text('No ha seleccionado a ninguna persona.',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w300))
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert Dialog Example !!!'),
            content: Text('Alert Dialog Body Goes Here  ..'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('CANCEL')),
            ],
          );
        });
  }

  SingleChildScrollView _dataBody3() {
    final size = MediaQuery.of(context).size;
    int _value = 1;
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            width: size.width * 0.9,
            height: size.height * 0.68,
            child: SafeArea(
              child: Padding(
                padding: new EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 350,
                          minWidth: 350,
                        ),
                        child: Form(
                          key: _formKey3,
                          child: Column(
                            children: <Widget>[],
                          ),
                        )),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                          width: 10.0,
                        ),
                        //Text('VEHICULOS UTILIZADOS',textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w900)),
                        _contratos.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(20.0),
                                itemCount: _contratos.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //return Text(_idpVehiculos[index].alias);
                                  return
                                      //  SingleChildScrollView(
                                      // scrollDirection: Axis.vertical,
                                      // child:
                                      Column(
                                    children: <Widget>[
                                      SizedBox(
                                        // height: 210,
                                        child: Card(
                                          color: _randomColor.randomColor(
                                              colorBrightness:
                                                  ColorBrightness.light),
                                          child: new InkWell(
                                            onTap: () {
                                              _popupDialog(context);
                                            },
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                      _contratos[index]
                                                          .nombre_empresa,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  // subtitle:
                                                  //     Text('My City, CA 99984'),
                                                  leading: Icon(
                                                    Icons.account_balance,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Divider(),

                                                // ListTile(
                                                //   title: Text('(408) 555-1212',
                                                //       style: TextStyle(
                                                //           fontWeight:
                                                //               FontWeight.w500)),
                                                //   leading: Icon(
                                                //     Icons.contact_phone,
                                                //     color: Colors.blue[500],
                                                //   ),
                                                // ),
                                                // ListTile(
                                                //   title:
                                                //       Text('costa@example.com'),
                                                //   leading: Icon(
                                                //     Icons.contact_mail,
                                                //     color: Colors.blue[500],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ); //);
                                }) // ? ListView.builder(
                            //     shrinkWrap: true,
                            //     padding: const EdgeInsets.all(20.0),
                            //     itemCount: _contratos.length,
                            //     itemBuilder: (BuildContext context, int index) {
                            //       //return Text(_idpVehiculos[index].alias);
                            //       return Column(
                            //         children: <Widget>[
                            //           RadioListTile(
                            //             value: _contratos[index].id_empresa,
                            //             groupValue: _selectedContrato,
                            //             title: Text(
                            //                 _contratos[index].nombre_empresa),
                            //             onChanged: (String val) {
                            //               setSelectedRadio(val);
                            //             },
                            //           ),
                            //         ],
                            //       );
                            //     })
                            : Text('No tiene acceso a ningun contrato',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w300))
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _steps = [
      CoolStep(
        title: "EMPRESA",
        subtitle: "Seleccione la empresa",
        content: _dataBody3(),
        validation: () {
          bool Error = false;
          if (_selectedContrato == null) {
            Alert(
              context: context,
              onWillPopActive: true,
              type: AlertType.error,
              title: "Error",
              desc: "Debe seleccionar una empresa.",
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
          if (!Error)
            return null;
          else
            return "-";
        },
      ),
      CoolStep(
        title: "SUPERVISORES DEL TURNO",
        subtitle: "Seleccione los supervisores",
        content: _dataBody(),
        validation: () {
          if (!_formKey.currentState.validate()) {
            return "Fill form correctly";
          }
          return null;
        },
      ),
      CoolStep(
        title: "PERSONAL",
        subtitle: "Seleccione los Linieros y de clic en el boton de agregar",
        content: _dataBody1(),
        validation: () {
          bool Error = false;
          if (_idpLineros.length == 0) {
            Alert(
              context: context,
              onWillPopActive: true,
              type: AlertType.error,
              title: "Error",
              desc: "Debe agregar por lo menos una persona al turno.",
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
          if (!Error)
            return null;
          else
            return "-";
        },
      ),
      CoolStep(
        title: "INICIAR TURNO.",
        subtitle:
            "Ponga en practica las siguientes reglas, luego de clic en el boton de iniciar.",
        content: Container(
          child: Column(
            children: [
              Container(
                width: 290,
                height: 370,
                //margin: EdgeInsets.only(10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      // scale: 200,
                      image: NetworkImage(
                          "http://18.223.233.247/upload_deltec/5_reglas_oro.jpg"),
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
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                      onPressed: () => _submit(),
                      child: Text(
                        'Iniciar',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
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
      steps: _steps,
      config: CoolStepperConfig(
          backText: "Anterior",
          nextText: "Siguiente",
          ofText: "de",
          stepText: "Paso",
          finalText: "Fin"),
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
}
