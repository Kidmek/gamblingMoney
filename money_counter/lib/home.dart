import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:money_counter/history.dart';
import 'package:money_counter/players.dart';
import 'package:money_counter/playersDB.dart';

import 'playersPage.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int initialStake = 0;
  playersDB db = playersDB();
  List players = [];
  List temp = [];
  // List money = [];
  Map money = {};
  Map<String, int> newMoney = {};
  Iterable<Map<String, Map<String, int>?>> all = {};
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    db.loadData();
    money = db.everything;
    players = db.playerNames;
    super.initState();
  }

  void incrementStake() {
    initialStake =
        textController.text.isEmpty ? 0 : int.parse(textController.text);
    initialStake += 5;
    textController.text = initialStake.toString();
  }

  void updateStake(String stake) {
    if (stake.isNotEmpty) {
      initialStake = int.parse(stake);
    }
  }

  String? chosen;

  void onChanged(String? value) {
    setState(() {
      chosen = value;
      temp = new List<String>.from(players);
      temp.remove(chosen);
      newMoney = {};
      temp.forEach((temp) {
        if (temp != chosen) {
          newMoney[temp] = initialStake;
        }
      });
    });
  }

  void reset() {
    setState(() {
      chosen = null;
    });
  }

  void addMoney() {
    db.backup();
    int total = 0;
    String winner = "";
    newMoney.forEach(
      (key, value) {
        total += value;
      },
    );
    winner = chosen.toString();

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: Colors.blue.shade400,
            title: Center(
                child: Text(
              winner + " Won " + total.toString(),
              style: TextStyle(color: Colors.black87),
            )),
            titlePadding: EdgeInsets.all(30),
          );
        });

    db.addHistory(winner + " Won " + total.toString(), newMoney);
    db.editPlayer(chosen!, newMoney);
    setState(() {
      chosen = null;
    });
  }

  void updateMoney(String name, String text) {
    if (text.isNotEmpty) {
      newMoney[name] = int.parse(text);
    } else {
      newMoney[name] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: GestureDetector(
            onTap: reset,
            child: const Text("Banker"),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => playersPage())).then((context) {
                    setState(() {
                      db.loadData();
                      money = db.everything;
                      players = db.playerNames;
                    });
                  });
                },
                child: const Icon(Icons.groups),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const History()));
                },
                child: const Icon(Icons.history),
              ),
            ),
          ]),
      floatingActionButton: IconButton(
          splashRadius: 10,
          splashColor: Colors.blue,
          onPressed: chosen == null ? null : addMoney,
          icon:
              Icon(size: 30, color: Colors.blue.shade600, Icons.attach_money)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text(
                    "Winner : ",
                    style:
                        TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                      value: chosen,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: players.map((items) {
                        return DropdownMenuItem(
                          value: items.toString(),
                          child: Text(items.toString()),
                        );
                      }).toList(),
                      onChanged: ((value) => onChanged(value))),
                ]),
                Row(
                  children: [
                    const Text(
                      "Initial Stake : ",
                      style: TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 30,
                      child: TextField(
                          controller: textController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 5.0),
                              counterText: ""),
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          onChanged: (text) => updateStake(text)),
                    ),
                    IconButton(
                        onPressed: incrementStake, icon: const Icon(Icons.add)),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.blue.shade400,
              height: 20,
              indent: 4,
            ),
            if (chosen != null)
              Expanded(
                  // child: ListView.builder(
                  //     physics: ScrollPhysics(),
                  //     itemCount: ((players.length) / 2).ceil(),
                  //     itemBuilder: (context, index) {
                  //       if (index >= players.length - index - 1) {
                  //         if (players[index] == chosen) {
                  //           return SizedBox();
                  //         }
                  //         return Player(
                  //           name: players[index],
                  //           updateMoney: updateMoney,
                  //         );
                  //       } else {
                  //         if (players[index] == chosen) {
                  //           return Player(
                  //             name: players[players.length - index - 1],
                  //             updateMoney: updateMoney,
                  //           );
                  //         } else if (players[players.length - index - 1] ==
                  //             chosen) {
                  //           return Player(
                  //             name: players[index],
                  //             updateMoney: updateMoney,
                  //           );
                  //         } else {
                  //           return Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Player(
                  //                   name: players[index],
                  //                   updateMoney: updateMoney,
                  //                 ),
                  //                 Player(
                  //                   name: players[players.length - index - 1],
                  //                   updateMoney: updateMoney,
                  //                 )
                  //               ]);
                  //         }
                  //       }
                  //     }),
                  child: Wrap(
                children: [
                  ...temp
                      .map((player) => Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Player(
                              initialStake: initialStake,
                              name: player,
                              updateMoney: updateMoney)))
                      .toList()
                ],
              ))
          ],
        ),
      ),
    );
  }
}
