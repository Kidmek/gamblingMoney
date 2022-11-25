import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("players");

  await Hive.openBox("prev");

  await Hive.openBox("history");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
