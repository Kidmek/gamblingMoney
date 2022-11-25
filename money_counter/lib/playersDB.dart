import 'package:hive_flutter/hive_flutter.dart';

class playersDB {
  final Box<dynamic> _players = Hive.box("players");
  final Box<dynamic> _prevPlayers = Hive.box("prev");
  final Box<dynamic> _history = Hive.box("history");

  List allHistory = [];
  List playerNames = [];
  List prevPlayerNames = [];
  Map everything = {"": {}};
  Map prevEverything = {"": {}};
  Iterable<Map<String, Map<String, int>>> allPlayers = {};

  void backup() {
    _prevPlayers.put(0, _players.toMap());
    // _history.add();
    // print("backedup :" + _prevPlayers.toMap().toString());
  }

  void addHistory(String title, Map<String, int> body) {
    _history.add([title, body]);
  }

  void removeHistory() {}

  void deleteAllHistory() {
    _history.clear();
  }

  void fetchHistory() {
    _history.keys.forEach((element) {
      allHistory.add(_history.get(element));
    });
  }

  bool addPlayers(String name) {
    if (_players.containsKey(name)) {
      return false;
    } else {
      backup();
      _players.put(name, {});
      return true;
    }
  }

  void reverse() {
    // print("prev" + _prevPlayers.toMap().toString());
    _players.deleteAll(_players.keys);
    Map temp;
    if (_prevPlayers.containsKey(0)) {
      temp = _prevPlayers.get(0);
      temp.keys.forEach((element) {
        _players.put(element, temp[element]);
      });
    }
    // print("now" + _players.toMap().toString());
  }

  void updatePlayer(String name, Map money) {
    backup();
    Map temp = _players.get(name);

    money.keys.forEach((element) {
      temp[element] = money[element] ?? 0;
    });

    _players.put(name, temp);

    money.keys.forEach((element) {
      Map temp = _players.get(element);
      temp[name] = money[element] == null ? 0 : -money[element];

      _players.put(element, temp);
    });
  }

  void editPlayer(String? name, Map money) {
    Map temp = _players.get(name);
    money.keys.forEach((element) {
      //check if input is null
      if (money[element] != null) {
        // check for first win
        if (temp[element] == null) {
          temp[element] = money[element];
        } else {
          temp[element] += money[element];
        }
      }
    });

    _players.put(name, temp);
    money.keys.forEach((m) {
      Map temp = _players.get(m);
      if (temp[name] == null) {
        temp[name] = -(money[m]);
      } else {
        temp[name] -= (money[m]);
      }
      _players.put(m, temp);
    });
  }

  void deleteAll() {
    backup();
    _players.clear();
  }

  void deletePlayer(String name) {
    backup();
    // _players.clear();
    Map temp = _players.get(name);
    temp.keys.forEach((element) {
      Map temp2 = _players.get(element);
      temp2.remove(name);
      _players.put(element, temp2);
    });
    _players.delete(name);
  }

  void loadData() {
    playerNames = [];
    everything = {};
    _players.keys.forEach((element) {
      everything[element] = _players.get(element);
      playerNames.add(element);
    });
    // _prevPlayers.keys.forEach((element) {
    //   prevEverything[element] = _prevPlayers.get(element);
    //   prevPlayerNames.add(element);
    // });
    // allPlayers = _players.values;
  }
}
