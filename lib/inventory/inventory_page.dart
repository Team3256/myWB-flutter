import 'package:flutter/material.dart';
import 'package:mywb_flutter/user_info.dart';
import 'package:mywb_flutter/theme.dart';
import 'package:mywb_flutter/user_drawer.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Inventory"),
        backgroundColor: mainColor,
      ),
      drawer: new UserDrawer(),
      body: new Container(
        color: Colors.white,
        child: new Center(
          child: new Text("Inventory"),
        ),
      ),
    );
  }
}
