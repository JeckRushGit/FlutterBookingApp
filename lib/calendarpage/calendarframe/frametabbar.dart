import 'package:flutter/material.dart';

import '../../colors/hexcolor.dart';
import '../../custom_text.dart';

class FrameTabBar extends StatelessWidget {
  final TabController controller;
  final List<int> days;

  const FrameTabBar({Key? key, required this.controller, required this.days})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tabs = <Widget>[];
    if (days.isNotEmpty){
      for (int i = 0; i < 5; i++) {
        switch (i) {
          case 0:
            tabs.add(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: days[i].toString()),
                const CustomText(text: 'M')
              ],
            ));
            break;
          case 1:
            tabs.add(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: days[i].toString()),
                const CustomText(text: 'T')
              ],
            ));
            break;
          case 2:
            tabs.add(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: days[i].toString()),
                const CustomText(text: 'W')
              ],
            ));
            break;
          case 3:
            tabs.add(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: days[i].toString()),
                const CustomText(text: 'T')
              ],
            ));
            break;
          case 4:
            tabs.add(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: days[i].toString()),
                const CustomText(text: 'F')
              ],
            ));
            break;
        }
      }

    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        color: HexColor.fromHex("#293241"),
      ),
      child: TabBar(
        tabs: tabs,
        controller: controller,
        indicator: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            color: HexColor.fromHex("#4E5F7D")),
      ),
    );
  }
}
