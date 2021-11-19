// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use, camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:io';
import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:ktc/pasword_reset.dart';

class Add_item extends StatefulWidget {
  const Add_item({Key? key}) : super(key: key);

  @override
  _Add_itemState createState() => _Add_itemState();
}

class _Add_itemState extends State<Add_item> {
  var _image;
  var imagePicker;

  late String _imageName;
  late String _type;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _idController = TextEditingController();

  bool _passwordCheck = false;
  final _passwordController = TextEditingController();
  static const _password = "12345";

  late var _currentPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(
                Icons.home_filled,
                color: Colors.black,
              ),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.add_a_photo,
                color: Colors.black,
              ),
              title: Text("Add Item"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              title: Text("Order"),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Add"),
      ),
      body: Center(
        child: picture(),
      ),
    );
  }

  picture() {
    if (!_passwordCheck) {
      return security();
    }

    imagePicker = ImagePicker();

    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
            child: Container(
              height: 330,
              width: 330,
              decoration: BoxDecoration(
                  color: Colors.cyan.shade300,
                  borderRadius: BorderRadius.circular(20)),
              child: _image != null
                  ? Image.file(
                      _image,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.black,
                          size: 100,
                        ),
                        Text(
                          "Add Photo",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
            ),
            onTap: () async {
              // print("Ha theek h");
              XFile image =
                  await imagePicker.pickImage(source: ImageSource.gallery);

              setState(() {
                _image = File(image.path);
                _imageName = image.path.split('/').last;
                print(image.path.split('/').last);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, top: 30),
            child: TextField(
              textCapitalization: TextCapitalization.words,
              style: TextStyle(),
              decoration: InputDecoration(
                labelText: "Item Name",
                border: OutlineInputBorder(),
              ),
              controller: _nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
            child: TextField(
              textCapitalization: TextCapitalization.words,
              style: TextStyle(),
              decoration: InputDecoration(
                labelText: "Item Id",
                border: OutlineInputBorder(),
              ),
              controller: _idController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
            child: DropdownSearch<String>(
              mode: Mode.BOTTOM_SHEET,
              showSelectedItems: true,
              items: const [
                "Kitchenware",
                "Bathware",
                "Bathroom tiles",
                "Kitchen tiles",
                "Room tiles"
              ],
              label: "Type",
              // hint: "country in menu mode",
              onChanged: (data) {
                print(data);
                _type = data!;
              },
              selectedItem: "Select",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                if (_nameController.text.isEmpty ||
                    _idController.text.isEmpty ||
                    _type.isEmpty ||
                    _image == null) {
                  Fluttertoast.showToast(
                    msg: "Try Again !!!",
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.red,
                  );
                  HapticFeedback.lightImpact();
                } else {
                  setState(() {
                    print(_type);
                    uplaod(_image, _imageName, _nameController.text,
                        _idController.text);
                    Fluttertoast.showToast(
                      msg: "Item added Successfully",
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.green,
                    );
                    HapticFeedback.heavyImpact();
                    _image = null;
                    _nameController.clear();
                    _idController.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  uplaod(var img, String img_name, String name, String id) async {
    if (img != null) {
      var snapShot =
          await _storage.ref().child("KTC_Galllery/$img_name").putFile(img);

      var downloadUrl = await snapShot.ref.getDownloadURL();
      print(downloadUrl);

      _firestore
          .collection(_type)
          .add({"Name": name, "ID": id, "ImageURL": downloadUrl});
    } else {
      print("image is not uploaded in firebase");
      Fluttertoast.showToast(
        msg: "Try again later",
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
      );
    }
  }

  security() {
    print(_currentPassword);
    return Column(
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Password ",
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 47, right: 0, top: 0, bottom: 20),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter password"),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: InkWell(
            child: Text(
              "Reset Password",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  decoration: TextDecoration.underline),
            ),
            splashColor: Colors.white,
            highlightColor: Colors.white,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Password_reset()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 145, right: 145),
          child: ElevatedButton(
              onPressed: () {
                if (_passwordController.text != _currentPassword &&
                    _passwordController.text.isNotEmpty) {
                  Fluttertoast.showToast(
                    msg: "Incorrect Password",
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.red,
                  );
                  HapticFeedback.lightImpact();
                  _passwordController.clear();
                } else if (_passwordController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Password cannot be blank",
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.red,
                  );
                  HapticFeedback.lightImpact();
                  _passwordController.clear();
                } else {
                  setState(() {
                    _passwordCheck = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
                onPrimary: Colors.white,
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.lock_open_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Unlock",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
