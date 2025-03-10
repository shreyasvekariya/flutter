import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyClass1{
  Future<Database> initDatabase()async{
    Directory directory = await getApplicationCacheDirectory();
    String path = join(directory.path,'MyDatabase.db');
    var db = await openDatabase(path,onCreate: (db,version)async{
      await db.execute('''
        create table Users(
          id integer primary key autoincrement,
          name text not null
        )
      ''');
    },onUpgrade: (db, oldVersion, newVersion) {}, version: 1);
    return db;
  }
  Future<void> insertUser(Map<String,dynamic> user)async{
    Database db = await initDatabase();
    print(user);
    int id = await db.insert("Users", user);
  }
  Future<List<Map<String,dynamic>>> selectAllUsers()async{
    Database db = await initDatabase();
    return await db.rawQuery("select * from Users");
  }
  Future<void> deleteUser(int uid)async{
    Database db = await initDatabase();
    int id = await db.delete("Users",where: "id=?",whereArgs: [uid]);
  }
  Future<void> updateUser(Map<String,dynamic> map)async{
  Database db = await initDatabase();
  int id = await db.update("Users", map,where: "id=?",whereArgs: [map['id']]);
  }
}