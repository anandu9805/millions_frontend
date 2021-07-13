import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:millions/constants/colors.dart';

class InputField extends StatefulWidget {
  final String labeltext;
  final bool isEnabled;
  final TextEditingController myController;
  //const InputField({ Key? key }) : super(key: key);
  InputField(this.labeltext, this.myController, this.isEnabled);
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    //String labeltext='Hai';
    return TextFormField(
      controller :widget.myController,
      cursorColor: primary,
      readOnly: widget.isEnabled,
      decoration: InputDecoration(
        labelText: widget.labeltext,
        labelStyle: GoogleFonts.ubuntu(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primary,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primary,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
      ),
    );
  }
}