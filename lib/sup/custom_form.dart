import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class CustomForm extends StatefulWidget {
  final String label;
  final String hint;
  TextInputType? inputType;
  Icon? icon;
  Color textFieldColor;
  bool obscure;
  TextEditingController? controller;

  CustomForm(
      {Key? key,
        this.controller,
      required this.label,
      required this.hint,
      this.inputType,
      this.icon,
      this.textFieldColor = Colors.white,
      this.obscure = false})
      : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  String? font = GoogleFonts.montserrat().fontFamily;


  @override
  void dispose(){
    widget.controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscure,
      style: TextStyle(color: widget.textFieldColor,fontFamily: font),
      keyboardType: widget.inputType,
      decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.white60, fontFamily: font),
          labelStyle: TextStyle(color: Colors.white, fontFamily: font),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          icon: widget.icon,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white60, width: 1.5)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5))),
    );
  }
}
