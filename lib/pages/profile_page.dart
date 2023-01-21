import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:iconsax/iconsax.dart';
import 'package:progetto_ium/pages/login_page.dart';
import '../navbar/custom_navbar.dart';

import '../sup/custom_text.dart';
import '../sup/logout_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nome = "Nome Cognome";
  String  _email = "sample@email.com";
  String  _birthday = "01/01/2000";
  String  _profileType = "Student";
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 3,
        child: Scaffold(
      body:  Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(flex: 1),
          Padding(
              padding: EdgeInsets.all(30) ,
              child: Align(
            alignment: Alignment.topLeft,
            child: CustomText(
              text: "Profile",
              size: 30,
              weight: FontWeight.bold,
              color: Color.fromRGBO(41, 50, 65, 1),
            ),),),
          const Spacer(flex: 1),
          Image.asset("img/profile.png"),
          const Spacer(flex: 1),
          CustomText(
            text: _nome,
            size: 26,
            weight: FontWeight.bold,
            color: Colors.black,
          ),
          const Spacer(flex: 1),
          Container(
            width: 300,
            child: Column(
              children: [
                Divider(
                    color: Colors.black
                ),
                Row(
                    children: [CustomText(
                      text: "Email: " ,
                      size: 18,
                      weight: FontWeight.bold,
                      color: Colors.black,
                    ),Expanded(
                      flex: 1,
                      child: CustomText(
                  text:  _email ,
                  size: 18,
                  weight: FontWeight.normal,
                  color: Colors.black,
                ),
                    )]),
                Row(
                    children: [CustomText(
                      text: "Birthday:  " ,
                      size: 18,
                      weight: FontWeight.bold,
                      color: Colors.black,
                    ),Expanded(
                      flex: 1,
                      child: CustomText(
                        text:  _birthday ,
                        size: 18,
                        weight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    )]),
                Row(
                    children: [CustomText(
                      text: "Profile Type:  " ,
                      size: 18,
                      weight: FontWeight.bold,
                      color: Colors.black,
                    ),Expanded(
                      flex: 1,
                      child: CustomText(
                        text:  _profileType ,
                        size: 18,
                        weight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    )]),
              ],
            ),
          ),
          const Spacer(flex: 8),
          LogoutButton(),
          const Spacer(flex: 1),
        ]
        )
      ),
      bottomNavigationBar: CustomNavBar(barColor: Color.fromRGBO(41, 50, 65, 1)),
    )
    );
  }
}
