import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progetto_ium/agenda_menu.dart';
import 'package:progetto_ium/calendar_menu.dart';
import 'package:progetto_ium/profile_page.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgendaMenu(),
    );
    /*GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/Profile', page: () => ProfilePage())
      ],
    );*/
  }
}
