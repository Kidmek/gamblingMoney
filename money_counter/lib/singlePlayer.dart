import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SinglePlayer extends StatelessWidget {
  final String name;
  final Map money;
  final Function(BuildContext)? deletePlayer;
  final Function(BuildContext)? editPlayer;
  const SinglePlayer(
      {Key? key,
      required this.name,
      required this.money,
      required this.editPlayer,
      required this.deletePlayer})
      : super(key: key);

  double total() {
    double total = 0;
    if (money != null) {
      money.keys.forEach((element) {
        total += money[element];
      });
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(motion: StretchMotion(), children: [
        SlidableAction(
          onPressed: editPlayer,
          icon: Icons.edit,
          borderRadius: BorderRadius.circular(12),
        )
      ]),
      endActionPane: ActionPane(motion: StretchMotion(), children: [
        SlidableAction(
          onPressed: deletePlayer,
          icon: Icons.delete,
          borderRadius: BorderRadius.circular(12),
        )
      ]),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(11)),
        child: Column(children: [
          Center(
              heightFactor: 2.5,
              child: Text(name + " (" + total().toString() + ")",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold))),
          Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: Wrap(
              runSpacing: 10,
              spacing: 40,
              children: [
                if (money.isNotEmpty)
                  ...money.keys
                      .map((m) => Text(
                            m.toString() + " :  " + money[m].toString(),
                            style: TextStyle(fontSize: 16),
                          ))
                      .toList()
                else
                  const SizedBox(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
