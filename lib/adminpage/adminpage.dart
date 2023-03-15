import 'dart:convert';

import 'package:flutter/material.dart';
import '../agendamenu/agendapage.dart';
import '../agendamenu/list_elem.dart';
import '../agendamenu/list_elem_db.dart';
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
  late Future _myFuture;
  late User gUser;
  bool firstTime = true;
  final _focusNode = FocusNode();

  @override
  void initState() {
    _myFuture = _getUsers(null);
  }

  void _callBack(User user) {
    gUser = user;
    _myFuture = _getUsers(user);
    setState(() {

    });
  }

  Future<List<dynamic>> _getUsers(User? user) async {
    List<dynamic> resultToReturn = [];
    Map<User, Map<KeyLezione, List<Lezione>>> map = {};
    Map<KeyLezione, List<Lezione>> userBookings;
    Map<KeyLezione, List<Lezione>> userBookingsForSelectedUser;
    List<User> res = [];
    var queryParameters = {'action': 'getListOfUsers'};
    var uri = Uri.http("192.168.1.110:8082",
        '/demo1_war_exploded/ServletAdminGetBookings', queryParameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      for (var riga in jsonList) {
        User u = User.fromJson(riga);
        res.add(u);
      }
    }
    if (user == null && response.statusCode == 200) {
      User firstUser = res[0];
      userBookings = await _getUserBookings(firstUser);
      map[firstUser] = userBookings;
      resultToReturn.add(res);
      resultToReturn.add(map);
    } else if(user != null && response.statusCode == 200 ) {
      userBookingsForSelectedUser = await _getUserBookings(user);
      map[user] = userBookingsForSelectedUser;
      resultToReturn.add(res);
      resultToReturn.add(map);
    }
    return resultToReturn;
  }

  Future<Map<KeyLezione, List<Lezione>>> _getUserBookings(
      User selectedUser) async {
    Map<KeyLezione, List<Lezione>> userBookings = {};
    var queryParameters = {
      'action': 'getBookingsForUser',
      'userEmail': selectedUser.email
    };
    var uri = Uri.http("192.168.1.110:8082",
        '/demo1_war_exploded/ServletAdminGetBookings', queryParameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      for (var riga in jsonList) {
        KeyLezione k = KeyLezione.fromJson(riga);
        if (!(userBookings.containsKey(k))) {
          List<Lezione> list = [Lezione.fromJson(riga)];
          userBookings[k] = list;
        } else {
          List<Lezione> list = userBookings[k]!;
          list.add(Lezione.fromJson(riga));
        }
      }
    }

    return userBookings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            List<dynamic> listResult = snapshot.data;
            List<User> users = listResult[0];
            Map<User, Map<KeyLezione, List<Lezione>>> res = listResult[1];
            Iterable<User> l = res.keys;
            User selectedUser = l.elementAt(0);
            if(firstTime){
              gUser = selectedUser;
              firstTime = false;
            }
            List<KeyLezione> arrayGiorni = res[selectedUser]!.keys.toList();
            return GestureDetector(
              onTap: () {
                _focusNode.unfocus();
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  _myFuture = _getUsers(gUser);
                  setState(() {

                  });
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
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: selectedUser.name +
                                  " " +
                                  selectedUser.surname,
                              size: 25,
                              weight: FontWeight.w500,
                              color: Color.fromRGBO(111, 111, 111, 1),
                            ),
                          ),
                        ),
                        Spacer(flex: 1),
                        DropDownUsers(
                            callBackFunction: _callBack,
                            listOfUsers: users,
                            focusNode: _focusNode,
                            textFieldHeigth: 50,
                            width: MediaQuery.of(context).size.width * 0.40),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    Column(children: [
                      for (int i = 0; i < arrayGiorni.length; i++)
                        //if(_arrayGiorniLezioniNextW.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          //child: ListElem(),
                          child: ListElemDb(map: res[selectedUser]!, date: arrayGiorni[i] ,user: selectedUser ,slidable_enabled: true,),
                        ),
                    ],)
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
