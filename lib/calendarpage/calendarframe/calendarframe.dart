// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../colors/hexcolor.dart';
import '../../custom_text.dart';
import '../../main.dart';
import '../controller/calendarcontroller.dart';
import '../controller/tabcontroller.dart';
import 'frametabbar.dart';
import 'tabviews.dart';

class CalendarFrame extends StatelessWidget {
  late MyTabController _tabController;
  late CalendarController _calendarController;
  final List<int> days;
  final int month;

  CalendarFrame({Key? key, required this.days, required this.month})
      : super(key: key);



  void _showPopUpLogin(){
    showDialog(
        context: _calendarController.context,
        builder: (context) => AlertDialog(
          actionsAlignment:
          MainAxisAlignment.spaceAround,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(24))),
          content: CustomText(
              text: _calendarController.user != null ?
              'Log in as user to reserve a lesson' : 'Log into your account to reserve a lesson'),
          actions: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      24)),
              color:
              HexColor.fromHex("#293241"),
              onPressed: () {
                const FlutterSecureStorage _storage = FlutterSecureStorage();
                _storage.deleteAll();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyApp()));
                Get.deleteAll();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                      text: "Login",
                      color: Colors.white,
                      weight: FontWeight.w700),
                  const SizedBox(width: 20),
                  Icon(
                    Iconsax.login,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ));
  }


  @override
  Widget build(BuildContext context) {
    try {
      _tabController = Get.find();
      _calendarController = Get.find();

      return Obx(() {

          List<Widget>? views = ViewsGenerator(days: days).views;
          return Container(
            decoration: BoxDecoration(
                color: HexColor.fromHex("#4E5F7D"),
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Column(children: [
              SizedBox(
                  height: 50,
                  child: FrameTabBar(
                      controller: _tabController.controller, days: days)),
              Expanded(
                  child: _calendarController.user != null && _calendarController.user!.role == 'Client'
                      ? TabBarView(
                          controller: _tabController.controller,
                          children: views!)
                      : Stack(
                          children: [
                            TabBarView(
                                controller: _tabController.controller,
                                children: views!),
                            GestureDetector(
                              onTap: () {
                                _showPopUpLogin();
                              },
                              child: Container(
                                width: double.maxFinite,
                                height: double.maxFinite,
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ))
            ]),
          );

      });
    } catch (e) {
      print('Errore nel calendar frame con i controller : $e');
      return const Placeholder();
    }
  }
}
