import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isOpen = false;
  BorderRadius globalBorder = BorderRadius.circular(32.0);

  @override
  Widget build(BuildContext context) {
    double screenHeigth = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => setState(() {
          isOpen = false;
        }),
        child: Center(
          child: AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
            height:
                isOpen ? (screenHeigth * 80) / 100 : (screenHeigth * 15) / 100,
            width: (screenWidth * 80) / 100,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: globalBorder,
            ),
            child: Column(
              children: [
                InkWell(
                    onTap: () => setState(() {
                          isOpen = !isOpen;
                        }),
                    borderRadius: globalBorder,
                    child: LabelDropDownIcon(
                        width: (screenWidth * 80) / 100,
                        heigth: (screenHeigth * 15) / 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LabelDropDownIcon extends StatelessWidget {
  const LabelDropDownIcon({
    Key? key,
    required this.heigth,
    required this.width,
  }) : super(key: key);

  final double heigth;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0), color: Colors.black12),
      height: heigth,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Scegli materia : "),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          )
        ],
      ),
    );
  }
}
