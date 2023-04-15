import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'calendarframe/calendarframe.dart';
import 'controller/calendarcontroller.dart';
import 'dropdown/dropdown.dart';
import '../colors/hexcolor.dart';
import '../custom_text.dart';
import '../modules/user.dart';

class CalendarPage extends StatelessWidget {
  //utente che viene passato o meno sulla base del login,
  //se l'utente è un guest user rimarrà null , altrimenti assumerà
  //un valore che a suo volta verrà ispezionato per decidere se un client o admin
  User? user;

  //focus node del primo dropdown
  final FocusNode _focusNode1 = FocusNode();

  //focuso node del secondo dropdonw
  final FocusNode _focusNode2 = FocusNode();

  CalendarPage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //cerco il controller che deve essere stato creato nella home
    CalendarController controller = Get.find();




    //ottengo le dimensioni del dispositivo per decidere quelle dei dropdown
    double textFieldWidth = MediaQuery.of(context).size.width * 0.4;
    double textFieldHeight = MediaQuery.of(context).size.height * 0.07;

    //altezza della listlabel := 4 volte l'altezza del textfield
    double listLabelHeight = textFieldHeight * 4;

    return Obx(() {
      //se il controller ha finito di ottenere i dati dalle richieste ed ha ottenuto qualcosa
      if (!controller.offline.value &&
          !controller.isLoading.value &&
          controller.data.value.isNotEmpty) {
        //per mostrare la pagina partendo da sotto le fotocamera interna
        return SafeArea(
            child: GestureDetector(
          onTap: () {
            //tolgo il focus ad entrambi i dropdown quando premo fuori
            _focusNode1.unfocus();
            _focusNode2.unfocus();
          },
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            //se non metto un colore il GestureDetector non intercetta il tap
            color: Colors.transparent,
            //per generare un evento di refresh della pagina allo swipe in basso
            child: RefreshIndicator(
              onRefresh: () async {
                controller.refreshModel();
                _focusNode1.unfocus();
                _focusNode2.unfocus();
              },
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: const [
                        CustomText(
                          text: 'Book your lesson',
                          weight: FontWeight.bold,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const CustomText(
                              weight: FontWeight.bold,
                              text: 'Selected course :',
                            ),
                            SizedBox(
                                width: textFieldWidth,
                                height: textFieldHeight,
                                child: Center(
                                    child: DropDownMenu(
                                        options: controller.listOfCourses.value,
                                        model: controller.selectedCourse.value!,
                                        onTapItem:
                                            controller.changeSelectedCourse,
                                        focusNode: _focusNode1,
                                        dropDownColor:
                                            HexColor.fromHex("#293241"),
                                        optionsHeigth: listLabelHeight))),
                          ],
                        ),
                        Column(
                          children: [
                            const CustomText(
                              weight: FontWeight.bold,
                              text: 'Selected professor :',
                            ),
                            SizedBox(
                                width: textFieldWidth,
                                height: textFieldHeight,
                                child: Center(
                                    child: DropDownMenu(
                                        options:
                                            controller.listOfProfessors.value,
                                        model:
                                            controller.selectedProfessor.value!,
                                        onTapItem:
                                            controller.changeSelectedProfessor,
                                        focusNode: _focusNode2,
                                        dropDownColor:
                                            HexColor.fromHex("#293241"),
                                        optionsHeigth: listLabelHeight))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: CalendarFrame(
                                    days: controller.days,
                                    month: controller.month)))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
        //se il controller ha finito di ottenere i dati dalle richieste ma non ha ottenuto nulla :
      } else if (!controller.offline.value &&
          !controller.isLoading.value &&
          controller.data.isEmpty) {
        return Center(
            child: RefreshIndicator(
                onRefresh: () async {
                  controller.refreshModel();
                  _focusNode1.unfocus();
                  _focusNode2.unfocus();
                },
                child: ListView(
                  children: const [
                    CustomText(text: 'No lesson available'),
                  ],
                )));
      } else if (!controller.offline.value && controller.isLoading.value) {
        //altrimenti sta ancora caricando
        return const Center(child: CircularProgressIndicator());
      } else {
        return LayoutBuilder(builder: (context, constraints) => RefreshIndicator(
          onRefresh: ()async{
            controller.refreshModel();
            _focusNode1.unfocus();
            _focusNode2.unfocus();
          },
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: const Center(
                  child: CustomText(text: 'Something went wrong , try again later'),
                ),
              )
            ],
          ),
        ));
      }
    });
  }
}
