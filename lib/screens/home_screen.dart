import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:balaji_repo_agency/component/component.dart';
import 'package:balaji_repo_agency/component/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  bool dataget = true;
  var rc_number = TextEditingController();
  List data = [];
  String? query;
  search() async {
    setState(() {
      dataget = true;
      loading = false;
    });
    query = rc_number.text;
    var prm = {
      "data": query,
    };
    var response = await http
        .post(Uri.parse("http://balajirepo.agency/getdata.php"),
            body: json.encode(prm))
        .timeout(const Duration(seconds: 34), onTimeout: () {
      showSnackBar("Time out", context);
      setState(() {
        loading = true;
      });
      throw ("Error");
    }).catchError((e) {
      setState(() {
        showSnackBar("Error:" + e.toString(), context);
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
          dataget = false;
          data = obj["data"];
          log(data.toString());
          loading = true;
        });
      } else {
        setState(() {
          loading = true;
          rc_number.clear();
        });
        showSnackBar("No data found", context);
      }
    } catch (e) {
      setState(() {
        loading = true;
      });
      if (e is FormatException) showSnackBar("Server Error.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Balaji Repo Agency"),
        actions: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: logoutActionButton(context))
        ],
        // automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/bg_blur.jpg"))),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .2,
            ),
            //  height: MediaQuery.of(context).size.height*.7,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Column(
              children: [
                const Center(
                  heightFactor: 3,
                  child: Text(
                    "Welcome! User",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.deepPurple),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                loading
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * .1),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: rc_number,
                              decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                  ),
                                  hintText: "Enter Data",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none),
                            )),
                      )
                    : Container(child: const CircularProgressIndicator()),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    print("butn click");
                    if (validate()) {
                      search();
                    }
                    // setState(() {
                    //   dataget = !dataget;
                    // });
                  },
                  child: const Text(
                    "Search",
                    style: TextStyle(fontSize: 17),
                  ),
                  style: buttonStyle(),
                ),
                dataget
                    ? Text("")
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          String msg = '';
                          for (var x in data[index].keys) {
                            msg += x.toString() +
                                ": " +
                                data[index][x].toString() +
                                "\n";
                          }
                          double width = MediaQuery.of(context).size.width - 6;
                          Map detail = data[index];
                          return Card(
                              color: Colors.orange,
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
                                                vertical: 2, horizontal: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 3),
                                                  width: width * .35,
                                                  child: Text(
                                                    "$key",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 3),
                                                  width: width * .02,
                                                  child: const Text(
                                                    ":",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 3),
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
                                              showSnackBar(
                                                  "Text Coppied!", context);
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
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      //     child: log_out_btn ? logoutActionButton(context) : Text("")),
    );
  }

  bool validate() {
    String mobile = this.rc_number.text;
    if (mobile.isEmpty) {
      showSnackBar("Please insert Data", context);
      return false;
    }
    return true;
  }
}
