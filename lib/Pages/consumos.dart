import 'package:cook/bd/sqlitedb.dart';
import 'package:flutter/material.dart';
import '../models/Consumos.dart';
import '../services/Services_tanqueos.dart';
import 'dart:async';
import '../Widgets/navigation_bloc.dart';

class DataTableDemo extends StatefulWidget {
  //
  DataTableDemo() : super();

  final String title = 'Consumos del día';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  Future<bool> _onBackPressed() {
    Navigator.pushNamed(context, 'principal');
    true;
  }

  MemoDbProvider memoDb = MemoDbProvider();

  List<Consumos> _consumoss;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Consumos _selectedConsumos;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState() {
    super.initState();

    _consumoss = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getConsumos();
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

  _getConsumos() async{
    //_showProgress('Loading Employees...');
    Future<List> _futureOfList = memoDb.fetchLogin();;
    List list = await _futureOfList ;
    String usuario = list[0].usuario;
    Services_tanqueos.getConsumoss(usuario).then((consumoss) {
      setState(() {
        _consumoss = consumoss;
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
            DataColumn(
              label: Text('GALONES'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('DELETE'),
            )
          ],
          rows: _consumoss
              .map(
                (consumos) => DataRow(cells: [
              DataCell(
                Text(consumos.id),
                onTap: () {
                  _selectedConsumos = consumos;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  consumos.fecha,
                ),
                onTap: () {
                  _selectedConsumos = consumos;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                    Text(
                      consumos.vehiculo,
                    ),
                    onTap: () {
                      _selectedConsumos = consumos;
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(
                    Text(
                      consumos.galones,
                    ),
                    onTap: () {
                      _selectedConsumos = consumos;
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
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
              Navigator.pushNamed(context, 'consumosadd');
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushNamed(context, 'consumos');
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
          Navigator.pushNamed(context, 'consumosadd');
        },
        child: Icon(Icons.add),
      ),
    )
    );
  }
}