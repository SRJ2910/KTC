// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use, camel_case_types

import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
              onTap: () {},
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
              hint: "country in menu mode",
              onChanged: (data) {
                print(data);
                _type = data!;
              },
              // selectedItem: "Select",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
                onPressed: () {
                  print(_type);
                  uplaod(_image, _imageName);
                },
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  onPrimary: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  uplaod(var img, String img_name) async {
    if (img != null) {
      var snapShot =
          await _storage.ref().child("KTC_Galllery/$img_name").putFile(img);
    } else {
      print("image is not uploaded in firebase");
    }
  }
}
