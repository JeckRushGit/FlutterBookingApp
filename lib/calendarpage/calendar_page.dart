import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progetto_ium/calendarpage/dropdowncourse.dart';
import 'package:progetto_ium/calendarpage/dropdownprofessor2.dart';
import 'package:progetto_ium/calendarpage/rettangolo_prenotazione.dart';
import 'package:progetto_ium/custom_text.dart';
import 'package:progetto_ium/modules/CalendarModel.dart';
import 'package:progetto_ium/modules/professor.dart';
import 'package:progetto_ium/modules/teaching.dart';
import 'package:http/http.dart' as http;
import 'package:progetto_ium/modules/user.dart';
import 'package:provider/provider.dart';
import '../colors/hexcolor.dart';
import '../modules/course.dart';
import 'package:progetto_ium/startingday.dart';

int startingDayOfWeek = 16;

class CalendarPage extends StatefulWidget {
  final User user;

  const CalendarPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _focusNode = FocusNode();
  final _focusNode2 = FocusNode();
  late CalendarModel model;
  late Other model2;
  late SelectedCourse sCourse;

  late SelectedProfessor sProfessor;
  late AvBookingsModel modelBooking;
  late Stream myStream;
  late Stream bookingStream;
  int? firstDay = null;
  int? month = null;
  bool needToRebuild = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    myStream = _getTeachings();
    model = CalendarModel();
    model2 = Other();
    sCourse = SelectedCourse();
    sProfessor = SelectedProfessor();
    modelBooking = AvBookingsModel();
    //User user = User.fromToken(widget.token);
  }

  void changeCourse(Course course) {
    sCourse.updateSelectedCourse(course);
    List<Professor> listOfProfessor = model.map[course]!.toList();
    listOfProfessor.sort((a, b) => a.compareTo(b));
    changeProfessor(listOfProfessor[0]);
    model2.updateListOfProfessor(listOfProfessor);
  }

  void changeProfessor(Professor professor) {
    sProfessor.updateSelectedProfessor(professor);
    setState(() {
      bookingStream = _getBookingsForCourseAndProfessor(
          sCourse.selectedCourse, sProfessor.selectedProfessor, widget.user);
    });
  }

  Stream<Map<Course, Set<Professor>>> _getTeachings() async* {
    Map<Course, Set<Professor>> map = {};
    List<Teaching> list = [];
    var response = await http
        .get(Uri.parse("$ip/ServletGetTeachings"))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      for (var teaching in jsonList) {
        Teaching t = Teaching.fromJson(teaching);
        list.add(t);
      }
      for (Teaching t in list) {
        if (!map.containsKey(t.course)) {
          Set<Professor> newSet = {t.professor};
          map[t.course] = newSet;
        } else {
          Set<Professor> set = map[t.course]!;
          set.add(t.professor);
        }
      }
    }
    yield map;
  }

  void _reloadPage() {
    needToRebuild = true;
    setState(() {
      myStream = _getTeachings();
    });
  }

  Stream<Map<int, List<bool>>> _getBookingsForCourseAndProfessor(
      Course course, Professor professor, User user) async* {
    try {
      Map<int, List<bool>> map = {};

      var queryParameters1 = {'action': 'web-getdaysandmonth'};
      var uri1 = Uri.http(init_ip, '/demo1_war_exploded/ServletGetAvBookings',
          queryParameters1);
      var response1 = await http.get(uri1);

      int firstDayOfWeek = 0;
      if (response1.statusCode == 200) {
        Map<String, dynamic> jsonA = jsonDecode(response1.body);
        firstDayOfWeek = jsonA['days'][0];
        this.firstDay = jsonA['days'][0];
        this.month = jsonA['month'];
      }

      var queryParameters2 = {
        'action': 'mobile',
        'titoloCorso': course.course_titol,
        'emailProfessore': professor.email,
        'emailUtente': user.email
      };
      var uri2 = Uri.http(init_ip, '/demo1_war_exploded/ServletGetAvBookings',
          queryParameters2);
      var response2 = await http.get(uri2);

      if (response2.statusCode == 200) {
        /*PERICOLOSO !!!! CAMBIARE IL PRIMA POSSIBILE*/
        for (int i = 0; i < 5; i++) {
          List<bool> list = List<bool>.filled(4, false, growable: false);
          map[firstDayOfWeek] = list;
          firstDayOfWeek++;
        }

        /*************************************/

        List<dynamic> jsonMap = jsonDecode(response2.body);


        for (var c in jsonMap) {
          if (!map.containsKey(c["day"])) {
            List<bool> list = List<bool>.filled(4, false, growable: false);
            map[c["day"]] = list;
          }
          switch (c["hour"]) {
            case "15:00-16:00":
              map[c["day"]]![0] = true;
              break;
            case "16:00-17:00":
              map[c["day"]]![1] = true;
              break;
            case "17:00-18:00":
              map[c["day"]]![2] = true;
              break;
            case "18:00-19:00":
              map[c["day"]]![3] = true;
              break;
          }
        }
      }

      yield map;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: myStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var map = snapshot.data!;
            if (needToRebuild) {
              model.updateMap(map);
              model2.updateListOfProfessor(model.listOfProfessor);
              sCourse.updateSelectedCourse(model.listOfCourses[0]);
              sProfessor.updateSelectedProfessor(model.listOfProfessor[0]);
              bookingStream = _getBookingsForCourseAndProfessor(
                  sCourse.selectedCourse,
                  sProfessor.selectedProfessor,
                  widget.user);
              needToRebuild = false;
            }
            return GestureDetector(
              onTap: () {
                _focusNode.unfocus();
                _focusNode2.unfocus();
              },
              child: SafeArea(
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Flexible(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: "Available Lessons",
                                    size: 30,
                                    overflow: TextOverflow.clip,
                                    weight: FontWeight.bold,
                                    color: Color.fromRGBO(41, 50, 65, 1),
                                  ),
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                _reloadPage();
                              },
                              child: const Icon(Icons.refresh),
                            )
                          ],
                        ),
                        //const Spacer(flex: 1),
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: CustomText(
                                  text: "Subject:",
                                  size: 22,
                                  weight: FontWeight.bold,
                                  color: Color.fromRGBO(111, 111, 111, 1),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 7, 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: CustomText(
                                  text: "Teacher:",
                                  size: 22,
                                  weight: FontWeight.bold,
                                  color: Color.fromRGBO(111, 111, 111, 1),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Flexible(
                          flex: 2,
                          child: Row(
                            children: [
                              Flexible(
                                  child: ChangeNotifierProvider(
                                      create: (context) => model,
                                      child: Consumer<CalendarModel>(
                                          builder: (context, model, child) {
                                        return DropDownCourse(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                          textFieldHeigth: 50,
                                          focusNode: _focusNode,
                                          callBackCourse: changeCourse,
                                        );
                                      }))),
                              const Spacer(
                                flex: 1,
                              ),
                              Flexible(
                                  child: ChangeNotifierProvider(
                                      create: (context) => model2,
                                      child: Consumer<Other>(
                                          builder: (context, model2, child) {
                                        return DropDownProfessor2(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                          textFieldHeigth: 50,
                                          focusNode: _focusNode2,
                                          callBackProfessor: changeProfessor,
                                        );
                                      })))
                            ],
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Calendario(
                            tabController: _tabController, user: widget.user),
                        Flexible(
                          flex: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                      offset: Offset(0, 8),
                                      spreadRadius: 0,
                                      blurRadius: 3)
                                ],
                                color: HexColor.fromHex("#4E5F7D"),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24))),
                            constraints: const BoxConstraints(
                                maxHeight: 500, maxWidth: 500),
                            child: StreamBuilder(
                                stream: bookingStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var map = snapshot.data!;
                                    modelBooking.updateMap(map);
                                    return MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                            create: (context) => modelBooking),
                                        ChangeNotifierProvider(
                                            create: (context) => sCourse),
                                        ChangeNotifierProvider(
                                            create: (context) => sProfessor)
                                      ],
                                      child: Consumer3<
                                              AvBookingsModel,
                                              SelectedCourse,
                                              SelectedProfessor>(
                                          builder: (context, model, course,
                                              professor, child) {
                                        if (firstDay != null) {
                                          int day = firstDay!;
                                          var children = <Widget>[];
                                          for (var i = 0; i < 5; i++) {
                                            children.add(Prenotazioni(
                                                month: this.month!,
                                                day: day,
                                                user: widget.user,
                                                course: course,
                                                professor: professor,
                                                model: model,
                                                callBackReload: _reloadPage));
                                            day++;
                                          }

                                          return TabBarView(
                                            controller: _tabController,
                                            children: children,
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      }),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error, ${snapshot.error}"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class Prenotazioni extends StatelessWidget {
  final int day;
  final int month;
  final User user;
  late SelectedCourse course;
  late SelectedProfessor professor;
  AvBookingsModel model;
  final Function callBackReload;

  Prenotazioni(
      {Key? key,
      required this.month,
      required this.day,
      required this.user,
      required this.professor,
      required this.course,
      required this.model,
      required this.callBackReload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 6),
        Expanded(
          flex: 29,
          child: Column(
            children: [
              const Spacer(
                flex: 15,
              ),
              Flexible(
                  flex: 40,
                  child: RettangoloPrenotazione(
                      month: month,
                      day: day,
                      professor: professor.selectedProfessor,
                      course: course.selectedCourse,
                      user: user,
                      hour: "15:00-16:00",
                      prenotata: !model.map[day]![0],
                      width: double.maxFinite,
                      heigth: double.maxFinite,
                      callBackReload: callBackReload,
                      topText: "15:00")),
              const SizedBox(
                height: 1,
              ),
              Flexible(
                  flex: 40,
                  child: RettangoloPrenotazione(
                      month: month,
                      day: day,
                      professor: professor.selectedProfessor,
                      course: course.selectedCourse,
                      user: user,
                      hour: "16:00-17:00",
                      prenotata: !model.map[day]![1],
                      width: double.maxFinite,
                      heigth: double.maxFinite,
                      callBackReload: callBackReload,
                      topText: "16:00")),
              const SizedBox(
                height: 1,
              ),
              Flexible(
                  flex: 40,
                  child: RettangoloPrenotazione(
                      month: month,
                      day: day,
                      professor: professor.selectedProfessor,
                      course: course.selectedCourse,
                      user: user,
                      hour: "17:00-18:00",
                      prenotata: !model.map[day]![2],
                      width: double.maxFinite,
                      heigth: double.maxFinite,
                      callBackReload: callBackReload,
                      topText: "17:00")),
              const SizedBox(
                height: 1,
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 40,
                child: RettangoloPrenotazione(
                  month: month,
                  day: day,
                  professor: professor.selectedProfessor,
                  course: course.selectedCourse,
                  user: user,
                  hour: "18:00-19:00",
                  prenotata: !model.map[day]![3],
                  width: double.maxFinite,
                  heigth: double.maxFinite,
                  topText: "18:00",
                  callBackReload: callBackReload,
                  bottomText: "19:00",
                ),
              ),
              const Spacer(
                flex: 10,
              )
            ],
          ),
        ),
        const Spacer(
          flex: 1,
        )
      ],
    );
  }
}

class Calendario extends StatefulWidget {
  final TabController tabController;
  final User user;


  const Calendario({Key? key, required this.tabController, required this.user})
      : super(key: key);

  @override
  State<Calendario> createState() => _CalendarioState();
}




class _CalendarioState extends State<Calendario> {


  late Future<int?> myFuture;

  Future<int?> getStartingDay() async{

    var queryParam = {'action' : 'web-getdaysandmonth'};
    var uri1 = Uri.http(init_ip, '/demo1_war_exploded/ServletGetAvBookings',
        queryParam);

    var response = await http.get(uri1);

    if(response.statusCode == 200){
      Map<String,dynamic> json = jsonDecode(response.body);
      return json['days'][0];
    }
    else{
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getStartingDay();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: myFuture,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          int day = snapshot.data!;

          var days = ['M','T','W','T','F'];

          var tabs = <Widget>[];

          for(int i = 0; i < 5 ; i++){
            tabs.add(Tab(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: CustomText(text: days[i])),
                    Expanded(child: CustomText(text: day.toString()))
                  ],
                )),);
            day++;
          }

          return Flexible(
            fit: FlexFit.loose,
            flex: 4,
            child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  color: HexColor.fromHex("#293241"),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                      color: HexColor.fromHex("#4E5F7D")),
                  labelColor: Colors.white,
                  tabs: tabs,
                  controller: widget.tabController,
                )),
          );
        }else{
          return CircularProgressIndicator();
        }
      }
    );
  }
}
