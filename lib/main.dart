import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progetto_ium/homepage.dart';
import 'colors/hexcolor.dart';
import 'loginpage/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final Color customBlue = HexColor.fromHex('#293241');

void main() {
  runApp( const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> _verifyToken() async {
    bool flag = true;
    final oldToken = await _storage.read(key: 'jwt');
    if (oldToken == null) {
      return false;
    }
    try {
      JWT.verify(oldToken, SecretKey("secret"));
    } on JWTExpiredError {
      flag = false;
    }
    return flag;
  }

  @override
  Widget build(BuildContext context) {

    //per disattivare la rotazione dello schermo del dispositivo
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder(
        future: _verifyToken(),               //prima di fare il render della homepage verifica la validità del token
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {     //se il token è valido mostra la homepage
              return  HomePage();
            } else {
              return LoginPage();            //altrimenti se il token è scaduto o non è mai esistito vai alla pagina di login
            }
          } else if (snapshot.hasError) {
            return Center(child: Text("Error, ${snapshot.error}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
