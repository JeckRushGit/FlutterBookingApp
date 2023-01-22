

import 'package:flutter/cupertino.dart';
import 'package:progetto_ium/modules/course.dart';
import 'package:progetto_ium/modules/professor.dart';

class CalendarModel extends ChangeNotifier{
  Map<Course, Set<Professor>> map = {};
  late Course selectedCourse;
  late Professor selectedProfessor;
  late List<Course> listOfCourses;
  late List<Professor> listOfProfessor;


  void updateMap(Map<Course, Set<Professor>> newMap){
    map = newMap;
    listOfCourses = map.keys.toList();
    listOfCourses.sort((a,b) => a.compareTo(b));
    selectedCourse = listOfCourses[0];
    listOfProfessor = map[selectedCourse]!.toList();
    listOfProfessor.sort((a,b) => a.compareTo(b));
    selectedProfessor = listOfProfessor[0];
    notifyListeners();
  }



}

class Other extends ChangeNotifier{
  late List<Professor> listOfProfessor;
  void updateListOfProfessor(List<Professor> list){
    listOfProfessor = list;
    notifyListeners();
  }
}

class SelectedCourse extends ChangeNotifier{
  late Course selectedCourse;

  void updateSelectedCourse(Course course){
    selectedCourse = course;
    notifyListeners();
  }
}

class SelectedProfessor extends ChangeNotifier{
  late Professor selectedProfessor;

  void updateSelectedProfessor(Professor professor){
    selectedProfessor = professor;
    notifyListeners();
  }
}

class AvBookingsModel extends ChangeNotifier{
  Map<int,List<bool>> map = {};

  void updateMap(Map<int,List<bool>> newMap){
    map = newMap;
    notifyListeners();
  }
}