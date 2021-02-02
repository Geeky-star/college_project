import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:nimo_ka_jarvis/CalenderDatabase.dart';
import 'package:nimo_ka_jarvis/model/calender_model.dart';
import 'package:nimo_ka_jarvis/model/event.dart';
import '../eventsHelper.dart';

class CalenderView extends StatefulWidget {
  final String title;
  CalenderView({this.title});
  @override
  _CalenderViewState createState() => new _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  int count = 0;
  @override
  void initState() {
    super.initState();

    EventHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          print("dates to be added in _markedDateMap is : ");
          print(element);
          if (element != null) {
            DateTime dates = DateTime.parse(element['dates']);
            _markedDateMap.add(dates, Event(date: dates));
          }
          markedDates.add(Events(id: element['id'], date: element['dates']));
          print("events are in start as : ");
          print(Events(date: element['dates']));
          count = count + 1;
          print(count);
        });
      });
    }).catchError((error) {
      print(error);
    });
    /* setState(() {
      markedDates.forEach((value) {
        DateTime dat = DateTime.parse(value.date);
        _markedDateMap.add(dat, Event(date: dat));
      });
    });
    */
  }

  int results = 1;
  int numberOfDottedDays = 0;
  Color color = Colors.orange;
  DateTime _currentDate = DateTime(2021, 02, 02);
  DateTime _currentDate2 = DateTime(2021, 02, 02);
  String _currentMonth = DateFormat.yMMM().format(DateTime(2021, 02, 02));
  DateTime _targetDateTime = DateTime(2021, 2, 3);
  TextStyle textStyle = TextStyle(color: Colors.black);

  Icon icon = Icon(Icons.event);

  List dates = [];
  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  TextEditingController _quantity = TextEditingController();
  TextEditingController _rate = TextEditingController();

  List<Events> markedDates = new List();

/*
  @override
  void dispose() {
    _quantity.dispose();
    _rate.dispose();
    super.dispose();
  }
  */

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  _addToDb(DateTime date) async {
    var id = await EventHelper.instance.insert(Events(date: date.toString()));
    setState(() {
      markedDates.insert(0, Events(id: id, date: date.toString()));
      print(markedDates[0]);
      print("date to be inserted in database is : ");
      print(date);
      _markedDateMap.add(date, Event(date: date));
    });
  }

  void _deleteTask(int id) async {
    await EventHelper.instance.delete(id);
    setState(() {
      markedDates.removeWhere((element) => element.id == id);
    });
  }

  List<Event> events;

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        if (_markedDateMap.events.containsKey(date)) {
          //delete from database

          final index = markedDates
              .indexWhere((element) => element.date == date.toString());
          if (index >= 0) {
            print("element found : ");
            print(markedDates[index].date);
            print("length before : ");
            print(markedDates.length);
            _deleteTask(markedDates[index].id);
            print("length after : ");
            print(markedDates.length);
          }
          setState(() {
            _currentDate2 = date;
          });
          print("length of markedmap before : ");
          print(_markedDateMap.events.length);
          _markedDateMap.events.remove(
            _currentDate2,
          );
          int totalMarkedays = _markedDateMap.events.length;
          CalenderHelper.instance
              .updateCal(Calender(title: widget.title, days: totalMarkedays));
          print("length of markedmaps after : ");
          print(_markedDateMap.events.length);
        } else {
          _currentDate2 = date;

          //add to database

          _addToDb(date);

          setState(() {
            _currentDate2 = date;
          });
          int days = _markedDateMap.events.length;
          CalenderHelper.instance
              .updateCal(Calender(title: widget.title, days: days));
        }
      },
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      markedDateIconBorderColor: color,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomTextStyle: dates.contains(_currentDate2)
          ? TextStyle(
              color: Colors.purple[800],
              fontSize: 30,
              fontWeight: FontWeight.bold)
          : TextStyle(color: Colors.red),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      dayButtonColor: Colors.transparent,
      markedDateCustomShapeBorder: CircleBorder(),
      markedDateWidget: Icon(
        Icons.circle,
        size: 10,
      ),
      selectedDayButtonColor: Colors.pink[100],
      markedDateShowIcon: false,
      markedDateIconMaxShown: 1,
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return new Scaffold(
        appBar: new AppBar(
          title: widget.title == null ? Text("Calender") : Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 30.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )),
                    FlatButton(
                      child: Text('PREV'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month - 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('NEXT'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month + 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: _calendarCarouselNoHeader,
              ), //

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Total is : " + results.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _quantity,
                  decoration: InputDecoration(
                      labelText: "Quantity",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _rate,
                  decoration: InputDecoration(
                      labelText: "Rate",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 400,
                  color: Colors.purple,
                  child: RaisedButton(
                    color: Colors.purple,
                    onPressed: () {
                      numberOfDottedDays = _markedDateMap.events.length;
                      print(numberOfDottedDays);

                      setState(() {
                        results = result(_quantity.text, _rate.text);
                      });
                      _quantity.clear();
                      _rate.clear();
                    },
                    child: Text(
                      "Total",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 70,
              )
            ],
          ),
        ));
  }

  result(String quantity, String rate) {
    int result = int.parse(quantity) * int.parse(rate) * numberOfDottedDays;
    print("results are : ");
    print(result);
    return result;
  }
}
