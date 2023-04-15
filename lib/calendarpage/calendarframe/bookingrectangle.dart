import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../colors/hexcolor.dart';
import '../../custom_text.dart';
import '../../modules/course.dart';
import '../../modules/professor.dart';
import '../controller/calendarcontroller.dart';


class BookingRectangle extends StatelessWidget {
  Map<String,dynamic>? bookingsInfo;
  late BoxDecoration decoration;
  CalendarController controller;
  String topText;
  String bottomText;
  final bool showOnlyTop;

  BookingRectangle({Key? key, required this.bookingsInfo,required this.topText,required this.bottomText,required this.controller, required this.showOnlyTop}) : super(key: key);



  void onTapRectangle(BuildContext context){


    Course course = Course.fromJson(bookingsInfo!['course']);
    Professor professor = Professor.fromJson(bookingsInfo!['professor']);
    showDialog(
        context: controller.context,
        builder: (context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24))),
          content: CustomText(
              size: 22,
              text:
              "Sei sicuro di voler prenotare la lezione di ${course.course_titol} tenuta da ${professor.toStringDropDown()} il ${bookingsInfo!['day']}/${bookingsInfo!['month']} dalle $topText alle $bottomText ?"),
          actions: [
            IconButton(
              icon: const Icon(
                Iconsax.close_circle,
                size: 40,
              ),
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
                icon: const Icon(
                  Iconsax.tick_circle,
                  size: 40,
                ),
                color: Colors.green,
                onPressed: () async{
                  Navigator.pop(controller.context);
                  bool ok = await controller.bookLesson(course, professor, controller.user!, bookingsInfo!['day'],bookingsInfo!['month'] , bookingsInfo!['hour']);
                  if(ok){
                    showDialog(
                        context: controller.context,
                        builder: (context) => const AlertDialog(
                          title: CustomText(text :"Lesson reserved"),
                        ));
                  }
                }),
          ],
        ));
  }



  @override
  Widget build(BuildContext context) {

    if (bookingsInfo == null) {
      decoration = BoxDecoration(
          boxShadow: kElevationToShadow[2],
          image: const DecorationImage(
              image: AssetImage("frame.png"), fit: BoxFit.cover),
          borderRadius: const BorderRadius.all(Radius.circular(24)));
    } else {
      decoration = BoxDecoration(
          color: HexColor.fromHex("#7CC69E"),
          borderRadius: const BorderRadius.all(Radius.circular(24)));
    }

    return Flexible(
      child: InkWell(
        onTap: (){
          if(bookingsInfo != null && controller.user != null){
            onTapRectangle(context);
          }
        },
        child: Container(
            constraints: const BoxConstraints(maxHeight: 100),
            decoration: decoration,
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
                    text: topText,
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
                    text: showOnlyTop ? '' : bottomText,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),),
      ),
    );
  }
}