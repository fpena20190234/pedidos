import 'package:flutter/material.dart';
class Texto extends StatefulWidget{
  final String label;


  const Texto({Key key,@required this.label}) : super(key: key);

  @override
  _TextoState createState()=> _TextoState();
}

class _TextoState extends State<Texto>{
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration:InputDecoration(
          labelText:  widget.label,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        )
    );
  }
}