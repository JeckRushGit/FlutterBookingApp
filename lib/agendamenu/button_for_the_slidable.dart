import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../custom_text.dart';

class ButtonForSlidableResponse extends StatefulWidget {
  List<String> _arrayListMaterie;
  List<String> _arrayListOrari;
  List<String> _arrayListProf;
  int i;
  Function callback;

  ButtonForSlidableResponse(
      List<String> this._arrayListMaterie,
      List<String> this._arrayListOrari,
      List<String> this._arrayListProf,
      int this.i,
      {Key? key,
      required this.callback})
      : super(key: key);

  @override
  State<ButtonForSlidableResponse> createState() =>
      _ButtonForSlidableResponseState();
}

class _ButtonForSlidableResponseState extends State<ButtonForSlidableResponse> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(size: 22, text: "Do you want to cancel?", overflow: TextOverflow.ellipsis,), //but it actually overflows, even with the ellipsis :<
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Iconsax.close_circle,
            size: 40,
          ),
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: const Icon(
            Iconsax.tick_circle,
            size: 40,
          ),
          color: Colors.green,
          onPressed: () {
            widget._arrayListMaterie.removeAt(widget.i);
            widget._arrayListOrari.removeAt(widget.i);
            widget._arrayListProf.removeAt(widget.i);
            widget.callback(widget._arrayListMaterie, widget._arrayListOrari,
                widget._arrayListProf);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
