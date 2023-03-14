import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../colors/hexcolor.dart';
import '../custom_text.dart';
import '../modules/user.dart';
import '../startingday.dart';

class DropDownUsers extends StatefulWidget {
  List<User> listOfUsers;
  final double width;
  final double textFieldHeigth;
  final FocusNode focusNode;
  final Function callBackFunction;

  DropDownUsers({Key? key,required this.listOfUsers, required this.width, required this.textFieldHeigth, required this.focusNode,required this.callBackFunction}) : super(key: key);

  @override
  State<DropDownUsers> createState() => _DropDownUsersState();
}

class _DropDownUsersState extends State<DropDownUsers> {

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final BorderRadiusGeometry _radiusGeometry1 = const BorderRadius.all(Radius.circular(16));
  final BorderRadiusGeometry _radiusGeometry2 = const BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16));
  late BorderRadiusGeometry _containerGeometry;

  late List<User> _filteredUsers;
  late User _lastValue;
  late List<User> _listOfUsers;

  OverlayEntry? _entry;


  final LayerLink _link = LayerLink();
  String _hintText = "";

  bool isValid = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listOfUsers = widget.listOfUsers;
    _filteredUsers = _listOfUsers;
    _lastValue = _listOfUsers[0];
    _hintText = _lastValue.email;
    _containerGeometry = _radiusGeometry1;
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        if (_filteredUsers.isEmpty) {
          _filteredUsers = _listOfUsers;
        }
        setState(() {
          _containerGeometry = _radiusGeometry2;
        });
        showMenu();
        _hintText = "";
      } else {
        setState(() {
          _hintText = _lastValue.email;
          _containerGeometry = _radiusGeometry1;
        });
        hideMenu();
      }
    });
  }


  void _filterItems(String query) {

    isValid = false;
    if (_entry == null) {
      _containerGeometry = _radiusGeometry2;
      showMenu();
    }
    List<User> res = [];
    if (query.isEmpty) {
      res = _listOfUsers;
    } else {
      res = _listOfUsers
          .where((user) =>
          user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      res.sort((a, b) => a.compareTo(b));
      _filteredUsers = res;
    });
  }


  void showMenu(){
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _entry = OverlayEntry(
        builder: (context) => Positioned(
            width: size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0, size.height),
                link: _link,
                child: Material(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  color: HexColor.fromHex("#293241"),
                  child: MediaQuery.removePadding(
                    context: context,
                    child: Container(
                      padding:
                      const EdgeInsets.only(right: 15, bottom: 10, top: 10),
                      child: RawScrollbar(
                        thickness: 10,
                        trackVisibility: true,
                        trackColor: Colors.grey,
                        trackRadius: const Radius.circular(4),
                        controller: _scrollController,
                        thumbColor: Colors.white,
                        thumbVisibility: true,
                        radius: const Radius.circular(4),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: CustomText(
                                    text: _filteredUsers[index].email,
                                    color: Colors.white,
                                  ),
                                  onTap: () =>
                                      _onItemSelected(_filteredUsers[index]));
                            }),
                      ),
                    ),
                  ),
                ))));
    overlay.insert(_entry!);

  }


  void hideMenu(){
    if (!isValid) {
      _hintText = _lastValue.email;
      _controller.text = "";
    }
    _entry?.remove();
    _entry = null;
  }

  Future<void> _onItemSelected(User item) async {
    List<User> tmp = await _getUsers();
    if(tmp.isNotEmpty){
      _listOfUsers = await _getUsers();
    }
    isValid = true;
    _controller.text = "";
    _lastValue = item;
    _filteredUsers = [];
    widget.focusNode.unfocus();
    widget.callBackFunction(item);    //chiama la funzione passatagli come callback per ottenere le lezioni dell'utente selezionato
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



  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: Container(
        decoration: BoxDecoration(color: HexColor.fromHex("#293241"),borderRadius: _containerGeometry),
        height: widget.textFieldHeigth,
        width: widget.width,
        child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: _hintText,
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          style: GoogleFonts.montserrat(color: Colors.white,),
          controller: _controller,
          focusNode: widget.focusNode,
          onChanged: _filterItems,
        ),
      ),
    );

  }
}
