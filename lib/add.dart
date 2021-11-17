// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use, camel_case_types

import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Add_item extends StatefulWidget {
  Add_item({Key? key}) : super(key: key);

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

  late String _urlList;

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
    imagePicker = ImagePicker();
    // @override
    // void initState() {
    //   super.initState();
    //   imagePicker = new ImagePicker();
    // }

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
                "Bathroom Tiles",
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
                    // toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.red,
                    // textColor: Colors.red,
                    // fontSize: 16.0
                  );
                } else {
                  setState(() {
                    print(_type);
                    uplaod(_image, _imageName, _nameController.text,
                        _idController.text);
                    Fluttertoast.showToast(
                      msg: "Item added Successfully",
                      // toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.green,
                      // textColor: Colors.red,
                      // fontSize: 16.0
                    );
                    _image = null;
                    _nameController.clear();
                    _idController.clear();
                  });
                }
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                var _URLlist = [];
                _firestore.collection("Room tiles").get().then((querySnapshot) {
                  querySnapshot.docs.forEach((element) {
                    print(element.get("Name"));
                    _URLlist.add(element.get("Name"));
                  });
                  print(_URLlist);
                  // .forEach((result) {
                  //   // print(result.data().values);
                  //   _urlList = result.data().values.first;

                  //   // print(_urlList);

                  //   _URLlist.add(_urlList);
                  //   print(_URLlist);
                  // });
                });
              },
              child: Text("Get data")),
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

      // _firestore
      //     .collection(_type)
      //     .add({"Name": name, "ID": id, "ImageURL": downloadUrl});

      // _firestore
      //     .collection(_type).add({}).

      // if (_type == "Kitchenware") {
      //   _firestore.collection("");
      // } else if (_type == "Bathware") {
      // } else if (_type == "Bathroom Tiles") {
      // } else if (_type == "Kitchen Tiles") {
      // } else if (_type == "Room Tiles") {}
    } else {
      print("image is not uploaded in firebase");
      Fluttertoast.showToast(
        msg: "Try again later",
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
      );
    }
  }
}
