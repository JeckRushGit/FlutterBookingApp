import 'dart:convert';

import 'package:flutter/material.dart';
import '../agendamenu/agendapage.dart';
import '../agendamenu/list_elem.dart';
import '../agendamenu/list_elem_db.dart';
import '../colors/hexcolor.dart';
import '../custom_text.dart';
import '../modules/user.dart';
import 'package:http/http.dart' as http;
import '../startingday.dart';
import 'dropdownuser.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late User _selectedUser;
  late String _userName;
  late List<User> _listOfUsers;
  late Future _myFuture;
  late Future _myFuture2;
  late List<KeyLezione> _arrayGiorni = [];
  bool firstTime = true;

  final _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _myFuture = _getUsers();
  }

  //for the callback fuction fot the Dropdown Menu
  void _callBackSelectedUser(User utente) {
    _myFuture = _getUsers();
    _userName = utente.name+" "+utente.surname;
    setState(() {
    });
  }

  Future<List<User>> _getUsers() async {
    List<User> res = [];
    final queryParameters = {'action': 'getListOfUsers'};
    final uri = Uri.http("$init_ip",
        '/demo1_war_exploded/ServletAdminGetBookings', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      for (var riga in jsonList) {
        User u = User.fromJson(riga);
        res.add(u);
      }
    } else {
      print(response.statusCode);
      print("errore");
    }
    return res;
  }

  // Stream<Map<KeyLezione, List<Lezione>>> _getLezioniUtente(User _selectedUser) async* {
  //   var response = await http.post(Uri.parse("$ip/Servlet"), body: {});
  //   //Da fare: use _selectedUser to put the values we need to send to the Servlet
  //   List<dynamic> jsonList = jsonDecode(response.body);
  //   Map<KeyLezione, List<Lezione>> map = {};
  //
  //   for (var riga in jsonList) {
  //     KeyLezione k = KeyLezione.fromJson(riga);
  //
  //     if (!(map.containsKey(k))) {
  //       _arrayGiorni.add(k);
  //
  //       List<Lezione> list = [Lezione.fromJson(riga)];
  //
  //       map[k] = list;
  //     } else {
  //       List<Lezione> list = map[k]!;
  //
  //       list.add(Lezione.fromJson(riga));
  //     }
  //   }
  //
  //   _arrayGiorni
  //       .sort((a, b) => a.compareTo(b)); /*Per ordinare l'array di KeyLezione*/
  //
  //   yield map;
  // }

  Future<Map<KeyLezione, List<Lezione>>> _getLezioniUtente(User _selectedUser) async{
    Map<KeyLezione, List<Lezione>> map = {};
    List<User> res = [];
    final queryParameters = {'action': 'getBookingsForUser','userEmail': _selectedUser.email};
    final uri = Uri.http("$init_ip",
        '/demo1_war_exploded/ServletAdminGetBookings', queryParameters);
    final response = await http.get(uri);
    List<dynamic> jsonList = jsonDecode(response.body);

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(firstTime){
              _listOfUsers = snapshot.data;
              _selectedUser = _listOfUsers[0];
              _userName = "${_selectedUser.name} ${_selectedUser.surname}";
              firstTime = false;
            }
            return GestureDetector(
              onTap: () {
                _focusNode.unfocus();
              },
              child: RefreshIndicator(
                onRefresh: () async {

                },
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 40, 30, 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          text: "Client Bookings",
                          size: 30,
                          weight: FontWeight.bold,
                          color: Color.fromRGBO(41, 50, 65, 1),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 20,),
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: _userName,
                              size: 25,
                              weight: FontWeight.w500,
                              color: Color.fromRGBO(111, 111, 111, 1),
                            ),
                          ),
                        ),
                        Spacer(flex: 1),
                        DropDownUsers(
                          callBackFunction: _callBackSelectedUser,
                            listOfUsers: _listOfUsers,
                            focusNode: _focusNode,
                            textFieldHeigth: 50,
                            width:
                                MediaQuery.of(context).size.width * 0.40),
                        SizedBox(width: 20,)
                      ],
                    ),FutureBuilder(future: _getLezioniUtente(_selectedUser),builder: (context,snapshot){
                      if(snapshot.hasData){
                        return Container();
                      }else{
                        return Center(child: CircularProgressIndicator(),);
                      }
                    },)

                    // for (int i = 0; i < 5 /*_arrayGiorni.length*/; i++)
                    //   //if(_arrayGiorniLezioniNextW.isNotEmpty)
                    //   Padding(
                    //     padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    //     child: ListElem(),
                    //     //child: ListElemDb(map: map, date: _arrayGiorni[i] ,user: _selectedUser ,slidable_enabled: true,),
                    //   ),
                  ],
                ),
              ),
            );
          } else
            return Center(child: CircularProgressIndicator());
        });
  }
}
