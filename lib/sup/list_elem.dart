import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'button_for_slidable.dart';
import 'custom_text.dart';

class ListElem extends StatefulWidget {
  const ListElem({Key? key, required}) : super(key: key);

  @override
  State<ListElem> createState() => _ListElemState();
}

class _ListElemState extends State<ListElem> {
  bool flag = true;

  double _width = 370;
  double _height = 96;
  Color _color = Color.fromRGBO(61, 90, 128, 1);
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(24);

  //Da fare:
  //Da prendere dal DB
  String _giorno = "2" ;
  String _meseAbb = "Jan" ;
  String _mese = "January" ;
  List<String> _arrayListMaterie = ["Algebra I","Programmazione II","Algebra I","Prog III"];
  List<String> _arrayListOrari = ["15:00","17:00", "15:00","17:00"];
  List<String> _arrayListProf = ["Mario Rossi","Eduardo Correia", "Ardissono","Cardone Felice"];


  callbackData(_arrayListMaterie,_arrayListOrari,_arrayListProf ){
    setState(() {
      this._arrayListMaterie=_arrayListMaterie;
      this._arrayListOrari = _arrayListOrari;
      this._arrayListProf = _arrayListProf;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AnimatedSwitcher(
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
                          for(int i=0; i < _arrayListMaterie.length ;i++)
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
                                    text: _arrayListOrari[i] + " - "+ _arrayListMaterie[i] ,
                                    size: 15,
                                    weight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )
                              ]),
                          if(_arrayListMaterie.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  flag = !flag;
                                });
                              },
                              child: CustomText(
                                text: "..." ,
                                size: 18,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              )
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
            height: (_height*5)-20,
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
                  for(int i=0; i < _arrayListMaterie.length ;i++)
                    if(i<4)
                      Slidable(
                        startActionPane: ActionPane(
                          motion: StretchMotion(), children: [
                          SlidableAction(
                            onPressed: (context) {
                              //toglie dalla lista
                              //_arrayListMaterie _arrayListOrari  _arrayListProf
                              setState(() {
                                _arrayListMaterie.removeAt(i);
                                _arrayListOrari.removeAt(i);
                                _arrayListProf.removeAt(i);
                              });

                              //Da fare: manca il codice per aggiornare il db

                            },
                            backgroundColor: Colors.green,
                            icon: Icons.check,
                            autoClose: true,
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              //toglie dalla lista
                              showDialog(context: context, builder: (context) => ButtonSlidableResponse(_arrayListMaterie, _arrayListOrari,  _arrayListProf, i, callback: callbackData));
                              //Da fare: manca il codice per aggiornare il db
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
                                      text: _arrayListOrari[i] + " - "+ _arrayListOrari[i] ,
                                      size: 15,
                                      weight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(flex: 2),
                                  Expanded(
                                    flex: 12,
                                    child: CustomText(
                                      text: _arrayListMaterie[i],
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
                                child: Expanded(
                                  flex: 1,
                                  child: CustomText(
                                    text: "Prof.:  " + _arrayListProf[i],
                                    size: 15,
                                    weight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Divider(
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
        ),
    );
  }
}
