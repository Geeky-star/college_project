import 'package:flutter/material.dart';
import 'package:nimo_ka_jarvis/model/todo.dart';
import '../DatabaseHelper.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  TextEditingController textController = TextEditingController();

  List<Todo> taskList = new List();

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          taskList.add(Todo(id: element['id'], title: element['title']));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  void _addToDb() async {
    String task = textController.text;
    var id = await DatabaseHelper.instance.insert(Todo(title: task));
    setState(() {
      taskList.insert(0, Todo(id: id, title: task));
    });
  }

  void _deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      taskList.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todos"),
        ),
        body: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Add here"),
                      controller: textController,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _addToDb();
                      textController.clear();
                    },
                  )
                ],
              ),
              Expanded(
                child: Container(
                  child: taskList.isEmpty
                      ? Container()
                      : ListView.builder(
                          itemBuilder: (ctx, index) {
                            if (index == taskList.length) {
                              return null;
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 2.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(taskList[index].title),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteTask(taskList[index].id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              )
            ],
          ),
        ));
  }
}
