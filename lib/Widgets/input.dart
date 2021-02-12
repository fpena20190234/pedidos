import 'package:flutter/material.dart';
class Input extends StatefulWidget{
  final String label;
  final Function(String) validator;
  final   VoidCallback onEditingComplete;
  final FocusNode focusNode;

  final bool esOculto;
  final TextInputType inputType;
  final TextEditingController textEditingController;
  const Input({Key key,@required this.label,this.validator,this.esOculto=false, this.inputType=TextInputType.text, this.textEditingController, this.onEditingComplete, this.focusNode}) : super(key: key);

  @override
  _InputState createState()=> _InputState();
  }

  class _InputState extends State<Input>{
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      controller: widget.textEditingController,
      keyboardType: widget.inputType,
      obscureText: widget.esOculto,
      validator: widget.validator,
      decoration:InputDecoration(
          labelText:  widget.label,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
      )
    );
  }
}