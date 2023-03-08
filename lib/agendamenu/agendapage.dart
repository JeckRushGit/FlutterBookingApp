import 'dart:convert';

import 'package:flutter/material.dart';
import '../custom_text.dart';
import '../modules/course.dart';
import '../modules/professor.dart';
import '../modules/user.dart';
import '../navbar/custom_navbar.dart';
import 'package:http/http.dart' as http;
import '../startingday.dart';
import 'agenda_menu.dart';
import 'list_elem.dart';
import 'list_elem_db.dart';



class Lezione{
  String hour;
  Professor professor;
  Course course;

  Lezione({required this.hour,required this.professor,required this.course});

  factory Lezione.fromJson(Map<String,dynamic> json){
    return Lezione(
        hour: json["hour"],
        professor: Professor.fromJson(json["professor"]),
        course: Course.fromJson(json["course"])
    );
  }

  @override
  String toString() {
    return 'Lezione{hour: $hour, professor: $professor, course: $course}';
  }

  int compareTo(Lezione b) {
    return hour.compareTo(b.hour);
  }
}

class KeyLezione{
  String day;
  String month;

  KeyLezione({required this.day,required this.month});

  factory KeyLezione.fromJson(Map<String,dynamic> json){
    return KeyLezione(day: json["day"].toString(), month: json["month"].toString());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is KeyLezione &&
              runtimeType == other.runtimeType &&
              day == other.day &&
              month == other.month;

  @override
  int get hashCode => day.hashCode ^ month.hashCode;

  @override
  String toString() {
    return 'KeyLezione{day: $day, month: $month}';
  }

  int compareTo(KeyLezione other){
    if(this.day == other.day && this.month == other.month){
      return 0;
    }
    else if(this.month.compareTo(other.month) == 0){
      return this.day.compareTo(other.day);
    }
    else if(this.month.compareTo(other.month) > 0){
      return 1;
    }
    else if(this.month.compareTo(other.month) < 0){
      return -1;
    }
    else {
      return 0;
    }
  }

}


class AgendaPage extends StatefulWidget {
  User user;
  AgendaPage({Key? key,required this.user}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> with TickerProviderStateMixin {

  //getBookingsForUser
  late int state;
  late Stream myStream;
  late List<KeyLezione> _arrayGiorni = [];
  //List<String> _arrayGiorniLezioni = [ "1" , "2" , "3" ];


  @override
  void initState() {
    super.initState();
    state = 1;
    myStream = _getLezioni();
  }

  Stream<Map<KeyLezione, List<Lezione>>> _getLezioni() async*{
      var response = await http.post(Uri.parse("$ip/ServletGetBookingsForUser"), body: { "email": widget.user.email, "stato": state.toString()});

      List<dynamic> jsonList = jsonDecode(response.body);
      Map<KeyLezione, List<Lezione>> map = {};

        for(var riga in jsonList){
          KeyLezione k = KeyLezione.fromJson(riga);

          if(!(map.containsKey(k))){
            _arrayGiorni.add(k);

            List<Lezione> list = [Lezione.fromJson(riga)];

            map[k] = list;

          }
          else{
            List<Lezione> list = map[k]!;

            list.add(Lezione.fromJson(riga));
          }
        }


      _arrayGiorni.sort((a, b) => a.compareTo(b));  /*Per ordinare l'array di KeyLezione*/
      yield map;
  }

  void callbackMenu(String _selectedMenu){
    if(_selectedMenu == 'To Do'){
      state = 1;
    }else if(_selectedMenu == 'Checked'){
      state = 2;
      //myStream = _getLezioni();
    }else if(_selectedMenu == 'Canceled'){
      state = 3;
    }else{}

    _arrayGiorni = [];
    setState(() {

      myStream = _getLezioni();
    });
  }




  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: myStream,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          var map = snapshot.data!;
           return SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(30) ,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomText(
                        text: "Agenda",
                        size: 30,
                        weight: FontWeight.bold,
                        color: Color.fromRGBO(41, 50, 65, 1),
                      ),),),
                  Row(
                    children:[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 27),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: CustomText(
                            text: "Your lessons",
                            size: 22,
                            weight: FontWeight.w500,
                            color: Color.fromRGBO(111, 111, 111, 1),
                          ),),
                      ),
                      const Spacer(flex: 3),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: AgendaMenu(callBack: callbackMenu),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        //for(int i=0; i < _arrayGiorniLezioni.length ;i++)
                        for(int i=0; i< _arrayGiorni.length ;i++)
                        //if(_arrayGiorniLezioniNextW.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            //child: ListElem(),
                            child: ListElemDb(map: map, date: _arrayGiorni[i] ,user: widget.user,),
                          ),
                      ],
                    ),
                  ),
                  /*const Padding(
                padding: EdgeInsets.fromLTRB(30, 37, 0, 27),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomText(
                    text: "Next Week",
                    size: 22,
                    weight: FontWeight.w500,
                    color: Color.fromRGBO(111, 111, 111, 1),
                  ),),
              ),
              Center(
                child: Column(
                  children: [
                    for(int i=0; i< _arrayGiorniLezioniNextW.length ;i++)
                    //if(_arrayGiorniLezioniNextW.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListElem(),
                      ),
                  ],
                ),
              ),*/
                ],
              ),
            );
        }else{

          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}