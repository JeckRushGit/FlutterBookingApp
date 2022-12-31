import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'navbar/custom_navbar.dart';

import 'sup/custom_text.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  bool flag = true;

  double _width = 370;
  double _height = 96;
  Color _color = Color.fromRGBO(61, 90, 128, 1);
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(24);

  String _giorno = "2" ;
  String _mese = "Jan" ;
  List<String> _arrayListMaterie = ["Algebra I","Programmazione II","Algebra I","Programmazione II"];
  List<String> _arrayListOrari = ["15:00","17:00", "15:00","17:00"];

  /*List<Row> getRowList(){
    List<Row> _rowList = [];

    for(int i=0; i < _arrayListMaterie.length ;i++){
      var newRow = Row(children: [
        Icon(
          Iconsax.blend5,
          color: Color.fromRGBO(41, 50, 65, 1),
          size: 14,
        ),
        CustomText(
          text: _arrayListOrari[i] + " - "+ _arrayListMaterie[i] ,
          size: 15,
          weight: FontWeight.w600,
          color: Colors.white,
        )
      ]);

      _rowList.add(newRow);
    }

    return _rowList;
  }*/


  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 3,
        child: Scaffold(
      body:  Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1200),
            reverseDuration: const Duration(milliseconds: 700),
            transitionBuilder: (child , animation) => SizeTransition(sizeFactor: CurvedAnimation( curve: Curves.easeOutExpo, parent: animation),axis: Axis.vertical,axisAlignment: 1, child: Center(child: child),),
            child: flag ?
            Container(
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
                          text:  _mese ,
                          size: 18,
                          weight: FontWeight.w100,
                          color: Colors.white,
                        )
                      ],
                    ),),
                  SizedBox(width: 55),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(int i=0; i < _arrayListMaterie.length ;i++)
                        if(i<3)
                          Row( children: [
                        Icon(
                          Iconsax.blend5,
                          color: Color.fromRGBO(41, 50, 65, 1),
                          size: 14,
                        ),
                        CustomText(
                          text: _arrayListOrari[i] + " - "+ _arrayListMaterie[i] ,
                          size: 15,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        )
                      ]),
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
                  )
                ],
              ),
              )
            ) :
            Container(
                key: Key('2'),
                width: _width,
                height: _height*5,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: _borderRadius,
              ),
            )
            ,
          ),
          ElevatedButton(
            child: const Text('Change'),
            onPressed: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ]
        )
      ),
      bottomNavigationBar: CustomNavBar(barColor: Color.fromRGBO(41, 50, 65, 1)),
    )
    );
  }
}




/*

AnimatedContainer(
            // Use the properties stored in the State class.
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: _borderRadius,
            ),
            // Define how long the animation should take.
            duration: const Duration(seconds: 1),
            // Provide an optional curve to make the animation feel smoother.
            curve: Curves.fastOutSlowIn,
            child: TextButton(
              onPressed: () {
                setState(() {
                  // Create a random number generator.
                  final random = Random();

                  // Generate a random width and height.
                  _width = 370;
                  //_width = random.nextInt(300).toDouble();
                  _height = 438;
                  //_height = random.nextInt(300).toDouble();

                }
                );
              },
              child: Text('TextButton'),
            ),
          )

* */