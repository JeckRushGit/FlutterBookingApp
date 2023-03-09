import 'package:flutter/material.dart';
import '../colors/hexcolor.dart';
import '../custom_text.dart';

class AdminPage extends StatelessWidget  {
  const AdminPage({Key? key}) : super(key: key);

  Future<bool> _test() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _test,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Expanded( //riga titolo pagina admib
                    flex: 1,
                    child: Row(
                      children: [
                        Spacer(flex: 1,),
                        Expanded(flex: 12,child: CustomText(text: "Client Bookings",weight: FontWeight.bold,size: 30,color: HexColor.fromHex("#293241"))),
                      ],
                    ),
                  ),
                  Spacer(flex: 4,)
                ],
              ),
            ),
          ),
        ));
  }
}
