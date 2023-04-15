import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:progetto_ium/main.dart';

import '../calendarpage/controller/calendarcontroller.dart';
import '../calendarpage/controller/tabcontroller.dart';
import '../custom_text.dart';
import '../homepage.dart';
import '../loginpage/login_page.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    CalendarController calendarController = Get.find();
    MyTabController tabController = Get.find();
    return MaterialButton(
      elevation: 7.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      color: const Color.fromRGBO(41, 50, 65, 1),
      padding: const EdgeInsets.all(20),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceAround,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                      size: 22,
                      text: "Confirm logout?"),
                ],
              ),
              actions: [
                IconButton(icon : const Icon(Iconsax.close_circle,size: 40,),color: Colors.red,onPressed: (){Navigator.pop(context);},),
                IconButton(icon : const Icon(Iconsax.tick_circle,size: 40,),color: Colors.green,onPressed: (){
                  Get.deleteAll();
                  Navigator.pop(context);
                  const FlutterSecureStorage _storage = FlutterSecureStorage();
                  _storage.deleteAll();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MyApp()));}),
              ],
            ));

      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 15),
          const CustomText(
              text: "Log Out",
              color: Colors.white,
              weight: FontWeight.normal),
          const SizedBox(width: 20),
          const Icon(
            Iconsax.logout,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}