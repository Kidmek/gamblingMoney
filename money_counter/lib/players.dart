import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Player extends StatefulWidget {
  int initialStake;
  String name;
  Function(String, String) updateMoney;
  Player({
    Key? key,
    required this.initialStake,
    required this.name,
    required this.updateMoney,
  }) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  TextEditingController textController = TextEditingController();
  int currentStake = 0;

  void incrementStake() {
    setState(() {
      currentStake =
          textController.text.isEmpty ? 0 : int.parse(textController.text);
      currentStake += 5;
      widget.updateMoney(widget.name, currentStake.toString());
      textController.text = currentStake.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            widget.name + " : ",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: TextField(
                  controller: textController
                    ..text = currentStake > 0
                        ? currentStake.toString()
                        : widget.initialStake.toString(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.only(left: 5),
                      counterText: ""),
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  onChanged: (text) {
                    widget.updateMoney(widget.name, text);
                  }),
            ),
          ),
          IconButton(onPressed: incrementStake, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
