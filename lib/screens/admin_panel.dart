import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Screens/search_history.dart';
import '../Screens/search_screen.dart';
import '../Screens/user_list.dart';
import '../Screens/widgets/widget_build_functions.dart';
import '../component/alert_box.dart';
import '../component/snack_bar.dart';
import '../constant.dart';
import '../firebase_services.dart';
import '../httpservices.dart';
import '../local_storage_services.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  var numberCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  bool isInvite = false;
  bool isDeleting = false;
  bool loading = false;
  CollectionReference phone = FirebaseFirestore.instance.collection('phone');
  var screenHeight;
  var screenWidth;
  var text_style = const TextStyle(
      color: Colors.teal,
      // fontSize: 20,
      fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: buildAppBar(context),
          // drawer: MyDrawer(),
          body: ListView(
            children: [
              !loading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            HttpService.fetchData(context, "");
                            // LocalStorage.getLocalDataCount();
                          },
                          child: const Text(
                            'Welcome Admin ',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: buildTextField(numberCtrl, true,
                              "Enter Mobile", "Mobile", Icons.phone),
                        ),
                        isInvite
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: buildTextField(passCtrl, false,
                                    "Create Password", "Password", Icons.lock),
                              )
                            : SizedBox(
                                height: 10,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildBox("Invite as", "User", Icons.person_add, () {
                              if (!isInvite) {
                                showSnackBar("Please create password", context);
                                setState(() {
                                  isInvite = true;
                                });
                              } else {
                                if (validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  FirebaseServices()
                                      .addUser(numberCtrl.text, passCtrl.text,
                                          "user", context)
                                      .then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                }
                              }
                            }),
                            buildBox("Invite as", "Admin", Icons.person_add,
                                () {
                              if (!isInvite) {
                                showSnackBar("Please create password", context);
                                setState(() {
                                  isInvite = true;
                                });
                              } else {
                                if (validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  FirebaseServices()
                                      .addUser(numberCtrl.text, passCtrl.text,
                                          "admin", context)
                                      .then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                }
                              }
                            })
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildBox("Check", "User", Icons.check_circle, () {
                              if (numberCtrl.text.isEmpty) {
                                showSnackBar("Empty Mobile number", context);
                              } else {
                                setState(() {
                                  loading = true;
                                  isInvite = false;
                                });
                                FirebaseServices()
                                    .getUserDetails(context, numberCtrl.text)
                                    .then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                            }),
                            buildBox("Block", "User", Icons.block, () {
                              if (numberCtrl.text.isEmpty) {
                                showSnackBar("Empty Mobile number", context);
                              } else {
                                setState(() {
                                  loading = true;
                                  isInvite = false;
                                });
                                FirebaseServices()
                                    .deleteUser(context, numberCtrl.text)
                                    .then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                            })
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildBox("User", "List", Icons.person, () {
                              // LocalStorage.clearDatabase();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserListScreen()));
                            }),
                            buildBox("Search", "Data", Icons.person, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen()));
                            }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isDeleting
                                ? const Padding(
                                    padding: EdgeInsets.all(80.0),
                                    child: Center(
                                        child: SpinKitWanderingCubes(
                                      color: Colors.green,
                                      size: 50.0,
                                    )),
                                  )
                                : buildBox("Delete", "Data", Icons.delete, () {
                                    showMyDialog(
                                        "Alert!",
                                        "This will delete all data from server. Please confirm again?",
                                        context,
                                        "Confirm",
                                        () {
                                          Navigator.pop(context);
                                          showMyDialog(
                                              "Security check 1",
                                              "This will delete all data from server. Please confirm again?",
                                              context,
                                              "Confirm",
                                              () {
                                                Navigator.pop(context);
                                                showMyDialog(
                                                    "Security check 2",
                                                    "This will delete all data from server. Please confirm again?",
                                                    context,
                                                    "Confirm",
                                                    () {
                                                      Navigator.pop(context);
                                                      showMyDialog(
                                                          "Last Confirmation",
                                                          "Remember! This will delete all data from server.You can't recover data. Please confirm again?",
                                                          context,
                                                          "Confirm",
                                                          () {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {
                                                              isDeleting = true;
                                                            });
                                                            HttpService
                                                                    .clearOnlineDatabase(
                                                                        context)
                                                                .then((value) {
                                                              setState(() {
                                                                isDeleting =
                                                                    false;
                                                                LocalStorage
                                                                    .clearDatabase();
                                                              });
                                                            });
                                                          },
                                                          "NO",
                                                          () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          true);
                                                    },
                                                    "NO",
                                                    () {
                                                      Navigator.pop(context);
                                                    },
                                                    true);
                                              },
                                              "NO",
                                              () {
                                                Navigator.pop(context);
                                              },
                                              true);
                                        },
                                        "NO",
                                        () {
                                          Navigator.pop(context);
                                        },
                                        true);
                                    // LocalStorage.clearDatabase();
                                  }),
                            buildBox("Search ", "History", Icons.search, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchHistoryScreen()));
                            }),
                          ],
                        )
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.all(80.0),
                      child: Center(
                          child: SpinKitWanderingCubes(
                        color: Colors.green,
                        size: 50.0,
                      )),
                    ),
            ],
          )),
    );
  }

  bool validate() {
    if (numberCtrl.text.isEmpty) {
      showSnackBar("Empty Mobile", context);
      return false;
    } else if (numberCtrl.text.length != 10) {
      showSnackBar("Mobile number should be 10 digits.", context);
      return false;
    } else if (passCtrl.text.isEmpty) {
      showSnackBar("Empty password", context);
      return false;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }

  buildBox(String txt1, String txt2, var icon, var function) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: primaryColor,
              offset: const Offset(0.0, 0.0), //(x,y)
              blurRadius: 12.0,
            ),
          ],
          border: Border.all(
            width: 2,
            color: primaryColor,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(5),
        width: screenWidth * .25,
        height: screenWidth * .25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            Text(
              txt1,
              style: text_style,
            ),
            Text(
              txt2,
              style: text_style,
            ),
          ],
        ),
      ),
    );
  }
}
