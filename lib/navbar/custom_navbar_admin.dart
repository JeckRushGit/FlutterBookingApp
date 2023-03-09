import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../custom_text.dart';

class CustomNavBarAdmin extends StatefulWidget {
  final Color barColor;

  CustomNavBarAdmin({Key? key, required this.barColor}) : super(key: key);

  @override
  State<CustomNavBarAdmin> createState() => _CustomNavBarAdminState();
}

class _CustomNavBarAdminState extends State<CustomNavBarAdmin> {
  int _index = 0;
  bool vis1 = true;
  bool vis2 = false;

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
      switch (index) {
        case 0:
          vis1 = true;
          vis2 = false;
          break;

        case 1:
          vis1 = false;
          vis2 = true;
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
          indicatorColor: Colors.white,
          onTap: _onItemTapped,
          tabs: [
            Tab(
              icon: const Icon(Iconsax.archive_book),
              child:
                  Visibility(visible: vis1, child: CustomText(text: "Agenda")),
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
          ]),
    );
  }
}
