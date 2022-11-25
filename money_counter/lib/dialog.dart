import 'package:flutter/material.dart';
import 'package:money_counter/playersDB.dart';

class MyDialog extends StatefulWidget {
  Map players = {"": []};
  VoidCallback save;
  MyDialog({Key? key, required this.save}) : super(key: key);

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  TextEditingController controller = TextEditingController();
  playersDB db = playersDB();
  String warning = '';
  void save() {
    bool res = db.addPlayers(controller.text);
    if (controller.text.isEmpty) {
      setState(() {
        warning = "Please Enter a Name";
      });
    } else if (res) {
      widget.save();
      warning = '';
      controller.clear();
      Navigator.of(context).pop();
    } else {
      setState(() {
        warning = "Name Already Registered";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("New Player")),
      backgroundColor: Colors.blue,
      content: Container(
        height: 120,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              controller: controller,
              maxLength: 11,
              decoration: InputDecoration(
                  hintText: "Player Name",
                  border: const OutlineInputBorder(),
                  errorText: warning.isEmpty ? null : warning,
                  counterText: ""),
            ),
          ),
          ElevatedButton(onPressed: save, child: const Text("Add")),
        ]),
      ),
    );
  }
}
