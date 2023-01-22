import 'package:flutter/material.dart';
import '../custom_text.dart';
import '../navbar/custom_navbar.dart';
import 'agenda_menu.dart';
import 'list_elem.dart';


class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> with TickerProviderStateMixin {

  List<String> _arrayGiorniLezioni = [ "1" , "2" , "3" ];
  List<String> _arrayGiorniLezioniNextW = [ "1" , "2" ];

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
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
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 27),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "This Week",
                      size: 22,
                      weight: FontWeight.w500,
                      color: Color.fromRGBO(111, 111, 111, 1),
                    ),),
                ),
                Spacer(flex: 3),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: AgendaMenu(),
                ),
                Spacer(flex: 1),
              ],
            ),
            Center(
              child: Column(
                children: [
                  for(int i=0; i< _arrayGiorniLezioni.length ;i++)
                  //if(_arrayGiorniLezioniNextW.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: ListElem(),
                    ),
                ],
              ),
            ),
            const Padding(
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
            ),
          ],
        ),
      );
  }
}