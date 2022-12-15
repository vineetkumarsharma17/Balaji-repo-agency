import 'dart:developer';

import 'package:flutter/material.dart';

import '../Screens/widgets/widget_build_functions.dart';
import '../local_storage_services.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  late double width;
  String number = '';
  Map profile = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile = LocalStorage.getUserProfile;
    number = LocalStorage.getNumber;
    if (profile.isNotEmpty) {
      setState(() {
        log(profile.toString());
        // nameCtrl.text = profile["name"] ?? "";
        // address.text = profile["city"] ?? "";
        // profileImageURL = profile["profilePic"];
        // selfieURL = profile["selfie"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Id Card",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: "Pacifico",
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber,
                      border: Border.all(color: Colors.white)),

                  // height: 450,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            NetworkImage(profile["profilePic"] ?? ""),
                      ),
                      Text(
                        "Name: " + profile["name"] ?? "Not Found",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontFamily: "Pacifico",
                        ),
                      ),
                      Text(
                        "Post: " + profile["degignation"] ?? "Not Found",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.teal[100],
                          fontFamily: "Anton",
                          letterSpacing: 2.3,
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Divider(
                          color: Colors.teal[100],
                        ),
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        //padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.teal,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                number,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        //padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.share_location,
                                color: Colors.teal,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  "Address: " + profile["city"],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        //padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: Colors.teal,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  "Valid tile: " +
                                      DateTime.now()
                                          .add(Duration(days: 31))
                                          .toString()
                                          .substring(0, 10),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildRow(String txt1, String txt2) {
    return Row(
      children: [
        SizedBox(
          width: width * .3,
          child: Text(txt1),
        ),
        SizedBox(
          width: width * .1,
          child: Text(":"),
        ),
        SizedBox(
          width: width * .5,
          child: Text(txt2),
        ),
      ],
    );
  }
}
