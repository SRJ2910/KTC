// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ktc/add.dart';
import 'package:ktc/homepage.dart';
import 'package:ktc/individual%20item/bathware.dart';

// void main() {
//   Firebase.initializeApp();
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _fbapp = Firebase.initializeApp();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          canvasColor: Colors.cyan[50],
        ),
        // routes: {
        //   // "/": (context) => Homepage(),
        //   // "Add_Item": (context) => Additem(),
        //   // "/": (context) => Additem(),
        //   "/": (context) => Add_item(),
        // },
        home: FutureBuilder(
          future: _fbapp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("There is some error ${snapshot.error.toString()}");
              return Text("There is some error");
            } else if (snapshot.hasData) {
              return Homepage();
            } else {
              return Material(
                //openning page
                animationDuration: Duration(milliseconds: 1),
                color: Colors.white,
                child: Text("Welcome"),
              );
            }
          },
        ));
  }
}
