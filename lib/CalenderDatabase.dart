import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model/calender_model.dart';

class CalenderHelper {
  static final _databaseName = "calender.db";
  static final _databaseVersion = 1;

  static final table = "calender";
  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDays = 'days';

  CalenderHelper._privateConstructor();
  static final CalenderHelper instance = CalenderHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTitle STRING NOT NULL,
      $columnDays INTEGER
    )''');
  }

  Future<int> insert(Calender calender) async {
    Database db = await instance.database;
    var res = await db.insert(table, calender.toMap());
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

  Future<void> updateCal(Calender calender) async {
    Database db = await instance.database;
    return await db.update(
      table,
      calender.toMap(),
      where: "$columnId = ?",
      whereArgs: [calender.id],
    );
  }
}
