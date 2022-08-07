import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../constant.dart';
import '../local_storage_services.dart';

import 'component/snack_bar.dart';

class HttpService {
  static Future<int> getOnlineCount(context) async {
    int count = 0;
    await http
        .post(Uri.parse(apiLink + "getrecordcount.php"), body: null)
        .then((res) {
      print("status code:" + res.statusCode.toString());

      if (res.statusCode == 200) {
        var obj = jsonDecode(res.body);

        if (obj["status"] == 1) {
          count = int.parse(obj["count"]);
          // print(count.toString());
          return count;
        }
      } else {
        return count;
      }
    }).timeout(const Duration(seconds: 34), onTimeout: () {
      showSnackBar("Time out", context);

      throw ("Error");
    }).catchError((e) {
      if (e is SocketException) showSnackBar("No internet connection", context);
    });
    return count;
  }

  static Future<Map> getDetail(context, String args) async {
    Map prm = {"data": args};
    Map data = {};
    await http
        .post(Uri.parse(apiLink + "getDetail.php"), body: jsonEncode(prm))
        .then((res) {
      print("status code:" + res.statusCode.toString());

      if (res.statusCode == 200) {
        var obj = jsonDecode(res.body);

        if (obj["status"] == 1) {
          data = obj["data"][0];
          print(data.toString());
          return data;
        }
      } else {
        return data;
      }
    }).timeout(const Duration(seconds: 34), onTimeout: () {
      showSnackBar("Time out", context);

      throw ("Error");
    }).catchError((e) {
      if (e is SocketException) showSnackBar("No internet connection", context);
    });
    return data;
  }

  static Future<void> fetchData(context, String limit) async {
    print("fetching data limit $limit");
    Map<String, dynamic> prm = {"id": limit};
    await http
        .post(Uri.parse(apiLink + "fetchData.php"), body: jsonEncode(prm))
        .then((res) {
      // print("status code:" + res.statusCode.toString());
      // print("res:" + res.body.toString());
      try {
        if (res.statusCode == 200) {
          var obj = json.decode(res.body);
          // print("status co" + obj["status"]);
          if (obj["status"] == 1) {
            // print("get data");
            List data = obj["data"];
            print("get record:" + data.length.toString());
            LocalStorage.insertRecord(data)
                .then((value) => LocalStorage.checkCountAndFetchData(context));
          }
          // if (obj["status"] == 1) return int.parse(obj["count"]);

        }
      } catch (e) {
        print("Error in res:" + e.toString());
      }
    }).timeout(const Duration(seconds: 34), onTimeout: () {
      showSnackBar("Time out", context);

      throw ("Error");
    }).catchError((e) {
      if (e is SocketException) showSnackBar("No internet connection", context);
    });
    return;
  }

  static Future<void> clearOnlineDatabase(context) async {
    await http
        .post(Uri.parse(apiLink + "clearData.php"), body: null)
        .then((res) {
      print("status code:" + res.statusCode.toString());

      if (res.statusCode == 200) {
        var obj = jsonDecode(res.body);
        if (obj["status"] == 1) {
          showSnackBar("Success fully database cleared please upload new data.",
              context);
        }
      } else {
        return;
      }
    }).timeout(const Duration(seconds: 34), onTimeout: () {
      showSnackBar("Time out", context);

      throw ("Error");
    }).catchError((e) {
      if (e is SocketException) showSnackBar("No internet connection", context);
    });
    return;
  }
}
