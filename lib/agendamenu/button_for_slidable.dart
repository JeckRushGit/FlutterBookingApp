import 'package:flutter/material.dart';
import '../custom_text.dart';


class ButtonSlidableResponse extends StatefulWidget {
  List<String> _arrayListMaterie;
  List<String> _arrayListOrari ;
  List<String> _arrayListProf ;
  int i;
  Function callback;

  ButtonSlidableResponse(List<String> this._arrayListMaterie, List<String> this._arrayListOrari, List<String> this._arrayListProf, int this.i,  {Key? key, required this.callback }) : super(key: key);

  @override
  State<ButtonSlidableResponse> createState() => _ButtonSlidableResponseState();
}

class _ButtonSlidableResponseState extends State<ButtonSlidableResponse> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(30),
      title: CustomText(
        text:  "Do you want to cancel this lesson?" ,
        size: 20,
        weight: FontWeight.bold,
        color: Colors.black,
      ),
      backgroundColor: Color.fromRGBO(220, 220, 220, 1),
      content: Row(
        children: [
          SizedBox(width: 15),
          MaterialButton(
            elevation: 7.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            color: Color.fromRGBO(41, 50, 65, 1),
            padding: EdgeInsets.all(20),
            onPressed: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 15),
                CustomText(
                    text: "No",
                    size: 22,
                    color: Colors.white,
                    weight: FontWeight.bold),
                SizedBox(width: 20),
                CustomText(
                    text: "X",
                    size: 34,
                    color: Colors.red,
                    weight: FontWeight.bold),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(width: 70),
          MaterialButton(
            elevation: 7.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            color: Color.fromRGBO(41, 50, 65, 1),
            padding: EdgeInsets.all(20),
            onPressed: () {
              widget._arrayListMaterie.removeAt(widget.i);
              widget._arrayListOrari.removeAt(widget.i);
              widget._arrayListProf.removeAt(widget.i);
              widget.callback(widget._arrayListMaterie,widget._arrayListOrari,widget._arrayListProf);
              Navigator.pop(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 15),
                CustomText(
                    text: "Yes",
                    size: 22,
                    color: Colors.white,
                    weight: FontWeight.bold),
                SizedBox(width: 20),
                CustomText(
                    text: "O",
                    size: 34,
                    color: Colors.green,
                    weight: FontWeight.bold),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }
}

