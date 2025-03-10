import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabse{
  Future<Database> initDatabase() async{
    Directory directory = await getApplicationCacheDirectory();
    String path = join(directory.path, 'cureOption.db');
    var db = await openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
          create table State(
           state_id INTEGER PRIMARY KEY AUTOINCREMENT,
           state_name TEXT NOT NULL
          )''');
    },onUpgrade: (db, oldVersion, newVersion) {}, version: 1);
    return db;
  }
  Future<List<Map<String, dynamic>>> selectAllState() async {
    Database db = await initDatabase();
    return await db.rawQuery("select * from State");
  }
  Future<void> insertState(Map<String, dynamic> state) async {
    Database db = await initDatabase();
    int id = await db.insert("State", state);
  }
  Future<void> deleteState(int state_id) async {
    Database db = await initDatabase();
    int id = await db.delete("State",where: "state_id = ?",whereArgs: [state_id]);
  }
  Future<void> updateState(Map<String, dynamic> state) async {
    Database db = await initDatabase();
    int id = await db.update("State", state, where: "state_id = ?", whereArgs: [state["state_id"]]);
  }

}