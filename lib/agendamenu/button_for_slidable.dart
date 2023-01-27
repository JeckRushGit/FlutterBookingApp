import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:progetto_ium/agendamenu/agendapage.dart';
import '../custom_text.dart';

class ButtonSlidableResponse extends StatefulWidget {
  List<Lezione> _arrayLezione;
  int i;
  Function callback;

  ButtonSlidableResponse(
      List<Lezione> this._arrayLezione,
      int this.i,
      {Key? key,
      required this.callback})
      : super(key: key);

  @override
  State<ButtonSlidableResponse> createState() =>
      _ButtonSlidableResponseState();
}

class _ButtonSlidableResponseState extends State<ButtonSlidableResponse> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(size: 22, text: "Do you want to cancel?", overflow: TextOverflow.ellipsis,), //but it actually overflows, even with the ellipsis :(
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
            widget._arrayLezione.removeAt(widget.i);
            widget.callback(widget._arrayLezione);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
