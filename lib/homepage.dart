// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<int> data = [];
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 30; i++) {
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              // height: data[index].toDouble() * 2,
              width: 320,
              height: 490,
              color: Colors.lightBlueAccent,
              child: Column(
                children: [
                  Image.network(
                    "https://picsum.photos/200/300",
                  ),
                  Text("i:$index\n${data[index]}"),
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
                  ),
                ),
                _buildItemDetail(),
              ],
            ),
          ),
          Center(
            child: Text("Bath-Ware"),
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
}
