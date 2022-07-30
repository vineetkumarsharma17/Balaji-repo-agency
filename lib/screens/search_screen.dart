import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Screens/detail_screen.dart';
import '../Screens/widgets/widget_build_functions.dart';
import '../component/drawer.dart';
import '../firebase_services.dart';
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
  bool loading = false;
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
    setState(() {
      loading = true;
    });
    await LocalStorage.getDataByRC(query, isRc).then((value) {
      log("from db" + value.length.toString());

      // value.forEach((val) {
      //   if (val["Registration_No"].isNotEmpty) {
      //     if (!data.contains(val["Registration_No"])) {
      //       data.add(val["Registration_No"]);
      //       chassisList.add(val["Chassis_no"]);
      //     }
      //   }
      // });
      setState(() {
        //  data = [];

        data = value;
        loading = false;
        // log(data.last["Registration_No"]);
      });
    });
    log("length load" + data.length.toString());
  }

  void getLocalCount() async {
    count = await LocalStorage.getLocalDataCount();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // drawer: MyDrawer(),
        appBar: buildAppBar(context),
        body: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Total Data:${count}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Searched Data:${data.length}",
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
                        rcCtrl, "1234", "Registration No", true)),
                Expanded(
                    child: buildTextField(
                        chassisCtrl, "UP30AB", "Registration No", false))
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
                          itemCount: data.length >= 2
                              ? data.length % 2 == 0
                                  ? (data.length / 2).toInt()
                                  : (data.length / 2).toInt() + 1
                              : data.length,
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
                                                registration_no: data[2 * index]
                                                    ["Registration_No"],
                                                chasiss_no: data[2 * index]
                                                    ["Chassis_no"])));
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        data[2 * index]["Registration_No"],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: data.length - 1 >= 2 * index + 1
                                        ? GestureDetector(
                                            onTap: () {
                                              FirebaseServices()
                                                  .checkLocationPermisson(
                                                      context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailScreen(
                                                            registration_no: data[
                                                                    2 * index +
                                                                        1][
                                                                "Registration_No"],
                                                            chasiss_no: data[
                                                                    2 * index +
                                                                        1]
                                                                ["Chassis_no"],
                                                          )));
                                            },
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  data[2 * index + 1]
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
        setState(() {
          getdata(query, isRc);
        });
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