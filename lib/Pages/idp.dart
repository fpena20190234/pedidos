import 'package:cook/bd/sqlitedb.dart';
import 'package:flutter/material.dart';
import '../models/Idp.dart';
import '../services/Services_idp.dart';
import 'dart:async';
import '../Widgets/navigation_bloc.dart';

class Idps extends StatefulWidget {
  //
  Idps() : super();

  final String title = 'IDP/Incidencia';

  @override
  IdpsState createState() => IdpsState();
}

class IdpsState extends State<Idps> {
  Future<bool> _onBackPressed() {
    Navigator.pushNamed(context, 'principal');
    true;
  }

  MemoDbProvider memoDb = MemoDbProvider();

  List<Idp> _idps;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Idp _selectedIdp;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState() {
    super.initState();

    _idps = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getIdps();
  }

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
  _editIdp(String id_idp){
      print("Id_idp = " + id_idp);
      Navigator.pushNamed(context, 'IdpsAdd',arguments: {id_idp:id_idp});
  }


  _getIdps() async{
    //_showProgress('Loading Employees...');
    Future<List> _futureOfList = memoDb.fetchLogin();;
    List list = await _futureOfList ;
    String usuario = list[0].usuario;
    Services_idp.getIDP(usuario).then((idpss) {
      setState(() {
        _idps = idpss;
      });
    });
  }

  _getusuario() async {
    MemoDbProvider memoDb = MemoDbProvider();
    Future<List> _futureOfList = memoDb.fetchLogin();
    List list = await _futureOfList ;
    String usuario = list[0].usuario;
    return usuario;
  }

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:DataTable(
          columns: [
            DataColumn(
              label: Text('OPC',textAlign: TextAlign.center,),
            ),

            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('FECHA'),
            ),
            DataColumn(
              label: Text('FICHA'),
            ),
            DataColumn(
              label: Text('PROYECTO'),
            ),
            DataColumn(
              label: Text('OBSERVACION'),
            ),
          ],
          rows: _idps
              .map(
                (idp) => DataRow(cells: [
              DataCell(
                  Row(children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editIdp(idp.id_idp);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.update),
                      onPressed: () {
                        _editIdp(idp.id_idp);
                      },
                    ),

                  ],),
              ),
              DataCell(
                Text(idp.id_idp),
                onTap: () {
                  _selectedIdp = idp;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  idp.fecha,
                ),
                onTap: () {
                  _selectedIdp = idp;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  idp.vehiculo,
                ),
                onTap: () {
                  _selectedIdp = idp;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  idp.proyecto,
                ),
                onTap: () {
                  _selectedIdp = idp;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  idp.observaciones_idp,
                ),
                onTap: () {
                  _selectedIdp = idp;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
            ]),
          ).toList(),
        ),

      )
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) print(arguments['logina']);
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(_titleProgress), // we show the progress in the title...
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, 'IdpsAdd');
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  Navigator.pushNamed(context, 'Idps');
                },
              )
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'IdpsAdd');
            },
            child: Icon(Icons.add),
          ),
        )
    );
  }
}