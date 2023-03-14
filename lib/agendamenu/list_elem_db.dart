import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:progetto_ium/modules/course.dart';

import '../custom_text.dart';
import '../modules/user.dart';
import 'agendapage.dart';
import 'button_for_slidable.dart';

import 'package:http/http.dart' as http;
import '../startingday.dart';


class ListElemDb extends StatefulWidget {
  Map<KeyLezione, List<Lezione>> map;
  KeyLezione date;
  User user;
  bool slidable_enabled;
  ListElemDb({Key? key, required this.map, required this.date, required this.user, required this.slidable_enabled }) : super(key: key);

@override
State<ListElemDb> createState() => _ListElemDbState();
}

class _ListElemDbState extends State<ListElemDb> {
  bool flag = true;
  double _width = 370;
  double _height = 96;
  Color _color = Color.fromRGBO(61, 90, 128, 1);
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(24);

  late String _giorno;
  late String _meseAbb;
  late String _mese;
  late List<Lezione> _arrayLezione;

  callbackData(_arrayLezione, i ) async { //non ci sono i tipi per io parametri, da testare se funziona con i tipi segnati
    bool result = await dbSetUp("cancel", _arrayLezione[i]);
    if(result == true){
      setState(() {
        //this._arrayLezione=_arrayLezione;
        this._arrayLezione.removeAt(i);
      });
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: CustomText(text: "Your lesson was canceled!"),
          ));
    }else{
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: CustomText(text: "Your lesson was NOT canceled, try again later"),
          ));
    }

  }

  String getMonth(int num){
    String month = "";
    switch (num){
      case 1:
        if(num == 1){
          month = "January";
        }
        break;
      case 2:
        if(num == 2){
          month = "February";
        }
        break;
      case 3:
        if(num == 3){
          month = "March";
        }
        break;
      case 4:
        if(num == 4){
          month = "April";
        }
        break;
      case 5:
        if(num == 5){
          month = "May";
        }
        break;
      case 6:
        if(num == 6){
          month = "June";
        }
        break;
      case 7:
        if(num == 7){
          month = "July";
        }
        break;
      case 8:
        if(num == 8){
          month = "August";
        }
        break;
      case 9:
        if(num == 9){
          month = "September";
        }
        break;
      case 10:
        if(num == 10){
          month = "October";
        }
        break;
      case 11:
        if(num == 11){
          month = "November";
        }
        break;
      case 12:
        if(num == 12){
          month = "December";
        }
        break;
      default:
        month = "Month";
    }
    return month;
  }

  String getMonthAbb(int num){
    String month = "";
    switch (num){
      case 1:
        if(num == 1){
          month = "Jan";
        }
        break;
      case 2:
        if(num == 2){
          month = "Feb";
        }
        break;
      case 3:
        if(num == 3){
          month = "Mar";
        }
        break;
      case 4:
        if(num == 4){
          month = "Apr";
        }
        break;
      case 5:
        if(num == 5){
          month = "May";
        }
        break;
      case 6:
        if(num == 6){
          month = "Jun";
        }
        break;
      case 7:
        if(num == 7){
          month = "Jul";
        }
        break;
      case 8:
        if(num == 8){
          month = "Aug";
        }
        break;
      case 9:
        if(num == 9){
          month = "Sep";
        }
        break;
      case 10:
        if(num == 10){
          month = "Oct";
        }
        break;
      case 11:
        if(num == 11){
          month = "Nov";
        }
        break;
      case 12:
        if(num == 12){
          month = "Dec";
        }
        break;
      default:
        month = "";
    }
    return month;
  }


  @override
  void initState() {
    super.initState();

    _giorno = widget.date.day;
    _mese = getMonth(int.parse(widget.date.month));
    _meseAbb = getMonthAbb(int.parse(widget.date.month));

    _arrayLezione = widget.map[widget.date]!;
    _arrayLezione.sort((a, b) => a.compareTo(b));

  }

  Future<bool> dbSetUp(String cambio, Lezione lezione) async {
    if(cambio == "confirm"){
      var response = await http.post(Uri.parse("$ip/ServletSetBookings"), body: {"email_professore": lezione.professor.email,"email_utente": widget.user.email,"corso": lezione.course.course_titol,"giorno": widget.date.day,"mese": widget.date.month,"orario":  lezione.hour,"stato": "2"});

      if (response.statusCode == 200) {
        return true;
      }else{
        return false;
      }
    }
    else if(cambio == "cancel"){
      var response = await http.post(Uri.parse("$ip/ServletSetBookings"), body: {"email_professore": lezione.professor.email,"email_utente": widget.user.email,"corso": lezione.course.course_titol,"giorno": widget.date.day,"mese": widget.date.month,"orario":  lezione.hour,"stato": "3"});

      if (response.statusCode == 200) {
        return true;
      }else{
        return false;
      }
    }
    else{
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1200),
      reverseDuration: const Duration(milliseconds: 700),
      transitionBuilder: (child , animation) => SizeTransition(sizeFactor: CurvedAnimation( curve: Curves.easeOutExpo, parent: animation),axis: Axis.vertical,axisAlignment: 1, child: Center(child: child),),
      child: flag ?
      Container(
          clipBehavior: Clip.hardEdge,
          key: Key('1'),
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: _borderRadius,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(9, 10, 0, 0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(9, 5, 9, 9),
                  child: Column(
                    children: [
                      CustomText(
                        text: _giorno ,
                        size: 32,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      CustomText(
                        text:  _meseAbb ,
                        size: 18,
                        weight: FontWeight.w100,
                        color: Colors.white,
                      )
                    ],
                  ),),
                //SizedBox(width: 55),
                Spacer(flex: 2,),
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(int i=0; i < _arrayLezione.length ;i++)
                        if(i<3)
                          Row( children: [
                            const Icon(
                              Iconsax.blend5,
                              color: Color.fromRGBO(41, 50, 65, 1),
                              size: 14,
                            ),
                            Expanded(
                              flex: 1,
                              child: CustomText(
                                text: _arrayLezione[i].hour + ": "+ _arrayLezione[i].course.course_titol ,
                                size: 15,
                                weight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            )
                          ]),
                      if(_arrayLezione.isNotEmpty)
                        Flexible(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  flag = !flag;
                                });
                              },
                              child: const CustomText(
                                text: "..." ,
                                size: 18,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              )
                          ),
                        )
                    ],
                  ),
                ),
                Spacer(flex: 1,),
              ],
            ),
          )
      ) :
      Container(
        clipBehavior: Clip.hardEdge,
        key: Key('2'),
        width: _width,
        //height: (_height*5)-20,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: _borderRadius,
        ),
        child: SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          closeWhenTapped: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    splashRadius: 2.0,
                    icon: const Icon(
                      Iconsax.close_circle5,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        flag = !flag;
                      });
                    },
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Column(
                    children: [
                      CustomText(
                        text: _giorno ,
                        size: 32,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      CustomText(
                        text:  _mese ,
                        size: 18,
                        weight: FontWeight.w100,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              for(int i=0; i < _arrayLezione.length ;i++)
                //if(i<4)
                  Slidable(
                    enabled: widget.slidable_enabled,
                    startActionPane: ActionPane(
                      motion: StretchMotion(), children: [
                      SlidableAction(
                        onPressed: (context) async {
                          bool result = await dbSetUp("confirm", _arrayLezione[i]);
                          if(result == true){
                            //toglie dalla lista
                            setState(() {
                              _arrayLezione.removeAt(i);
                            });
                            showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  title: CustomText(text: "Your lesson was confirmed!"),
                                ));
                          }else{
                            showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  title: CustomText(text: "Your lesson was NOT confirmed, try again later"),
                                ));
                          }
                        },
                        backgroundColor: Colors.green,
                        icon: Icons.check,
                        autoClose: true,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          //toglie dalla lista
                          showDialog(context: context, builder: (context) => ButtonSlidableResponse(_arrayLezione, i, callback: callbackData));
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        autoClose: true,
                      ),
                    ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 10, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if(widget.slidable_enabled)
                                const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey,
                                  size: 14,
                                ),
                              SizedBox(width: 20),
                              const Icon(
                                Iconsax.blend5,
                                color: Color.fromRGBO(41, 50, 65, 1),
                                size: 14,
                              ),
                              Expanded(
                                flex: 12,
                                child: CustomText(
                                  text: _arrayLezione[i].hour ,
                                  size: 15,
                                  weight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(flex: 2),
                              Expanded(
                                flex: 12,
                                child: CustomText(
                                  text: _arrayLezione[i].course.course_titol,
                                  size: 15,
                                  weight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(flex: 2),
                            ],
                          ),
                          const SizedBox(height: 15,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              text: "Prof.: " + _arrayLezione[i].professor.name,
                              size: 15,
                              weight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                          const Divider(
                              color: Colors.white
                          ),
                        ],
                      ),
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}