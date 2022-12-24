import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progetto_ium/colors/hexcolor.dart';
import 'package:progetto_ium/loginpage/login_page.dart';
import 'package:progetto_ium/navbar/custom_navbar.dart';

class PaginaEsempio extends StatelessWidget {
  final storage = const FlutterSecureStorage();
  const PaginaEsempio({Key? key}) : super(key: key);


  Future<bool> _foo() async{
    bool flag = true;
    final oldToken = await storage.read(key: 'jwt');
    if(oldToken == null){
      return false;
    }
    try{
      JWT.verify(oldToken,SecretKey("secret"));
    }on JWTExpiredError{
      flag = false;
    }
    return flag;
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(future: _foo(),builder: (context,snapshot){
      if(snapshot.hasData){
        if(snapshot.data == true){
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              body: const Center(
                child: Text("Home page"),
              ),
              bottomNavigationBar: CustomNavBar(barColor: HexColor.fromHex('#293241')),
            ),
          );
        }
        else{
          return LoginPage();
        }
      }
      else if(snapshot.hasError){
        return Center(child: Text("Error, ${snapshot.error}"));
      }
      else{
        return const CircularProgressIndicator();
      }
    });
  }
}
