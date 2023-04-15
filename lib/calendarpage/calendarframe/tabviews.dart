// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/calendarcontroller.dart';
import '../controller/tabcontroller.dart';
import 'bookingrectangle.dart';

class ViewsGenerator {
  final List<int> days;
  List<Widget>? _views;
  late MyTabController _tabController;
  late CalendarController _calendarController;

  ViewsGenerator({required this.days}) {
    try {
      _calendarController = Get.find();
      _tabController = Get.find();
      //se entrambi i controller sono stati trovati , genera la lista di tab view
      _views = _generateViews();
    } catch (e) {
      //genera errore se uno dei due controlli non è stato trovato, setta le views = null
      print(
          'Uno o più controller non sono stati trovati nel ViewsGenerator : $e');
      _views = null;
    }
  }

  List<Widget>? get views => _views;

  //genera le tab view per i 5 giorni del calendar frame
  List<Widget> _generateViews() {
    var views = <Widget>[];
    for (int i = 0; i < _tabController.controller.length; i++) {
      views.add(Padding(
        padding:
            const EdgeInsets.only(left: 50, top: 50,bottom: 50,right: 25),
        child: TabView(
          tabDay: days[i],
          calendarController: _calendarController,
        ),
      ));
    }
    return views;
  }
}

class TabView extends StatelessWidget {
  final int tabDay;
  final CalendarController calendarController;

  const TabView(
      {Key? key, required this.tabDay, required this.calendarController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      try {
        var rows = <Widget>[];
        for (int i = 0; i < 7; i++) {
          switch (i) {
            case 1:
            case 3:
            case 5:
              rows.add(const SizedBox(height: 0.5,));
              break;
            case 0:
              var mapOfHour = calendarController.mapOfBookings.value[tabDay];
              Map<String, dynamic>? data = null;
              if (mapOfHour != null) {
                data = mapOfHour['15:00-16:00'];
              }
              rows.add(BookingRectangle(
                showOnlyTop: true,
                  controller: calendarController,
                  topText: '15:00',
                  bottomText: '16:00',
                  bookingsInfo: data));
              break;
            case 2:
              var mapOfHour = calendarController.mapOfBookings.value[tabDay];
              Map<String, dynamic>? data = null;
              if (mapOfHour != null) {
                data = mapOfHour['16:00-17:00'];
              }
              rows.add(BookingRectangle(
                showOnlyTop: true,
                  controller: calendarController,
                  topText: '16:00',
                  bottomText: '17:00',
                  bookingsInfo: data));
              break;
            case 4:
              var mapOfHour = calendarController.mapOfBookings.value[tabDay];
              Map<String, dynamic>? data = null;
              if (mapOfHour != null) {
                data = mapOfHour['17:00-18:00'];
              }
              rows.add(BookingRectangle(
                showOnlyTop: true,
                  controller: calendarController,
                  topText: '17:00',
                  bottomText: '18:00',
                  bookingsInfo: data));
              break;
            case 6:
              var mapOfHour = calendarController.mapOfBookings.value[tabDay];
              Map<String, dynamic>? data = null;
              if (mapOfHour != null) {
                data = mapOfHour['18:00-19:00'];
              }
              rows.add(BookingRectangle(
                showOnlyTop: false,
                  controller: calendarController,
                  topText: '18:00',
                  bottomText: '19:00',
                  bookingsInfo: data));
              break;
          }
        }

        return Column(children: rows);
      } catch (e) {
        return const Placeholder();
      }
    });
  }
}
