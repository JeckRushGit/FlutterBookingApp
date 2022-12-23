import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../colors/hexcolor.dart';
import '../custom_text.dart';
import 'custom_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#3D5A80"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(flex: 7),
            CustomText(
              text: "BOOKIT",
              size: 35,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            const Spacer(flex: 1),
            CustomText(
              align: TextAlign.center,
              text: "The esiest way to book your private lessons ",
              color: Colors.white,
              size: 25,
              weight: FontWeight.w600,
            ),
            const Spacer(flex: 4),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: CustomForm(
                  label: "Email",
                  hint: "e.g. john@gmail.com",
                  inputType: TextInputType.emailAddress,
                  icon: Icon(Iconsax.sms, color: Colors.white)),
            ),
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: CustomForm(
                    obscure: true,
                    label: "Password",
                    hint: "",
                    inputType: TextInputType.visiblePassword,
                    icon: Icon(
                      Iconsax.lock,
                      color: Colors.white,
                    ))),
            Spacer(
              flex: 2,
            ),
            MaterialButton(
              elevation: 7.5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              padding: EdgeInsets.all(13),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                      text: "Login",
                      color: HexColor.fromHex("#3D5A80"),
                      weight: FontWeight.w700),
                  SizedBox(width: 20),
                  Icon(
                    Iconsax.login,
                    color: HexColor.fromHex("#3D5A80"),
                  )
                ],
              ),
            ),
            const Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}
