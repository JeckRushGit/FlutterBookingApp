import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progetto_ium/calendarpage/calendar_page.dart';
import 'package:progetto_ium/calendarpage/calendarpageguest.dart';
import 'package:progetto_ium/homepage.dart';
import 'package:progetto_ium/startingday.dart';

import '../colors/hexcolor.dart';
import '../custom_text.dart';
import 'custom_form.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();

  Future<bool> Foo(String email, String password) async {
    try {
      var response = await http.post( //172.19.137.57
          Uri.parse("$ip/ServletLogin"),
          body: {
            'email': email,
            'password': password
          }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final token = response.body;
        await storage.write(key: 'jwt', value: token);
        return true;
      } else if (response.statusCode == 401) {
        print("Wrong password");
      } else if (response.statusCode == 404) {
        print("User not found");
      } else {
        print("Something went wrong");
      }
      return false;
    } catch (e) {
      print("Qualcosa è andato storto con il server: $e");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                    controller: emailController,
                    label: "Email",
                    hint: "e.g. john@gmail.com",
                    inputType: TextInputType.emailAddress,
                    icon: const Icon(Iconsax.sms, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: CustomForm(
                      controller: passwordController,
                      obscure: true,
                      label: "Password",
                      hint: "",
                      inputType: TextInputType.visiblePassword,
                      icon: const Icon(
                        Iconsax.lock,
                        color: Colors.white,
                      ))),
              const Spacer(
                flex: 2,
              ),
              MaterialButton(
                elevation: 7.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                padding: const EdgeInsets.all(13),
                onPressed: () async {
                  bool res =
                      await Foo(emailController.text, passwordController.text);
                  if (res) {
                    if (!mounted) return;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    print("falso");
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                        text: "Login",
                        color: HexColor.fromHex("#3D5A80"),
                        weight: FontWeight.w700),
                    const SizedBox(width: 20),
                    Icon(
                      Iconsax.login,
                      color: HexColor.fromHex("#3D5A80"),
                    )
                  ],
                ),
              ),
              const Spacer(flex: 1),
              MaterialButton(
                elevation: 7.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                padding: const EdgeInsets.all(13),
                onPressed: () {
                  if (!mounted) return;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const CalendarPageGuest()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                        text: "Guest login",
                        color: HexColor.fromHex("#3D5A80"),
                        weight: FontWeight.w700),
                    const SizedBox(width: 20),
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
      ),
    );
  }
}
