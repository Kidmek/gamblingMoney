import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_counter/editSinglePlayer.dart';
import 'package:money_counter/playersDB.dart';

class EditDialog extends StatefulWidget {
  String name;
  Map money;
  VoidCallback save;
  EditDialog(
      {Key? key, required this.save, required this.money, required this.name})
      : super(key: key);

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  TextEditingController controller = TextEditingController();
  late Map temp;
  playersDB db = playersDB();
  bool warning = false;
  void edit() {
    widget.money = temp;
    db.updatePlayer(widget.name, widget.money);
    controller.clear();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    temp = Map.from(widget.money);
    super.initState();
  }

  void updateMoney(String text, player) {
    if (text.isEmpty) {
      temp[player] = 0;
    } else {
      temp[player] = int.parse(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Center(
            child: ElevatedButton(onPressed: edit, child: const Text("Edit"))),
      ],
      title: Center(child: Text(widget.name)),
      backgroundColor: Colors.blue,
      content: SizedBox(
        height: 200,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...widget.money.keys
                    .map((e) => EditSinglePlayer(
                          money: e,
                          updateMoney: updateMoney,
                          initial: widget.money[e],
                        ))
                    .toList(),
              ]),
        ),
      ),
    );
  }
}
