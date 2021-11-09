import 'package:flutter/material.dart';
import 'package:ktc/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        canvasColor: Colors.cyan[50],
      ),
      routes: {"/": (context) => Homepage()},
    );
  }
}
