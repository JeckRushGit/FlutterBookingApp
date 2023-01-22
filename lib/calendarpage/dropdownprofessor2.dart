import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progetto_ium/colors/hexcolor.dart';
import 'package:progetto_ium/custom_text.dart';
import 'package:progetto_ium/modules/CalendarModel.dart';

import 'package:progetto_ium/modules/professor.dart';
import 'package:provider/provider.dart';



class DropDownProfessor2 extends StatefulWidget {
  final double width;
  final double textFieldHeigth;
  final FocusNode focusNode;
  final Function callBackProfessor;

  const DropDownProfessor2({Key? key, required this.width,required this.textFieldHeigth,required this.focusNode,required this.callBackProfessor}) : super(key: key);

  @override
  State<DropDownProfessor2> createState() {
    return DropDownProfessor2State();
  }
}

class DropDownProfessor2State extends State<DropDownProfessor2> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<Professor> _listOfProfessors;
  late List<Professor> _filteredProfessors = [];
  late Professor _lastValue;
  OverlayEntry? _entry;
  final BorderRadiusGeometry _radiusGeometry1 = const BorderRadius.all(Radius.circular(16));
  final BorderRadiusGeometry _radiusGeometry2 = const BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16));
  late BorderRadiusGeometry _containerGeometry;
  bool isValid = true;
  String hintText = "";
  final LayerLink _link = LayerLink();


  @override
  void initState() {
    super.initState();
    _containerGeometry = _radiusGeometry1;
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        if(_filteredProfessors.isEmpty){
          _filteredProfessors = _listOfProfessors;
        }
        setState((){
          _containerGeometry = _radiusGeometry2;
        });
        showMenu();
        hintText = "";
      } else {
        setState(() {
          hintText = _lastValue.toStringDropDown();
          _containerGeometry = _radiusGeometry1;
        });
        hideMenu();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var pro = Provider.of<Other>(context);
    _listOfProfessors = pro.listOfProfessor;
    _filteredProfessors = _listOfProfessors;
    _lastValue = _listOfProfessors[0];
    hintText = _lastValue.toStringDropDown();
  }

  void showMenu() {
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
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
                  color: HexColor.fromHex("#293241"),
                  child: MediaQuery.removePadding(
                    context: context,
                    child: Container(
                      padding: const EdgeInsets.only(right: 15,bottom: 10,top: 10),
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
                            itemCount: _filteredProfessors.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: CustomText(text: _filteredProfessors[index].toStringDropDown(),color: Colors.white),
                                  onTap: () => _onItemSelected(_filteredProfessors[index])
                              );
                            }),
                      ),
                    ),
                  ),
                ))));
    overlay.insert(_entry!);
  }

  void hideMenu() {
    if(!isValid){
      hintText = _lastValue.toStringDropDown();
      _controller.text = "";
    }
    _entry?.remove();
    _entry = null;
  }

  void _filterItems(String query) {
    isValid = false;
    if(_entry == null){
      _containerGeometry = _radiusGeometry2;
      showMenu();
    }
    List<Professor> res = [];
    if (query.isEmpty) {
      res = _listOfProfessors;
    } else {
      res = _listOfProfessors
          .where((professor) => professor.toStringDropDown().toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      res.sort((a,b) => a.compareTo(b));
      _filteredProfessors = res;
    });
  }

  void _onItemSelected(Professor item) {
    isValid = true;
    setState(() {
      _controller.text = "";
      _lastValue = item;
      _filteredProfessors = [];
      widget.focusNode.unfocus();
    });
    widget.callBackProfessor(item);
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
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white),
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
