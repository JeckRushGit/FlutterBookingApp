// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../custom_text.dart';

class CustomNavBar extends StatefulWidget {
  final Color barColor;
  const CustomNavBar({Key? key,required this.barColor}) : super(key: key);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _index = 0;
  bool vis1 = true;
  bool vis2 = false;
  bool vis3 = false;

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
      switch (index) {
        case 0:
          vis1 = true;
          vis2 = false;
          vis3 = false;
          break;

        case 1:
          vis1 = false;
          vis2 = true;
          vis3 = false;
          break;

        case 2:
          vis1 = false;
          vis2 = false;
          vis3 = true;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.barColor,
      child: TabBar(
        padding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        tabs: [
          Tab(
            icon: const Icon(Iconsax.archive_book),
            child: Visibility(visible: vis1, child: CustomText(text: "Agenda")),
          ),
          Tab(
            icon: const Icon(Iconsax.calendar_1),
            child: Visibility(
              visible: vis2,
              child: CustomText(
                text: "Calendario",
              ),
            ),
          ),
          Tab(
            icon: const Icon(Iconsax.profile_circle),
            child: Visibility(
              visible: vis3,
              child: CustomText(text: "Profilo"),
            ),
          )
        ],
        indicatorColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
