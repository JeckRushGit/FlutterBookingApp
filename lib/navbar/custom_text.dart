import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  FontWeight? weight;
  double? size;
  Color? color;
  TextAlign? align;

  CustomText(
      {Key? key,
      required this.text,
      this.weight,
      this.size,
      this.color,
      this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.montserrat(
          fontWeight: weight, fontSize: size, color: color),
    );
  }
}
