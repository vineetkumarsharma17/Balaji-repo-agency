import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Screens/widgets/widget_build_functions.dart';
import '../firebase_services.dart';
import 'package:share_plus/share_plus.dart';

import '../component/drawer.dart';
import '../constant.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextStyle keyTextStyle = const TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: MyDrawer(),
      appBar: buildAppBar(context),
      body: StreamBuilder(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //  log(snapshot.toString());

          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(80.0),
              child: Center(
                  child: SpinKitWanderingCubes(
                color: Colors.green,
                size: 50.0,
              )),
            );
          } else {
            List<QueryDocumentSnapshot> usersList = snapshot.data.docs;
            return ListView.builder(
                itemCount: usersList.length,
                itemBuilder: ((context, index) {
                  Map data = usersList[index].data() as Map;
                  log(data.toString());
                  return Slidable(
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: (context) {
                            FirebaseServices().deleteFireStoreData(
                                users, usersList[index].id, context);
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            FirebaseServices().deleteFireStoreData(
                                users, usersList[index].id, context);
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                        child: ListTile(
                      onTap: (() {
                        share(usersList[index].id, data["password"],
                            data["role"]);
                      }),
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Name :",
                                  style: keyTextStyle,
                                )),
                                Text(data["name"] ?? "Not Found"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Mobile :",
                                  style: keyTextStyle,
                                )),
                                Text(usersList[index].id),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Password :",
                                  style: keyTextStyle,
                                )),
                                Text(data["password"] ?? "Not Found"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Role :",
                                  style: keyTextStyle,
                                )),
                                Text(data["role"].toUpperCase() ?? "Not Found"),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "City :",
                                  style: keyTextStyle,
                                )),
                                Text(data["city"] ?? "Not Found"),
                              ],
                            ),
                          ]),
                    )),
                  );
                }));
          }
        },
      ),
    );
  }

  void share(String mobile, String pass, String role) async {
    String msg =
        "Hi I Invited you on $companyName app as ${role.toUpperCase()}.Please download our app from $webLink\n";
    msg += "Your User id-$mobile\n";
    msg += "Your password-${pass}";
    await Share.share(msg);
  }
}
