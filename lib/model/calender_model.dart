class Calender {
  int id;
  String title;
  int days;
  Calender({this.id, this.title, this.days});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'days': days};
  }
}
