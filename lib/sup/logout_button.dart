import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../pages/login_page.dart';
import 'custom_text.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 7.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      color: Color.fromRGBO(41, 50, 65, 1),
      padding: EdgeInsets.all(20),
      onPressed: () {
        showDialog(context: context, builder: (context) => AlertDialog(
          titlePadding: EdgeInsets.all(30),
          title: CustomText(
            text:  "Are you sure you want to log out?" ,
            size: 20,
            weight: FontWeight.bold,
            color: Colors.black,
          ),
          backgroundColor: Color.fromRGBO(220, 220, 220, 1),
          content: Row(
            children: [
              SizedBox(width: 15),
              MaterialButton(
                elevation: 7.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Color.fromRGBO(41, 50, 65, 1),
                padding: EdgeInsets.all(20),
                onPressed: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 15),
                    CustomText(
                        text: "No",
                        size: 22,
                        color: Colors.white,
                        weight: FontWeight.bold),
                    SizedBox(width: 20),
                    CustomText(
                        text: "X",
                        size: 34,
                        color: Colors.red,
                        weight: FontWeight.bold),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(width: 70),
              MaterialButton(
                elevation: 7.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Color.fromRGBO(41, 50, 65, 1),
                padding: EdgeInsets.all(20),
                onPressed: () {
                  /*Invia alla pagina di Login*/
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LoginPage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 15),
                    CustomText(
                        text: "Yes",
                        size: 22,
                        color: Colors.white,
                        weight: FontWeight.bold),
                    SizedBox(width: 20),
                    CustomText(
                        text: "O",
                        size: 34,
                        color: Colors.green,
                        weight: FontWeight.bold),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
        )
        );
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
