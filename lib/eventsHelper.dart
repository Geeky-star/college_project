import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/event.dart';

class EventHelper {
  static final _databaseName = "events.db";
  static final _databaseVersion = 1;

  static final table = "events";
  static final columnId = 'id';
  static final columnDates = 'dates';

  EventHelper._privateConstructor();
  static final EventHelper instance = EventHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    print("path " + path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnDates STRING
    )''');
  }

  Future<int> insert(Events event) async {
    Database db = await instance.database;
    var res = await db.insert(table, event.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnId DESC");
    return res;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }

  Future<void> updateCal(Events event) async {
    Database db = await instance.database;
    return await db.update(
      table,
      event.toMap(),
      where: "$columnId = ?",
      whereArgs: [event.id],
    );
  }
}
