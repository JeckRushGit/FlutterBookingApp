import 'dart:html';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'navbar/custom_navbar.dart';
import 'navbar/custom_text.dart';

class CalendarMenu extends StatefulWidget {
  const CalendarMenu({Key? key}) : super(key: key);
  @override
  State<CalendarMenu> createState() => _CalendarMenuState();
}

class _CalendarMenuState extends State<CalendarMenu> {
  late List<String> items;
  late List<String> items2;
  late String value;
  late String value2;
  _CalendarMenuState() {
    items = ['matematica', 'fisica', 'antologia', 'filologia', 'stilografia'];
    items2 = [
      'Ugo',
      'Mario',
      'Franco',
    ];
    value = items[2];
    value2 = items2[2];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Row(
        children: [
          Container(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 41, 50, 65),
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButton<String>(
                  value: value2,
                  iconSize: 30,
                  dropdownColor: Color.fromARGB(255, 41, 50, 65),
                  iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(16),
                  items: items2.map(buildMenuItem).toList(),
                  onChanged: (value2) => setState(() => this.value2 = value2!),
                ),
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Container(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 41, 50, 65),
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButton<String>(
                  value: value,
                  iconSize: 30,
                  dropdownColor: Color.fromARGB(255, 41, 50, 65),
                  iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(16),
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() => this.value = value!),
                ),
              ),
            ),
          ),
        ],
      )));
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Color.fromARGB(255, 240, 246, 255)),
        ),
      );
}
