// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class Bathtiles extends StatefulWidget {
  const Bathtiles({Key? key}) : super(key: key);

  @override
  _BathtilesState createState() => _BathtilesState();
}

class _BathtilesState extends State<Bathtiles> {
  List<int> data = [];
  int _focusedIndex = 0;

  final List _urlList = [];
  final List _nameList = [];
  final List _idList = [];

  bool _canShowButton = true;

  @override
  void initState() {
    super.initState();
    firebase(_urlList, _nameList, _idList, data);
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildItemDetail() {
    if (data.length > _focusedIndex) {
      return SizedBox(
        child: Text("nothing"),
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
              width: 320,
              height: 530,
              color: Colors.cyan[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    // _urlList[index],
                    img(_urlList, index),
                    height: 450,
                  ),
                  Container(
                      color: Colors.black12,
                      width: 320,
                      child: Column(
                        children: [
                          Text(
                            _nameList[index],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0),
                          ),
                          Text(
                            "" + _idList[index],
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
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

  void hideWidget() {
    setState(() {
      _canShowButton = !_canShowButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          !_canShowButton
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    IconButton(
                      tooltip: "Refresh",
                      iconSize: 40,
                      highlightColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          hideWidget();
                        });
                      },
                      icon: Icon(Icons.refresh_sharp),
                      splashRadius: 40.0,
                    ),
                    Text("Refresh"),
                  ],
                ),
          Expanded(
            child: ScrollSnapList(
              onItemFocus: _onItemFocus,
              itemSize: 320,
              itemBuilder: _buildListItem,
              itemCount: data.length,
              dynamicItemSize: true,
            ),
          ),
        ],
      ),
    );
  }
}

img(List list, int index) {
  if (index > list.length) {
    return "https://chotu.app/wp-content/uploads/2021/04/coming-soon-message-illuminated-with-light-projector_1284-3622.jpg";
  } else {
    return list[index];
  }
}

firebase(List _urlList, List _nameList, List _idList, List data) async {
  late int length;
  await FirebaseFirestore.instance
      .collection("Bathroom tiles")
      .get()
      .then((querySnapshot) {
    for (var element in querySnapshot.docs) {
      _urlList.add(element.get("ImageURL"));
      _nameList.add(element.get("Name"));
      _idList.add(element.get("ID"));

      length = _nameList.length;
    }
  });
  for (int i = 0; i < length; i++) {
    data.add(Random().nextInt(100) + 1);
  }
}
