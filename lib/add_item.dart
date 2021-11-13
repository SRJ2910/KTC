// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unnecessary_new, unused_element, unused_local_variable

import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Additem extends StatefulWidget {
  const Additem({Key? key}) : super(key: key);

  @override
  _AdditemState createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {
  var _image;
  var imagePicker;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
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
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.kitchen),
                text: "Kitchenware",
              ),
              Tab(
                icon: Icon(Icons.bathtub_outlined),
                text: "Bathware",
              ),
              Tab(
                icon: Icon(Icons.crop_16_9),
                text: "Bathroom Tiles",
              ),
              Tab(
                icon: Icon(Icons.crop_square),
                text: "Kitchen Tiles",
              ),
              Tab(
                icon: Icon(Icons.crop_3_2),
                text: "Room Tiles",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Center(
            key: Key("Kitchenware"),
            child: picture(),
          ),
          Center(
            key: Key("Bathware"),
            child: picture(),
          ),
          Center(
            child: Text("Tiles - Bathroom"),
          ),
          Center(
            child: Text("Tiles - Kitchen"),
          ),
          Center(
            child: Text("Tiles - RoomFloor"),
          ),
        ]),
      ),
    );
  }

  picture() {
    imagePicker = new ImagePicker();
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
                      children: [
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
                print("object");
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
              mode: Mode.MENU,
              showSelectedItems: true,
              items: [
                "Kitchenware",
                "Bathware",
                "Bathroom Tiles",
                "Kitchen tiles",
                "Room tiles"
              ],
              label: "Type",
              hint: "country in menu mode",
              popupItemDisabled: (String s) => s.startsWith('I'),
              onChanged: print,
              // selectedItem: "Brazil"
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
                onPressed: () {
                  print("Sb Badhiya");
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
}
