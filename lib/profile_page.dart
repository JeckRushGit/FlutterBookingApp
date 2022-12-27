import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:iconsax/iconsax.dart';
import 'package:progetto_ium/pages/login_page.dart';
import 'navbar/custom_navbar.dart';

import 'sup/custom_text.dart';

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
                    ),CustomText(
                  text:  _email ,
                  size: 18,
                  weight: FontWeight.normal,
                  color: Colors.black,
                )]),
                Row(
                    children: [CustomText(
                      text: "Birthday:  " ,
                      size: 18,
                      weight: FontWeight.bold,
                      color: Colors.black,
                    ),CustomText(
                      text:  _birthday ,
                      size: 18,
                      weight: FontWeight.normal,
                      color: Colors.black,
                    )]),
                Row(
                    children: [CustomText(
                      text: "Profile Type:  " ,
                      size: 18,
                      weight: FontWeight.bold,
                      color: Colors.black,
                    ),CustomText(
                      text:  _profileType ,
                      size: 18,
                      weight: FontWeight.normal,
                      color: Colors.black,
                    )]),
              ],
            ),
          ),
          const Spacer(flex: 8),
          MaterialButton(
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
          ),
          const Spacer(flex: 1),
        ]
        )
      ),
      bottomNavigationBar: CustomNavBar(barColor: Color.fromRGBO(41, 50, 65, 1)),
    )
    );
  }
}
