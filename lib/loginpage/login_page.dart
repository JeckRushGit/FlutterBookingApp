
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progetto_ium/paginaesempio.dart';

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
  final storage = FlutterSecureStorage();



  Future<void> Foo(String email,String password) async{



    final response = await http.post(Uri.parse("http://192.168.1.146:8081/backendeweb_war_exploded/ServletLogin"),body: {'email': email,'password': password});
    if(response.statusCode == 200){
      final token = response.body;
      await storage.write(key: 'jwt', value: token);
      Get.to(PaginaEsempio());
    }
    else if(response.statusCode == 401){
      print("Wrong password");
    }
    else if(response.statusCode == 404){
      print("User not found");
    }
    else{
      print("Something went wrong");
    }
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
                    icon: Icon(Iconsax.sms, color: Colors.white)),
              ),
              SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: CustomForm(
                      controller: passwordController,
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
                onPressed: () {
                  Foo(emailController.text,passwordController.text);
                },
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
      ),
    );
  }
}
