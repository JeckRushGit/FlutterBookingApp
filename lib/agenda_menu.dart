import 'dart:html';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'navbar/custom_navbar.dart';
import 'navbar/custom_text.dart';

class AgendaMenu extends StatefulWidget {
  const AgendaMenu({Key? key}) : super(key: key);

  @override
  State<AgendaMenu> createState() => _AgendaMenuState();
}

class _AgendaMenuState extends State<AgendaMenu> {
  late List<String> items;
  late String value;

  _AgendaMenuState() {
    items = ['to do', 'checked', 'canceled'];
    value = items[0];
  }
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Container(
                  child: Align(
        alignment: Alignment.center,
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
      ))));

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
