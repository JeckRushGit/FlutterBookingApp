import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomText extends StatelessWidget {
  final String text;
  final FontWeight? weight;
  final double? size;
  final Color? color;
  final TextAlign? align;
  final TextOverflow overflow;

  const CustomText({Key? key,required this.text,this.weight,this.size,this.color,this.align,this.overflow = TextOverflow.clip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: overflow, //overflow: TextOverflow.ellipsis,
      text,
      textAlign: align,
      style: GoogleFonts.montserrat(fontWeight: weight,fontSize: size,color: color),
    );
  }
}