// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Password_reset extends StatefulWidget {
  const Password_reset({Key? key}) : super(key: key);

  @override
  _Password_resetState createState() => _Password_resetState();
}

class _Password_resetState extends State<Password_reset> {
  final newpasswordController = TextEditingController();
  final currentpasswordController = TextEditingController();
  final date = DateTime.now().toString();
  late var _currentPassword = "";

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // print(date);
    // print(_currentPassword);
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Icon(
              Icons.security_outlined,
              size: 75,
              color: Colors.black,
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Text(
                  "Current Password ",
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 0, top: 0, bottom: 0),
                  child: TextField(
                    controller: currentpasswordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter password"),
                    // obscureText: true,
                    onTap: () {
                      _firestore
                          .collection("Password")
                          .orderBy("Time", descending: true)
                          .limit(1)
                          .get()
                          .then((querySnapshot) {
                        for (var element in querySnapshot.docs) {
                          // print(element.get("New"));
                          setState(() {
                            _currentPassword = element.get("New");
                          });
                        }
                      });
                    },
                  ),
                ))
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Text(
                  "New Password ",
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 47, right: 0, top: 5, bottom: 0),
                  child: TextField(
                    controller: newpasswordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter password"),
                    // obscureText: true,
                  ),
                ))
              ],
            ),
          ),
          Container(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.refresh_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  // print(_currentPassword);

                  if (_currentPassword == currentpasswordController.text &&
                      currentpasswordController.text.isNotEmpty &&
                      newpasswordController.text.isNotEmpty) {
                    _firestore.collection("Password").doc(date).set({
                      "Time": date,
                      "Previous": _currentPassword,
                      "New": newpasswordController.text
                    });
                    Fluttertoast.showToast(
                      msg: "Password Changed Successfully",
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.green,
                    );
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  } else if (currentpasswordController.text.isEmpty ||
                      newpasswordController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Password cannot be blank",
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.red,
                    );
                    HapticFeedback.lightImpact();
                  } else {
                    Fluttertoast.showToast(
                      msg: "Failed",
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.red,
                    );
                    HapticFeedback.lightImpact();
                  }

                  currentpasswordController.clear();
                  newpasswordController.clear();
                },
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 25),
          //   child: ElevatedButton(
          //     child: Text("First"),
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.cyan,
          //       onPrimary: Colors.white,
          //     ),
          //     onPressed: () {
          //       _firestore
          //           .collection("Password")
          //           .doc(date)
          //           .set({"Time": date, "Previous": "12345", "New": "6789"});
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}
