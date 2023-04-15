import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MyTabController extends GetxController with GetSingleTickerProviderStateMixin{
  late TabController controller;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller = TabController(length: 5, vsync: this);
  }
}