import 'dart:developer';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'httpservices.dart';

class LocalStorage {
  static SharedPreferences? preferences;
  static Database? database;
  static Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    database = await openDatabase(path, version: 1, onOpen: (db) {
      log("database opened");
    }, onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db
          .execute(
              'CREATE TABLE data (id INTEGER PRIMARY KEY, Registration_No TEXT, Chassis_no Text)')
          .then((value) => log("table Created"));
    });
    preferences = await SharedPreferences.getInstance();
    checkCountAndFetchData(context);
  }

  static checkCountAndFetchData(context) async {
    int localCount = await getLocalDataCount();
    HttpService.getOnlineCount(context).then((count) {
      log("count get:" + count.toString());
      log("count local:" + localCount.toString());
      if (count > 0) {
        if (localCount < count) {
          HttpService.fetchData(context, localCount.toString());
        }
      }
      if (localCount > count) {
        clearDatabase();
        checkCountAndFetchData(context);
      }
    });
  }

  static Future<int> getLocalDataCount() async {
    var count = await Sqflite.firstIntValue(
        await database!.rawQuery('SELECT COUNT(*) FROM data'));
    // List<Map> list = await database!.rawQuery('desc data');
    if (count != null) {
      return count;
    } else {
      return 0;
    }
  }

  static insertRecord(List data) {
    //  log(data.length.toString());
    for (Map<String, dynamic> x in data) {
      //log(x.toString());
      database!
          .insert("data", x, conflictAlgorithm: ConflictAlgorithm.replace)
          .onError((error, stackTrace) {
        log(error.toString());
        return 0;
      });
    }
    //  getData();
  }

  static Future<List> getDataByRC(String query, bool isRc) async {
    List data = [];

    await database!
        .query("data",
            limit: 200,
            distinct: true,
            columns: ["Registration_No", "Chassis_no"],
            where: query.isEmpty
                ? "Registration_No!=''"
                : isRc
                    ? "Registration_No Like '%$query' AND Registration_No!=''"
                    : "Registration_No Like '%$query%' AND Registration_No!=''",
            orderBy: 'Registration_No')
        .then((value) => data = value)
        .catchError((e) {
      log(e.toString());
    });
    // log(data.toString());
    return data;
  }

  static clearDatabase() async {
    await database!
        .rawQuery('DELETE FROM data')
        .then((value) => log("deleted"))
        .catchError((e) {
      log(e.toString());
    });
    checkCountAndFetchData(context);
    // database!
    //     .delete("data")
    //     .then((value) => log("delete id" + value.toString()));
  }

  static get isLogin => preferences!.getBool("isLogin") ?? false;
  static setLogin() => preferences!.setBool("isLogin", true);
  static clearLogin() => preferences!.setBool("isLogin", false);

  static get isProfile => preferences!.getBool("isProfile") ?? false;
  static setProfile() => preferences!.setBool("isProfile", true);

  static get getRole => preferences!.getString("role") ?? "";
  static setRole(String role) => preferences!.setString("role", role);
  static clearRole() => preferences!.remove("role");

  static get getNumber => preferences!.getString("number") ?? "";
  static setNumber(String number) => preferences!.setString("number", number);
  static clearNumber() => preferences!.remove("number");

  static get isRegistered => preferences!.getBool("isRegistered") ?? false;
  static setRegistered() => preferences!.setBool("isRegistered", true);

  static String get getName => preferences!.getString("name") ?? getNumber;
  static setName(String name) => preferences!.setString("name", name);

  static Future<void> logOut() async {
    preferences!.clear();
  }
}
