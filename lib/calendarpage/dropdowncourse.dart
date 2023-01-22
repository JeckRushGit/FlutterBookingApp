// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progetto_ium/colors/hexcolor.dart';
import 'package:progetto_ium/custom_text.dart';
import 'package:progetto_ium/modules/CalendarModel.dart';
import 'package:provider/provider.dart';
import '../modules/course.dart';


class DropDownCourse extends StatefulWidget {
  final double width;
  final double textFieldHeigth;
  final FocusNode focusNode;
  final Function callBackCourse;

  const DropDownCourse({Key? key, required this.width,required this.textFieldHeigth,required this.focusNode,required this.callBackCourse}) : super(key: key);

  @override
  State<DropDownCourse> createState() {
    return DropDownCourseState();
  }
}

class DropDownCourseState extends State<DropDownCourse> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<Course> _listOfCourses;
  late List<Course> _filteredCourses = [];
  late Course _lastValue;
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
        if(_filteredCourses.isEmpty){
          _filteredCourses = _listOfCourses;
        }
        setState((){
          _containerGeometry = _radiusGeometry2;
        });
        showMenu();
        hintText = "";
      } else {
        setState(() {
          hintText = _lastValue.course_titol;
          _containerGeometry = _radiusGeometry1;
        });
        hideMenu();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var pro = Provider.of<CalendarModel>(context);
    _listOfCourses = pro.listOfCourses;
    _filteredCourses = _listOfCourses;
    _lastValue = _listOfCourses[0];
    hintText = _lastValue.course_titol;
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
                            itemCount: _filteredCourses.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: CustomText(text: _filteredCourses[index].course_titol,color: Colors.white,),
                                  onTap: () => _onItemSelected(_filteredCourses[index])
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
      hintText = _lastValue.course_titol;
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
    List<Course> res = [];
    if (query.isEmpty) {
      res = _listOfCourses;
    } else {
      res = _listOfCourses
          .where((course) => course.course_titol.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      res.sort((a,b) => a.compareTo(b));
      _filteredCourses = res;
    });
  }

  void _onItemSelected(Course item) {
    isValid = true;
    setState(() {
      _controller.text = "";
      _lastValue = item;
      _filteredCourses = [];
      widget.focusNode.unfocus();
    });
    widget.callBackCourse(item);
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
