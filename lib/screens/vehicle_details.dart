import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:balaji_repo_agency/component/alertdilog.dart';
import 'package:balaji_repo_agency/component/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../component/share_to_whatsapp.dart';
import '../component/snack_bar.dart';

class VehicleDetailScreen extends StatefulWidget {
  String Vehicle;
  VehicleDetailScreen(this.Vehicle);

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  bool loading = false;
  List data = [];
  initState() {
    search();
  }

  search() async {
    var prm = {
      "data": widget.Vehicle != "null" ? widget.Vehicle : null,
    };
    var response = await http
        .post(Uri.parse("http://balajirepo.agency/getdetail.php"),
            body: json.encode(prm))
        .timeout(const Duration(seconds: 34), onTimeout: () {
      showSnackBar("Time out", context);
      setState(() {
        loading = true;
      });
      throw ("Error");
    }).catchError((e) {
      setState(() {
        loading = true;
      });
      if (e is SocketException)
        return showSnackBar("No internet connection", context);
    });
    try {
      log("Runnning===========");
      var obj = jsonDecode(response.body);

      if (obj["status"] == 1) {
        setState(() {
          data = obj["data"] ??
              [
                {"msg:No data was sent"}
              ];
          log(data.toString());
          // log(data.toString());
          loading = true;
        });
      } else {
        setState(() {
          loading = true;
        });
        showSnackBar("No data found", context);
      }
    } catch (e) {
      setState(() {
        loading = true;
      });
      if (e is FormatException) {
        print(e.toString());
        showSnackBar("Server Error.", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.Vehicle);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bala ji Repo Agency"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                  onPressed: () => showExitDialog(
                      "Alert!", "Are you sure to exit?", context),
                  icon: const Icon(Icons.logout))),
        ],
        // automaticallyImplyLeading: false,
      ),
      drawer: MyDrawer(),
      body: ListView(children: [
        !loading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 10,
                  child: LinearProgressIndicator(),
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  String msg = '';
                  for (var x in data[index].keys) {
                    msg +=
                        x.toString() + ": " + data[index][x].toString() + "\n";
                  }
                  double width = MediaQuery.of(context).size.width - 6;
                  Map detail = data[index];
                  return Card(
                      color: Colors.teal,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: detail.length,
                                itemBuilder: (context, i) {
                                  String key = detail.keys.elementAt(i);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          width: width * .35,
                                          child: Text(
                                            "$key",
                                            style: const TextStyle(
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          width: width * .02,
                                          child: const Text(
                                            ":",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          width: width * .45,
                                          child: Text(
                                            "${detail[key]}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      log(msg);
                                      openwhatsapp(msg, context);
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: msg));
                                      showSnackBar("Text Coppied!", context);
                                    },
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ));
                }),
      ]),
    );
  }
}
