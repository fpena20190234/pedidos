import 'package:cook/bd/sqlitedb.dart';
import 'package:flutter/material.dart';
import '../models/Preoperacional.dart';
import '../services/Services_preoperacional.dart';
import 'dart:async';
import '../Widgets/navigation_bloc.dart';

class Preoperacionales extends StatefulWidget {
  //
  Preoperacionales() : super();

  final String title = 'Preoperacionales del día';

  @override
  PreoperacionalesState createState() => PreoperacionalesState();
}

class PreoperacionalesState extends State<Preoperacionales> {
  Future<bool> _onBackPressed() {
    Navigator.pushNamed(context, 'principal');
    true;
  }

  MemoDbProvider memoDb = MemoDbProvider();

  List<Preoperacional> _preoperacionals;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Preoperacional _selectedPreoperacional;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState() {
    super.initState();

    _preoperacionals = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getPreoperacionales();
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

  _getPreoperacionales() async{
    //_showProgress('Loading Employees...');
    Future<List> _futureOfList = memoDb.fetchLogin();;
    List list = await _futureOfList ;
    String usuario = list[0].usuario;
    Services_preoperacional.getPreoperacional(usuario).then((preoperacional) {
      setState(() {
        _preoperacionals = preoperacional;
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
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('FECHA'),
            ),
            DataColumn(
              label: Text('FICHA'),
            ),
            // DataColumn(
            //   label: Text('CONDUCTOR'),
            // ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _preoperacionals
              .map(
                (preoperacional) => DataRow(cells: [
              DataCell(
                Text(preoperacional.id_preoperacional),
                onTap: () {
                  _selectedPreoperacional = preoperacional;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  preoperacional.fecha,
                ),
                onTap: () {
                  _selectedPreoperacional = preoperacional;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  preoperacional.alias,
                ),
                onTap: () {
                  _selectedPreoperacional = preoperacional;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              // DataCell(
              //   Text(
              //     preoperacional.nombre_usuario,
              //   ),
              //   onTap: () {
              //     _selectedPreoperacional = preoperacional;
              //     setState(() {
              //       _isUpdating = true;
              //     });
              //   },
              // ),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  //_deleteEmployee(employee);
                },
              ))
            ]),
          ).toList(),
        ),
      ),
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
                  Navigator.pushNamed(context, 'PreoperacionalAdd');
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  Navigator.pushNamed(context, 'preoperacional');
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
              Navigator.pushNamed(context, 'PreoperacionalAdd');
            },
            child: Icon(Icons.add),
          ),
        )
    );
  }
}