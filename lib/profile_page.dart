import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'navbar/custom_navbar.dart';

import 'navbar/custom_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nome = "Nome Cognome";
  String _email = "sample@email.com";
  String _birthday = "01/01/2000";
  String _profileType = "Student";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                const Spacer(flex: 3),
                CustomText(
                  text: "Profile",
                  size: 30,
                  weight: FontWeight.bold,
                  color: Color.fromRGBO(41, 50, 65, 1),
                ),
                const Spacer(flex: 3),
                CustomText(
                  text: _nome,
                  size: 26,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
                const Spacer(flex: 1),
                Container(
                  child: Column(
                    children: [
                      CustomText(
                        text: "Email:  " + _email,
                        size: 18,
                        weight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      CustomText(
                        text: "Birthday:  " + _birthday,
                        size: 18,
                        weight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      CustomText(
                        text: "Profile Type:  " + _profileType,
                        size: 18,
                        weight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                MaterialButton(
                  elevation: 7.5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Color.fromRGBO(41, 50, 65, 1),
                  padding: EdgeInsets.all(13),
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                          text: "Log Out",
                          color: Colors.white,
                          weight: FontWeight.w700),
                      SizedBox(width: 20),
                      Icon(
                        Iconsax.logout,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ])),
          bottomNavigationBar:
              CustomNavBar(barColor: Color.fromRGBO(41, 50, 65, 1)),
        ));
  }
}
