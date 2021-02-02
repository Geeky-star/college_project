class Events {
  int id;
  String date;
  Events({this.id, this.date});

  Map<String, dynamic> toMap() {
    return {'id': id, 'dates': date};
  }
}
