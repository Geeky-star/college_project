import 'package:flutter/material.dart';
import 'package:nimo_ka_jarvis/model/calender_model.dart';
import '../CalenderDatabase.dart';
import '../main.dart';

class Calenders extends StatefulWidget {
  @override
  _CalendersState createState() => _CalendersState();
}

class _CalendersState extends State<Calenders> {
  TextEditingController _heading = TextEditingController();

  List<Calender> taskList = new List();

  void _addToDb() async {
    String task = _heading.text;
    var id = await CalenderHelper.instance.insert(Calender(title: task));
    setState(() {
      taskList.insert(0, Calender(id: id, title: task, days: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Calender"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _heading.text != null ? _addToDb() : Text("do work");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
      ),
      body: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onChanged: (val) {},
                  controller: _heading,
                  decoration: InputDecoration(
                      labelText: "Enter title",
                      hintText: "title",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
              ),
            ],
          )),
    );
  }
}
