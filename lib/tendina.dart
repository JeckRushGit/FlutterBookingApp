// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CalendarIIIMenu extends StatefulWidget {
  const CalendarIIIMenu({Key? key}) : super(key: key);

  @override
  State<CalendarIIIMenu> createState() => _CalendarMenuState();
}

class _CalendarMenuState extends State<CalendarIIIMenu> {
  late List<String> items;
  late List<String> items2;
  late String value;
  late String value2;
  late TextEditingController c;


  _CalendarMenuState() {
    c = TextEditingController();
    items = ['matematica', 'fisica', 'antologia', 'filologia', 'stilografia'];
    items2 = [
      'Ugo',
      'Mario',
      'Franco',
      'Miccio',
      'Mauro',
      'Paguro',
    ];
    value = items[2];
    value2 = items2[2];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            //Icon(Icons.arrow_downward_sharp),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SearchField(
              searchStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 240, 246, 255)),
              hint: items2[2],
              //initialValue:
              suggestionStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 240, 246, 255)),
              searchInputDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 3, color: Color.fromARGB(218, 0, 0, 0)),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 41, 50, 65),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              itemHeight: 55,
              maxSuggestionsInViewPort: 4,
              suggestionsDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color.fromARGB(255, 41, 50, 65)),
              suggestions: items2
                  .map(
                    (e) => SearchFieldListItem<String>(
                      e.toString(),
                      item: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        )),
      );
}
