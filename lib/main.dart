import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:progetto_ium/paginaesempio.dart';
import 'colors/hexcolor.dart';
import 'loginpage/login_page.dart';

final Color customBlue = HexColor.fromHex('#293241');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => PaginaEsempio()),
        GetPage(name: '/login', page: () => LoginPage())
      ],
    );
  }
}


