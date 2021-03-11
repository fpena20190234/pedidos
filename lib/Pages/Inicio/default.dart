import 'package:cook/Widgets/input.dart';
import 'package:cook/bd/sqlitedb.dart';
import 'package:cook/models/Contratos.dart';
import 'package:cook/models/Logina.dart';
import 'package:cook/services/Service_general.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:random_color/random_color.dart';
import '../principal.dart';

// RandomColor _randomColor = RandomColor();

class DefaultPage extends StatefulWidget {
  DefaultPage({Key key, this.url}) : super(key: key);
  final String title = 'Empresas';
  final String url;
  @override
  DefaultPageState createState() => DefaultPageState();
}

class DefaultPageState extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildListView(),
    );
  }

  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(color: Colors.white),
  //     child: Center(
  //       child: Text(
  //         'Hello World',
  //         textDirection: TextDirection.ltr,
  //         style: TextStyle(
  //           fontSize: 32,
  //           color: Colors.black87,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  MemoDbProvider memoDb = MemoDbProvider();
//   List<CoolStep> _steps = List<CoolStep>();
//   TextStyle titulos =
//       TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold);

//   String selectedRole = "Writer";

//   final _formKey = GlobalKey<FormState>();
//   final _formKey1 = GlobalKey<FormState>();
//   final _formKey2 = GlobalKey<FormState>();
//   final _formKey3 = GlobalKey<FormState>();

  TextEditingController _horaController = TextEditingController();

  List<Contratos> _contratos;

  String _selectedContrato, _selectedBodega;

  @override
  void initState() {
    super.initState();

    _contratos = [];
    _horaController.text = "8";

    _getContratos();
  } //Fin InitState

  _getContratos() async {
    //=========================LOS DATOS DEL USUARIO===============================
    Future<List> _futureOfList = memoDb.fetchLogin();

    List list = await _futureOfList;
    String usuario = list[0].usuario;
    print("Usuario = " + usuario);
    Services_general.getContratos(usuario).then((contratos) {
      setState(() {
        _contratos = contratos;
        _selectedContrato = _contratos[0].id_empresa.toString();
      });
    });
  }

  _submit() async {
    String fecha = DateTime.now().toString();
    //Supervisores
    Future<List> _futureOfList = memoDb.fetchLogin();
    List list = await _futureOfList;
    String usuario = list[0].usuario;

    final logina = Logina(
        usuario: usuario,
        fechac: DateTime.now().toString(),
        id_empresa: _selectedContrato,
        bodega: _selectedBodega);
    int filasa = await memoDb.updateMemo(usuario, logina);
    print("Filas a " + filasa.toString());
    Navigator.pushNamed(context, 'principal');
  }

  ListView _buildListView() {
    return ListView.builder(
      // itemCount: 10,
      itemCount: _contratos.length,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(_contratos[index].direccion != null
              ? '${_contratos[index].nombre_empresa} - ${_contratos[index].direccion}'
              : '${_contratos[index].nombre_empresa}'),
        );
      },
    );
  }
//   // Let's create a DataTable and show the employee list in it.

//   void _popupDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Alert Dialog Example !!!'),
//             content: Text('Alert Dialog Body Goes Here  ..'),
//             actions: <Widget>[
//               FlatButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('OK')),
//               FlatButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('CANCEL')),
//             ],
//           );
//         });
//   }

//   int count = 0;
//   void incrementCounter() {
//     setState(() {
//       count++;
//     });
//     print('count $count');
//   }

//   SingleChildScrollView _dataBody3() {
//     final size = MediaQuery.of(context).size;
//     int _value = 1;
//     // Both Vertical and Horozontal Scrollview for the DataTable to
//     // scroll both Vertical and Horizontal...
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: SingleChildScrollView(
//         // scrollDirection: Axis.horizontal,
//         child: Container(
//             // width: size.width * 0.9,
//             // height: size.height * 0.68,
//             child: SafeArea(
//           child: Padding(
//             padding: new EdgeInsets.all(3.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 ConstrainedBox(
//                     constraints: BoxConstraints(
//                       maxWidth: 350,
//                       minWidth: 350,
//                     ),
//                     child: Form(
//                       key: _formKey3,
//                       child: Column(
//                         children: <Widget>[],
//                       ),
//                     )),
//                 Column(
//                   children: <Widget>[
//                     // SizedBox(
//                     //   height: 20.0,
//                     //   width: 10.0,
//                     // ),
//                     //Text('VEHICULOS UTILIZADOS',textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w900)),
//                     _contratos.length > 0
//                         ? ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             // padding: const EdgeInsets.all(10.0),
//                             itemCount: _contratos.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return Card(
//                                 // Con esta propiedad modificamos la forma de nuestro card
//                                 // Aqui utilizo RoundedRectangleBorder para proporcionarle esquinas circulares al Card
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),

//                                 // Con esta propiedad agregamos margen a nuestro Card
//                                 // El margen es la separación entre widgets o entre los bordes del widget padre e hijo
//                                 margin: EdgeInsets.all(5),

//                                 // Con esta propiedad agregamos elevación a nuestro card
//                                 // La sombra que tiene el Card aumentará
//                                 elevation: 10,

//                                 // La propiedad child anida un widget en su interior
//                                 // Usamos columna para ordenar un ListTile y una fila con botones
//                                 child: Column(
//                                   // mainAxisAlignment: MainAxisAlignment.center,
//                                   // crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: <Widget>[
//                                     // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono

//                                     ListTile(
//                                       contentPadding:
//                                           EdgeInsets.fromLTRB(15, 10, 25, 0),
//                                       title: Text(
//                                           '${_contratos[index].nombre_empresa} \n Empresa ${_contratos[index].id_empresa}'),
//                                       // subtitle: _contratos[index].logo != null
//                                       //     ? Text(
//                                       //         'http://18.223.233.247${_contratos[index].logo.replaceAll("../..", "")}')
//                                       //     : Text(''),
//                                       leading: Icon(Icons.home),
//                                     ),
//                                     Container(
//                                       width: size.width * 0.8,
//                                       height: size.height * 0.099,
//                                       margin: EdgeInsets.only(
//                                           top: size.width * 0.01),
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                             image: NetworkImage(_contratos[
//                                                             index]
//                                                         .logo ==
//                                                     null
//                                                 ? "http://18.223.233.247/prueba/upload/logo/No-logo.jpg"
//                                                 : 'http://18.223.233.247${_contratos[index].logo.replaceAll("../..", "")}'),
//                                             fit: BoxFit.cover),
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(15),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black26,
//                                             blurRadius: 25,
//                                           )
//                                         ],
//                                       ),
//                                     ),

//                                     // Usamos una fila para ordenar los botones del card
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: <Widget>[
//                                         FlatButton(
//                                             onPressed: () => {
//                                                   Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             PrincipalPage()),
//                                                   )
//                                                   // incrementCounter(),
//                                                   // new Text(
//                                                   //     'Button Clicks - ${count}'),
//                                                 },
//                                             child: Text('Ingresar')),
//                                         // FlatButton(
//                                         //     onPressed: () => {},
//                                         //     child: Text('Cancelar'))
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               );
//                               //  SingleChildScrollView(
//                               // scrollDirection: Axis.vertical,
//                               // child:
//                               //     Center(
//                               //   child: Card(
//                               //     child: InkWell(
//                               //       splashColor: Colors.blue.withAlpha(30),
//                               //       onTap: () {
//                               //         print('Card tapped.');
//                               //       },
//                               //       child: Container(
//                               //           // height: 50,
//                               //           child: Column(
//                               //         children: [
//                               //           ListTile(
//                               //             title: Text(
//                               //                 _contratos[index]
//                               //                     .nombre_empresa,
//                               //                 style: TextStyle(
//                               //                     fontWeight:
//                               //                         FontWeight.w500)),
//                               //             // subtitle:
//                               //             //     Text('My City, CA 99984'),
//                               //             leading: Icon(
//                               //               Icons.account_balance,
//                               //               color: Colors.black54,
//                               //             ),
//                               //           ),
//                               //           // Divider(),
//                               //         ],
//                               //       )),
//                               //     ),
//                               //   ),
//                               // );
//                             })
//                         : Text('No tiene acceso a ningun contrato',
//                             style: TextStyle(
//                                 color: Colors.orange,
//                                 fontWeight: FontWeight.w300))
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         )),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     _steps = [
//       CoolStep(
//         title: "EMPRESA",
//         subtitle: "Seleccione la empresa",
//         content: _dataBody3(),
//         validation: () {
//           bool Error = false;
//           if (_selectedContrato == null) {
//             Alert(
//               context: context,
//               onWillPopActive: true,
//               type: AlertType.error,
//               title: "Error",
//               desc: "Debe seleccionar una empresa.",
//               buttons: [
//                 DialogButton(
//                   child: Text(
//                     "Cerrar",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                   width: 120,
//                 )
//               ],
//             ).show();
//             Error = true;
//           }
//           if (!Error)
//             return null;
//           else
//             return "-";
//         },
//       ),
//     ];

//     final stepper = CoolStepper(
//       onCompleted: () {
//         print("Pasos completados!");
//       },
//       steps: _steps,
//       config: CoolStepperConfig(
//           backText: "Anterior",
//           nextText: "Siguiente",
//           ofText: "de",
//           stepText: "Paso",
//           finalText: "Fin"),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Container(
//         child: stepper,
//       ),
//     );
//   }
}
