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

class AdminPage extends StatefulWidget  {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late User _selectedUser ;
  late String _usersName;
  late Stream myStream;
  late List<KeyLezione> _arrayGiorni = [];


  final _focusNode = FocusNode();


  Future<bool> _test() async {
    return true;
  }


  @override
  void initState() {
    super.initState();
    _usersName = "Nome Cognome";
    //myStream = _getLezioniUtente(_selectedUser);
  }

  //for the callback fuction fot the Dropdown Menu
  void callBackSelectedUser(User utente) {
    _usersName = utente.name + "" + utente.surname;

    setState((){
      myStream = _getLezioniUtente(_selectedUser);
    });
  }


  Stream<Map<KeyLezione, List<Lezione>>> _getLezioniUtente(User _selectedUser) async*{
    var response = await http.post(Uri.parse("$ip/Servlet"), body: {});
    //Da fare: use _selectedUser to put the values we need to send to the Servlet
    List<dynamic> jsonList = jsonDecode(response.body);
    Map<KeyLezione, List<Lezione>> map = {};

    for(var riga in jsonList){
      KeyLezione k = KeyLezione.fromJson(riga);

      if(!(map.containsKey(k))){
        _arrayGiorni.add(k);

        List<Lezione> list = [Lezione.fromJson(riga)];

        map[k] = list;

      }
      else{
        List<Lezione> list = map[k]!;

        list.add(Lezione.fromJson(riga));
      }
    }


    _arrayGiorni.sort((a, b) => a.compareTo(b));  /*Per ordinare l'array di KeyLezione*/


    print(map.isNotEmpty);
    yield map;
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: RefreshIndicator(
          onRefresh: _test,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "Client Bookings",
                      size: 30,
                      weight: FontWeight.bold,
                      color: Color.fromRGBO(41, 50, 65, 1),
                    ),),),
                Row(
                  children:[
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 0, 27),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          text: _usersName,
                          size: 22,
                          weight: FontWeight.w500,
                          color: Color.fromRGBO(111, 111, 111, 1),
                        ),),
                    ),
                    Spacer(flex: 3),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Text('Menu tendina'),
                      //child: DropDownUsers( width: MediaQuery.of(context).size.width * 0.30, textFieldHeigth: 50, focusNode: _focusNode, callBackUser: callBackSelectedUser,),
                    ),
                    Spacer(flex: 1),
                  ],
                ),
                for(int i=0; i< 5/*_arrayGiorni.length*/ ;i++)
                //if(_arrayGiorniLezioniNextW.isNotEmpty)
                 Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                   child: ListElem(),
                  //child: ListElemDb(map: map, date: _arrayGiorni[i] ,user: _selectedUser ,slidable_enabled: true,),
                ),
              ],
            ),
          )),
    );
  }
}
