import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'CalenderDatabase.dart';
import 'add_ons/calender_add.dart';
import 'add_ons/todos.dart';
import 'mains/calender_view.dart';
import 'model/calender_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple, accentColor: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: SplashMain(),
    );
  }
}

class SplashMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      title: Text(
        "MOM KA JARVIS",
        style: TextStyle(
            color: Colors.deepPurple[600],
            fontWeight: FontWeight.bold,
            fontSize: 24),
      ),
      seconds: 10,
      navigateAfterSeconds: Home(),
      image: Image.asset('assets/1.jpg'),
      photoSize: 200,
      loaderColor: Colors.deepPurple[600],
      backgroundColor: Colors.white,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Calender> taskList = new List();

  @override
  void initState() {
    super.initState();
    CalenderHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          taskList.add(Calender(
              id: element['id'],
              title: element['title'],
              days: element['days']));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  void _deleteTask(int id) async {
    await CalenderHelper.instance.delete(id);
    setState(() {
      taskList.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("here are : ");

    return Scaffold(
        appBar: AppBar(
          title: Text("Mom Ka Jarvis"),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                ListTile(
                  leading: Icon(Icons.library_add),
                  title: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Todos()));
                      },
                      child: Text("My Todos")),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            return showDialog(
                context: context,
                child: AlertDialog(
                  backgroundColor: Colors.pink[100],
                  title: Text(
                    "What you want to add?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  content: Container(
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Calenders()));
                          },
                          child: Text(
                            "Calender",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Todos()));
                          },
                          child: Text(
                            "Todos",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
          child: Icon(Icons.add),
        ),
        body: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
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
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CalenderView(
                                              title: taskList[index].title)));
                                },
                                child: Card(
                                  color: Colors.purple[300],
                                  elevation: 2.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          taskList[index].title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            _deleteTask(taskList[index].id),
                                      ),
                                    ],
                                  ),
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
