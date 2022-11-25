import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditSinglePlayer extends StatefulWidget {
  String money;
  int initial;
  Function(String, String) updateMoney;
  EditSinglePlayer(
      {Key? key,
      required this.money,
      required this.updateMoney,
      required this.initial})
      : super(key: key);

  @override
  State<EditSinglePlayer> createState() => _EditSinglePlayerState();
}

class _EditSinglePlayerState extends State<EditSinglePlayer> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.money.toString() + " : "),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'-?[0-9]'))
            ],
            // decoration: InputDecoration(
            //     border: MaterialStateUnderlineInputBorder.resolveWith((states) => null)),
            controller: controller..text = widget.initial.toString(),
            textAlign: TextAlign.center,
            onChanged: (value) => widget.updateMoney(value, widget.money),
          ),
        )
      ],
    );
  }
}
