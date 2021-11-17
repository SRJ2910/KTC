// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ktc/add.dart';
import 'package:ktc/individual%20item/bathtiles.dart';
import 'package:ktc/individual%20item/bathware.dart';
import 'package:ktc/individual%20item/kitchentiles.dart';
import 'package:ktc/individual%20item/kitchenware.dart';
import 'package:ktc/individual%20item/roomtiles.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
          Kitchenware(),
          Bathware(),
          Bathtiles(),
          Kitchentiles(),
          Roomtiles()
        ]),
      ),
    );
  }
}
