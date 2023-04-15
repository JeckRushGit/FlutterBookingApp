// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:progetto_ium/startingday.dart';

import '../../modules/course.dart';
import '../../modules/professor.dart';
import '../../modules/user.dart';

class CalendarController extends GetxController {
  // User? user = User.onlyEmail('giacomodamosso@gmail.com');
  User? user = null;
  var data = <String, List<dynamic>>{}.obs;
  var listOfCourses = <Course>[].obs;
  var listOfProfessors = <Professor>[].obs;
  var selectedCourse = Rxn<Course>();
  var selectedProfessor = Rxn<Professor>();
  var isLoading = true.obs;
  var needRefresh = false;
  var mapOfBookings = <int, Map<String, dynamic>>{}.obs;
  var days = <int>[].obs;
  int month = 0;
  bool firstTime = true;
  var isVisible = true.obs;
  var offline = false.obs;
  BuildContext context;

  CalendarController({this.user,required this.context});

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    //Data memorizza i dati riguardanti le lezioni ottenuti dalla fetchLessons(),
    //che viene chiamata la prima volta che si arriva su questa pagina oppure viene refreshata.
    //Ogni qual volta si fa una fetch aggiorniamo la lista di corsi
    ever(data, (_) {
      if (data.isNotEmpty) {
        listOfCourses.value = createListOfCoursesLogic(data.value);
      }
    });
    /*            |
                  |
                  |
                  v
     */
    //la lista dei corsi è cambiata , selectedCourse sarà il primo in ordine alfabetico
    ever(listOfCourses, (_) {
      if (listOfCourses.isNotEmpty) {
        selectedCourse.value = listOfCourses.value[0];
        if (needRefresh) {
          selectedCourse.refresh();
        }
      }
    });
    /*            |
                  |
                  |
                  v
     */
    //selectedCourse è cambiato , ottieni una nuova lista di professori per quel corso
    ever(selectedCourse, (_) {
      listOfProfessors.value =
          createListOfProfessorLogic(data, selectedCourse.value!);
    });
    /*            |
                  |
                  |
                  v
     */
    ever(listOfProfessors, (_) async {
      if (listOfProfessors.isNotEmpty) {
        selectedProfessor.value = listOfProfessors.value[0];
        if (needRefresh) {
          selectedProfessor.refresh();
        }
      }
    });

    ever(selectedProfessor, (_) async {
      await fetchBookings(
          selectedCourse.value!, selectedProfessor.value!, user);
    });

    await fetchLessons();
    await getDaysAndMonth();
    isLoading.value = false;
  }


  void changeSelectedCourse(Course course) {
    selectedCourse.value = course;
  }

  void changeSelectedProfessor(Professor professor) {
    selectedProfessor.value = professor;
  }

  void refreshModel() async {
    needRefresh = true;
    isLoading.value = true;
    await fetchLessons();
    await getDaysAndMonth();
    //await fetchBookings(selectedCourse.value!, selectedProfessor.value!,User.onlyEmail('giacomodamosso@gmail.com'));
    isLoading.value = false;
    needRefresh = false;
  }

  Future<void> fetchLessons() async {
    var uri =
        Uri.http(init_ip, '/demo1_war_exploded/ServletGetTeachings', null);
    try {
      var response = await http.get(uri);
      offline.value = false;
      if (response.statusCode == 200) {
        Map<String, List<dynamic>> data = groupByCourse(response);
        this.data.value = data;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      offline.value = true;
      print(e);
    }
  }

  Future<void> getDaysAndMonth() async {
    var queryParam = {'action': 'web-getdaysandmonth'};
    var uri = Uri.http(
        init_ip, '/demo1_war_exploded/ServletGetAvBookings', queryParam);
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        month = json['month'];
        days.value = List<int>.from(json['days']);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchBookings(
      Course course, Professor professor, User? user) async {
    late Map<String, String> queryParameters;
    if (user != null) {
      queryParameters = {
        'action': 'mobile',
        'titoloCorso': course.course_titol,
        'emailProfessore': professor.email,
        'emailUtente': user.email
      };
    } else {
      queryParameters = {
        'action': 'guest',
        'titoloCorso': course.course_titol,
        'emailProfessore': professor.email,
      };
    }

    var uri = Uri.http(
        init_ip, '/demo1_war_exploded/ServletGetAvBookings', queryParameters);
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        mapOfBookings.value = groupByDayAndHour(response);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Map<int, Map<String, dynamic>> groupByDayAndHour(var response) {
    List<dynamic> json = (jsonDecode(response.body));
    json.sort((a, b) {
      return a['day'].toString().compareTo(b['day'].toString());
    });

    Map<int, Map<String, dynamic>> outerMap = {};

    for (var row in json) {
      int outerkey = row['day'];
      String innerKey = row['hour'];
      if (!outerMap.containsKey(outerkey)) {
        Map<String, dynamic> innerMap = {};
        innerMap[innerKey] = row;
        outerMap[outerkey] = innerMap;
      } else {
        if (!outerMap[outerkey]!.containsKey(innerKey)) {
          outerMap[outerkey]![innerKey] = row;
        }
      }
    }
    return outerMap;
  }

  Future<bool> bookLesson(Course course, Professor professor, User user,
      int day, int month, String hour) async {
    try {
      var response = await http.post(
        Uri.parse("$ip/ServletBookTeaching"),
        body: jsonEncode(<String, String>{
          'course_titol': course.course_titol,
          'professor_email': professor.email,
          'user_email': user.email,
          'day': day.toString(),
          'hour': hour.toString(),
          'month': month.toString()
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        await fetchBookings(
            selectedCourse.value!, selectedProfessor.value!, this.user);
        return true;
      } else if (response.statusCode == 400) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Lesson no longer available  "),
                ));
      } else if (response.statusCode == 406) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Wait for a minute  "),
                ));
      } else {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Something went wrong"),
                ));
      }
      await fetchBookings(
          selectedCourse.value!, selectedProfessor.value!, this.user);
      return false;
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Something went wrong"),
              ));
    }
    return false;
  }

  List<Course> createListOfCoursesLogic(Map<String, List<dynamic>> data) {
    List<Course> listOfCourses = [];
    for (var key in data.keys) {
      Course course = Course.fromJson(data[key]![0]['course']);
      listOfCourses.add(course);
    }
    return listOfCourses;
  }

  List<Professor> createListOfProfessorLogic(
      Map<String, List<dynamic>> data, Course selectedCourse) {
    List<Professor> list = [];
    for (var item in this.data.value[selectedCourse.course_titol]!) {
      Professor professor = Professor.fromJson(item['professor']);
      list.add(professor);
    }
    return list;
  }

  //raggruppa le lezioni per corso in un oggetto che come chiave ha il titolo del corso e come valore
  //la lezione
  Map<String, List<dynamic>> groupByCourse(http.Response response) {
    List<dynamic> json = (jsonDecode(response.body));
    Map<String, List<dynamic>> map = {};
    for (var row in json) {
      if (!map.containsKey(row['course']['course_titol'])) {
        List<dynamic> list = [];
        list.add(row);
        map[row['course']['course_titol']] = list;
      } else {
        List<dynamic> list = map[row['course']['course_titol']]!;
        list.add(row);
      }
    }
    return map;
  }
}
