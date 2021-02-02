import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class KantaBai extends StatefulWidget {
  @override
  _KantaBaiState createState() => _KantaBaiState();
}

class _KantaBaiState extends State<KantaBai> {
  int results = 0;
  Color color = Colors.orange;
  DateTime _currentDate = DateTime(2020, 12, 5);
  DateTime _currentDate2 = DateTime(2020, 12, 5);
  String _currentMonth = DateFormat.yMMM().format(DateTime(2020, 12, 5));
  DateTime _targetDateTime = DateTime(2021, 2, 3);
  TextStyle textStyle = TextStyle(color: Colors.black);

  Icon icon = Icon(Icons.event);

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );
  List dates = [];
  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  TextEditingController _quantity = TextEditingController();
  TextEditingController _rate = TextEditingController();

  @override
  void dispose() {
    _quantity.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList

    super.initState();
  }

  List<Event> events;

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        if (_markedDateMap.events.containsKey(date)) {
          setState(() {
            _currentDate2 = date;
          });
          print("length of markedmap before : ");
          print(_markedDateMap.events.length);
          _markedDateMap.events.remove(
            _currentDate2,
          );
          print("length of markedmaps after : ");
          print(_markedDateMap.events.length);
          //  dates.remove(date);
        } else {
          _currentDate2 = date;
          //events.add(Event(date: _currentDate2));
          _markedDateMap.add(date, Event(date: _currentDate2));
          print(_markedDateMap);
          setState(() {
            _currentDate2 = date;
          });
          //dates.add(date);
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
          title: new Text("KantaBai"),
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
                      results = result(_quantity.text, _rate.text);
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
    int result = int.parse(quantity) * int.parse(rate);
    print("rseults are");
    print(result);
    return result;
  }
}
