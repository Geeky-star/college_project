import 'package:flutter/material.dart';

class Grocery extends StatefulWidget {
  @override
  _GroceryState createState() => _GroceryState();
}

//quantity, unit, name, strike up, delete
class _GroceryState extends State<Grocery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
    );
  }
}
