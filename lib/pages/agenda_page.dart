import 'package:flutter/material.dart';
import 'package:progetto_ium/sup/agenda_menu.dart';
import 'package:progetto_ium/sup/custom_text.dart';
import 'package:progetto_ium/sup/list_elem.dart';
import '../navbar/custom_navbar.dart';


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
    return  DefaultTabController(
        length: 3,
        child: Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Padding(
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
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 27),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "This Week",
                      size: 22,
                      weight: FontWeight.w500,
                      color: Color.fromRGBO(111, 111, 111, 1),
                    ),),
                ),
                const Spacer(flex: 3),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: AgendaMenu(),
                ),
                const Spacer(flex: 1),
              ],
            ),
            Center(
              child: Column(
                children: [
                      for(int i=0; i< _arrayGiorniLezioni.length ;i++)
                        //if(_arrayGiorniLezioniNextW.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: ListElem(),
                          ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 37, 0, 27),
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListElem(),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(barColor: Color.fromRGBO(41, 50, 65, 1)),
    )
    );
  }
}