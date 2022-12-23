import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: LoginPage()
      ),
    );
  }
}


