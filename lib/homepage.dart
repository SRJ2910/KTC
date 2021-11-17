// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ktc/add.dart';
import 'package:ktc/individual%20item/bathware.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<int> data = [];
  int _focusedIndex = 0;
  var _URLlist = [];

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 5; i++) {
      data.add(Random().nextInt(100) + 1);
    }
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildItemDetail() {
    if (data.length > _focusedIndex) {
      return SizedBox(
        height: 50,
        child: Text("index $_focusedIndex: ${data[_focusedIndex]}"),
      );
    }

    return SizedBox(
      height: 250,
      child: Text("No Data to show"),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    //horizontal
    return SizedBox(
      width: 320,
      // height: 550,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              // height: data[index].toDouble() * 2,
              width: 320,
              height: 530,
              color: Colors.cyan[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    _URLlist[index],
                    height: 450,
                  ),

                  // Text(
                  //   "i:$index\n${data[index]}",
                  //   style: TextStyle(backgroundColor: Colors.greenAccent),
                  // ),
                  Container(
                      color: Colors.black12,
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'AquaLite Blue',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 150),
                            child: Text(
                              'T1234',
                              style: TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 10.0),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _firestore.collection("Room tiles").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        // print(element.get("Name"));
        _URLlist.add(element.get("ImageURL"));
      });
      // print(_URLlist);
    });
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Add_item()));
                },
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
          title: const Text("Home"),
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
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ScrollSnapList(
                    onItemFocus: _onItemFocus,
                    itemSize: 320,
                    itemBuilder: _buildListItem,
                    itemCount: data.length,
                    dynamicItemSize: true,
                    // shrinkWrap: true
                  ),
                ),
                _buildItemDetail(),
              ],
            ),
          ),
          Bathware(),
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
}
