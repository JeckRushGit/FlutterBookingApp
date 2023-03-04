import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:progetto_ium/agendamenu/agenda_menu.dart';
import 'package:progetto_ium/agendamenu/agendapage.dart';
import 'package:progetto_ium/calendarpage/calendar_page.dart';
import 'package:progetto_ium/colors/hexcolor.dart';
import 'package:progetto_ium/modules/user.dart';
import 'package:progetto_ium/navbar/custom_navbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progetto_ium/profilepage/profilepage.dart';

class HomePage extends StatelessWidget {
  late User user;
  final storage = const FlutterSecureStorage();

  HomePage({Key? key}) : super(key: key);

  Future<User?> _getUserFromJWT() async{
    final String? token = await storage.read(key: 'jwt');
    if(token == null){
      return null;
    }
    Map<String,dynamic> payload = Jwt.parseJwt(token);
    User user = User(payload["email"],payload["name"],payload["surname"],payload["password"],payload["role"],payload["birthday"],payload["profession"]);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getUserFromJWT(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          user = snapshot.data!;
          return DefaultTabController(
              length: 3,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: TabBarView(physics: const NeverScrollableScrollPhysics(),children: [       // Viste relative alle 3 pagine
                  AgendaPage(user: user ),
                  CalendarPage(user: user,),
                  ProfilePage(user: user)
                ]),
                bottomNavigationBar:
                CustomNavBar(barColor: HexColor.fromHex("#293241")),
              ));
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
