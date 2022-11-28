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
  }

  static checkCountAndFetchData() async {
    Map data = await getLocalDataCount();
    int localCount = data["count"];
    String localfirst = data["first"];
    HttpService.getOnlineCount(context).then((onlineData) {
      int count = onlineData["count"];
      String first = onlineData["first"];
      log("count get:" + count.toString() + "first online:$first");
      log("count local:" + localCount.toString() + "first local:$localfirst");
      if (count > 0) {
        LocalStorage.preferences!.setInt("onlinecount", count);
        if ((localCount < count && first == localfirst) || localCount == 0) {
          HttpService.fetchData(context, localCount.toString());
        }
      }
      if (first != localfirst && count > 0 && localCount > 0) {
        clearDatabase();
        checkCountAndFetchData();
      }
    });
  }

  static Future<Map> getLocalDataCount() async {
    var count = 0;
    String first = '';
    List data = await database!
        .rawQuery("Select id from data order by id Desc limit 1");
    if (data.length == 1) {
      count = data.first["id"];
      List data2 = await database!
          .query("data", where: "id=1", columns: ["Registration_No"]);
      // log("data2:" + data2.first.toString());
      if (data2.isNotEmpty) {
        first = data2.first["Registration_No"].toString();
      }
    }
    // await Sqflite.firstIntValue(
    //     await database!.rawQuery('SELECT COUNT(*) FROM data'));
    // List<Map> list = await database!.rawQuery('desc data');

    return {"count": count, "first": first};
  }

  static Future<int> insertRecord(List data) async {
    //  log(data.length.toString());
    String sql = "Insert into data VALUES (";
    int id = 0;
    for (Map<String, dynamic> x in data) {
      //log(x.toString());
      try {
        id = await database!
            .insert("data", x, conflictAlgorithm: ConflictAlgorithm.replace)
            .then((value) {
          // log("insert:$value");
          return value;
        }).onError((error, stackTrace) {
          print("Database error:" + error.toString());
          return 0;
        });
      } catch (e) {
        print("Database error:" + e.toString());
      }
    }
    // log(sql.substring(0, sql.length - 1));
    // try {
    //   await database!.rawInsert(sql).then((value) => log("inserted id:$value"));
    // } catch (e) {
    //   log("isert error: $e");
    // }

    return id;

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
                ? "Registration_No!='' AND Registration_No!=' '"
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
    checkCountAndFetchData();
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
