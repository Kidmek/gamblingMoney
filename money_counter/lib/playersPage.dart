import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_counter/dialog.dart';
import 'package:money_counter/editDialog.dart';
import 'package:money_counter/playersDB.dart';
import 'package:money_counter/singlePlayer.dart';

class playersPage extends StatefulWidget {
  playersPage({Key? key}) : super(key: key);

  @override
  State<playersPage> createState() => _playersPageState();
}

class _playersPageState extends State<playersPage> {
  TextEditingController controller = TextEditingController();
  bool warning = false;
  playersDB db = playersDB();
  Map players = {"": {}};
  @override
  void initState() {
    db.loadData();
    players = db.everything;
    super.initState();
  }

  void editPlayer(player, money) {
    showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          name: player,
          money: money,
          save: save,
        );
      },
    ).then((context) {
      setState(() {
        db.loadData();
        players = db.everything;
      });
    });
  }

  void save() {
    setState(() {
      db.loadData();
      players = db.everything;
    });
  }

  void addPlayer() {
    showDialog(
      context: context,
      builder: (context) {
        return MyDialog(save: save);
      },
    );
  }

  void deletePlayer(String name) {
    db.deletePlayer(name);
    db.loadData();
    setState(() {
      players.remove(name);
    });
  }

  void deleteEvery() {
    setState(() {
      db.deleteAll();
      players = db.everything;
      players.clear();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Players"), actions: [
        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: GestureDetector(
        //     onTap: () {
        //       showDialog(
        //           context: context,
        //           builder: (context) {
        //             return AlertDialog(
        //               backgroundColor: Color.fromARGB(255, 113, 172, 218),
        //               actions: [
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     ElevatedButton(
        //                         onPressed: () {
        //                           setState(() {
        //                             db.reverse();
        //                             db.loadData();
        //                             players = db.everything;
        //                             Navigator.of(context).pop();
        //                           });
        //                         },
        //                         child: const Text(
        //                           "Yes",
        //                           style: TextStyle(color: Colors.black),
        //                         )),
        //                     ElevatedButton(
        //                         onPressed: () {
        //                           Navigator.of(context).pop();
        //                         },
        //                         child: const Text(
        //                           "No",
        //                           style: TextStyle(color: Colors.black),
        //                         ))
        //                   ],
        //                 )
        //               ],
        //               title: const Center(child: Text("Are You Sure?")),
        //             );
        //           });
        //     },
        //     child: const Icon(Icons.replay_circle_filled),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color.fromARGB(255, 113, 172, 218),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: deleteEvery,
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.black),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        )
                      ],
                      title: const Center(child: Text("Are You Sure?")),
                    );
                  });
            },
            child: const Icon(Icons.delete_forever_sharp),
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: addPlayer,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(children: [
            ...players.keys
                .map((player) => Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: SinglePlayer(
                        editPlayer: (context) =>
                            editPlayer(player, players[player]),
                        name: player,
                        money: players[player],
                        deletePlayer: (context) => deletePlayer(player),
                      ),
                    ))
                .toList()
          ]),
        ),
      ),
    );
  }
}
