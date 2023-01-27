import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:progetto_ium/main.dart';

import '../custom_text.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 7.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      color: Color.fromRGBO(41, 50, 65, 1),
      padding: EdgeInsets.all(20),
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
                  CustomText(
                      size: 22,
                      text: "Confirm logout?"),
                ],
              ),
              actions: [
                IconButton(icon : const Icon(Iconsax.close_circle,size: 40,),color: Colors.red,onPressed: (){Navigator.pop(context);},),
                IconButton(icon : const Icon(Iconsax.tick_circle,size: 40,),color: Colors.green,onPressed: (){
                  Navigator.pop(context);
                  storage.write(key: "jwt",value: null);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));}),
              ],
            ));

      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 15),
          CustomText(
              text: "Log Out",
              color: Colors.white,
              weight: FontWeight.normal),
          SizedBox(width: 20),
          Icon(
            Iconsax.logout,
            color: Colors.white,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}