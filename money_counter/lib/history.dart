import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_counter/playersDB.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  playersDB db = playersDB();
  List history = [];

  @override
  void initState() {
    db.fetchHistory();
    history = db.allHistory;
    super.initState();
  }

  void deleteAll() {
    db.deleteAllHistory();
    setState(() {
      history = [];
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
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
                                  onPressed: deleteAll,
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          // padding: const EdgeInsets.all(20),

          child: Wrap(
            runSpacing: 10,
            spacing: 40,
            children: [
              if (history.isNotEmpty)
                ...history
                    .map(
                      (h) => Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(11)),
                        padding: const EdgeInsets.only(bottom: 20),
                        margin: const EdgeInsets.only(top: 15),
                        child: Column(children: [
                          Center(
                              heightFactor: 2.5,
                              child: Text(h[0],
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold))),
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 40,
                              children: [
                                if (h[1].isNotEmpty)
                                  ...h[1]
                                      .keys
                                      .map((m) => Text(
                                            m.toString() +
                                                " :  " +
                                                h[1][m].toString(),
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
                    )
                    .toList()
              else
                const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
