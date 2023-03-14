import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:progetto_ium/modules/course.dart';
import 'package:progetto_ium/modules/professor.dart';
import 'package:progetto_ium/modules/user.dart';
import 'package:http/http.dart' as http;
import '../colors/hexcolor.dart';
import '../custom_text.dart';
import '../startingday.dart';

class RettangoloPrenotazione extends StatefulWidget {
  final String hour;
  final int day;
  final double width;
  final double heigth;
  bool prenotata;
  final String topText;
  final String bottomText;
  final User user;
  final Course course;
  final Professor professor;
  late BoxDecoration _deco;
  final Function callBackReload;

  RettangoloPrenotazione(
      {super.key,
      required this.hour,
      required this.day,
      required this.prenotata,
      required this.width,
      required this.heigth,
      required this.topText,
      required this.user,
      required this.course,
      required this.professor,
      required this.callBackReload,
      this.bottomText = ""}) {
    if (prenotata) {
      deco = BoxDecoration(
          boxShadow: kElevationToShadow[2],
          image: const DecorationImage(
              image: AssetImage("frame.png"), fit: BoxFit.cover),
          borderRadius: const BorderRadius.all(Radius.circular(24)));
    } else {
      deco = BoxDecoration(
          boxShadow: kElevationToShadow[2],
          color: HexColor.fromHex("#7CC69E"),
          borderRadius: const BorderRadius.all(Radius.circular(24)));
    }
  }

  set deco(BoxDecoration deco) {
    _deco = deco;
  }

  @override
  State<RettangoloPrenotazione> createState() => _RettangoloPrenotazioneState();
}

class _RettangoloPrenotazioneState extends State<RettangoloPrenotazione> {
  void _changeState() async {
    if (!widget.prenotata) {
      try {
        bool val = await _bookTeaching(widget.course, widget.professor,
            widget.user, widget.day, 1, widget.hour);
        if (val) {
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: CustomText(text: "Lezione prenotata con successo"),
                  ));
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: CustomText(text: e.toString()),
                ));
        widget.callBackReload();
      }
      setState(() {
        widget.prenotata = true;
        widget.deco = BoxDecoration(
            boxShadow: kElevationToShadow[2],
            image: const DecorationImage(
                image: AssetImage("frame.png"), fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(24)));
      });
    }
  }

  void _popUpConf() {
    if(!widget.prenotata){
      List<String> splittedString = widget.hour.split("-");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceAround,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            content: CustomText(
                size: 22,
                text: "Sei sicuro di voler prenotare la lezione di ${widget.course.course_titol} tenuta da ${widget.professor.toStringDropDown()} il ${widget.day}/1 dalle ${splittedString[0]} alle ${splittedString[1]} ?"),
            actions: [
              IconButton(icon : const Icon(Iconsax.close_circle,size: 40,),color: Colors.red,onPressed: (){Navigator.pop(context);},),
              IconButton(icon : const Icon(Iconsax.tick_circle,size: 40,),color: Colors.green,onPressed: (){
                Navigator.pop(context);
                _changeState();}),
            ],
          ));
    }
  }

  Future<bool> _bookTeaching(Course course, Professor professor, User user,
      int day, int month, String hour) async {
    var response = await http.post(
      Uri.parse(
          "$ip/ServletBookTeaching"),
      body: jsonEncode(<String, String>{
        'course_titol': course.course_titol,
        'professor_email': professor.email,
        'user_email': user.email,
        'day': day.toString(),
        'hour': hour.toString(),
        'month': month.toString()
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      throw "lezione non disponibile";
    } else if(response.statusCode == 406){
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: CustomText(text: "Wait for a minute  "),
          ));
    }else if (response.statusCode == 500) {
      print("errore con il server QUA");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: (){
        _popUpConf();
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 100),
        height: widget.heigth,
        width: widget.width,
        decoration: widget._deco,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: const Offset(-45, -10),
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: CustomText(
                    text: widget.topText,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Transform.translate(
                offset: const Offset(-45, 40),
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: CustomText(
                    text: widget.bottomText,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
