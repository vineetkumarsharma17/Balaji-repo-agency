import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Screens/detail_screen.dart';
import '../Screens/widgets/widget_build_functions.dart';
import '../component/drawer.dart';
import '../firebase_services.dart';
import '../httpservices.dart';
import '../local_storage_services.dart';

import '../constant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var rcCtrl = TextEditingController();
  var chassisCtrl = TextEditingController();
  List data = [];
  List data2 = [];
  bool loading = true;
  int count = 0;
  // List<String> chassisList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata("", true);
    getLocalCount();
  }

  void getdata(String query, bool isRc) async {
    await LocalStorage.getDataByRC(
            query, isRc, chassisCtrl.text.isEmpty ? "" : chassisCtrl.text)
        .then((value) {
      log("from db" + value.length.toString());

      // if (value.length < 1) {
      if (false) {
        setState(() {
          data.clear();
          data2.clear();
          loading = true;
        });
        HttpService.getOnlineData(context, query).then((val) {
          if (val != null && val.isNotEmpty) {
            setState(() {
              value = val;
              int len = value.length > 0 ? (value.length / 2).toInt() + 1 : 0;
              data = value.sublist(0, len);
              data2 = value.sublist(len, value.length);
              loading = false;
            });
          } else {
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        setState(() {
          //  data = [];
          int len = value.length > 0 ? (value.length / 2).toInt() + 1 : 0;
          data = value.sublist(0, len);
          data2 = value.sublist(len, value.length);
          loading = false;
          // log("length get from database" + value.length.toString());
          // log(data.last["Registration_No"]);
        });
      }
    });
  }

  void getLocalCount() async {
    count =
        await LocalStorage.getLocalDataCount().then((value) => value["count"]);
    setState(() {
      // log("hhkh");
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), (() {
      getLocalCount();
    }));
    // log("data 1:" + data.length.toString());
    // log("data 2:" + data2.length.toString());
    // log("total:" + data2.length.toString());
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: buildAppBar(context),
        body: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  LocalStorage.clearDatabase();
                },
                child: Text(
                  "Total Data:${count}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "Searched Data:${data.length + data2.length}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                    child: buildTextField(
                        chassisCtrl, "UP30AB", "Registration No", false)),
                Expanded(
                    child: buildTextField(
                        rcCtrl, "1234", "Registration No", true)),
              ],
            ),
          ),
          loading
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                      child: SpinKitCircle(
                    color: Colors.green,
                    size: 50.0,
                  )),
                )
              : data.length > 0
                  ? Expanded(
                      child: ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: data.length > data2.length
                              ? data.length
                              : data2.length,
                          // itemCount: data.length >= 2
                          //     ? data.length % 2 == 0
                          //         ? (data.length / 2).toInt()
                          //         : (data.length / 2).toInt() + 1
                          //     : data.length,
                          itemBuilder: ((context, index) {
                            int count = data.length >= 2
                                ? data.length % 2 == 0
                                    ? (data.length / 2).toInt()
                                    : (data.length / 2).toInt() + 1
                                : data.length;
                            // log("data is " +
                            //     data.length.toString() +
                            //     " item count " +
                            //     count.toString());
                            // log("data" + data[index].toString());
                            return Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    FirebaseServices()
                                        .checkLocationPermisson(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                registration_no: data[index]
                                                    ["Registration_No"],
                                                chasiss_no: data[index]
                                                    ["Chassis_No"])));
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        data[index]["Registration_No"],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: data2.length > index
                                        ? GestureDetector(
                                            onTap: () {
                                              log(data2[index].toString());
                                              FirebaseServices()
                                                  .checkLocationPermisson(
                                                      context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailScreen(
                                                            registration_no: data2[
                                                                    index][
                                                                "Registration_No"],
                                                            chasiss_no: data2[
                                                                    index]
                                                                ["Chassis_No"],
                                                          )));
                                            },
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  data2[index]
                                                      ["Registration_No"],
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox())
                              ],
                            );
                          })))
                  : const Expanded(
                      child: Center(
                      child: Text("No data Found"),
                    ))
        ]),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController ctrl, String hint, String lable, bool isRc) {
    return TextField(
      controller: ctrl,
      onChanged: (query) {
        if (isRc && query.length >= 4) {
          ctrl.clear();
          getdata(query, isRc);
          return;
        } else {
          setState(() {
            if (!isRc) getdata(query, isRc);
          });
        }
      },
      onSubmitted: (val) {
        ctrl.clear();
      },
      keyboardType: isRc ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        // labelText: lable,
        prefixIcon: Icon(
          Icons.search,
          color: primaryColor,
        ),
        contentPadding: EdgeInsets.zero,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(35.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
      ),
    );
  }
}
