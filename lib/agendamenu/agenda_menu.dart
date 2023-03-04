import 'package:flutter/material.dart';

class AgendaMenu extends StatefulWidget {
  final Function callBack;

  const AgendaMenu({Key? key, required this.callBack}) : super(key: key);

  @override
  State<AgendaMenu> createState() => _AgendaMenuState();
}

class _AgendaMenuState extends State<AgendaMenu> {
  late List<String> items;
  late String value;

  _AgendaMenuState() {
    items = ['To Do', 'Checked', 'Canceled'];
    value = items[0];
  }


  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Color.fromARGB(255, 240, 246, 255)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      height: 28,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 41, 50, 65),
        //border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        value: value,
        iconSize: 20,
        dropdownColor: Color.fromARGB(255, 41, 50, 65),
        iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
        items: items.map(buildMenuItem).toList(),
        onChanged: (value){
          widget.callBack(value);
          setState(() => this.value = value!);
        },
      ),
    );
  }
}