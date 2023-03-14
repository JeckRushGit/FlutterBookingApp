import 'package:flutter/material.dart';
import 'package:progetto_ium/custom_text.dart';

import '../modules/user.dart';
import 'logoutbutton.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({Key? key,required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return  Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //const Spacer(flex: 2),
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      overflow: TextOverflow.ellipsis,
                      text: "Profile",
                      size: 30,
                      weight: FontWeight.bold,
                      color: Color.fromRGBO(41, 50, 65, 1),
                    ),),),
                const Spacer(flex: 1),
                Image.asset("profile.png"),
                const Spacer(flex: 1),
                CustomText(
                  overflow: TextOverflow.ellipsis,
                  text: "${widget.user.name} ${widget.user.surname}",
                  size: 26,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
                const Spacer(flex: 1),
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      const Divider(
                          color: Colors.black
                      ),
                      Row(
                          children: [const CustomText(
                            text: "Email: " ,
                            size: 18,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          ),Expanded(
                            flex: 1,
                            child: CustomText(
                              text:  widget.user.email,
                              size: 18,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          )]),
                      Row(
                          children: [const CustomText(
                            text: "Birthday:  " ,
                            size: 18,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          ),Expanded(
                            flex: 1,
                            child: CustomText(
                              text:  widget.user.birthday,
                              size: 18,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          )]),
                      Row(
                          children: [const CustomText(
                            text: "Profile Type:  " ,
                            size: 18,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          ),Expanded(
                            flex: 1,
                            child: CustomText(
                              text:  widget.user.profession,
                              size: 18,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          )]),
                    ],
                  ),
                ),
                const Spacer(flex: 8),
                const LogoutButton(),
                const Spacer(flex: 1),
              ]
          )
      );
  }
}